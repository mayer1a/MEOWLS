//
// AutocompleteFieldViewModel.swift
// MEOWLS
//
// Created Artem Mayer on 04.11.2024.
// Copyright © 2024 Artem Mayer. All rights reserved.
//

import UIKit
import Combine

final class AutocompleteFieldViewModel: AutocompleteFieldViewModelProtocol {

    @Published var query: String
    @Published var textFieldState: DomainLabeledTextField.ViewModel
    @Published private(set) var title: String = ""
    @Published private(set) var hints: [Model.Hint] = []
    @Published private(set) var isLoading: Bool = false

    private let fieldType: Model.FieldType
    private let router: AutocompleteFieldRouterProtocol
    private var selectedCompletion: Model.AutocompleteHandler?
    private let apiService: AutocompleteFieldApiServiceProtocol
    private var cancellables: Set<AnyCancellable> = []

    private let titleAttributeContainer: AttributeContainer = {
        AttributeContainer([.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor(resource: .textPrimary)])
    }()
    private let titleBoldAttributeContainer: AttributeContainer = {
        AttributeContainer([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
    }()

    init(with model: Model.InitialModel) {
        self.query = model.inputModel.inputText ?? ""
        self.fieldType = model.inputModel.fieldType
        self.selectedCompletion = model.inputModel.completion
        self.router = model.router
        self.apiService = model.apiService

        let textFieldLabel: String
        switch model.inputModel.fieldType {
        case .surname: textFieldLabel = "Profile.Edit.surname"
        case .name: textFieldLabel = "Profile.Edit.name"
        case .patronymic: textFieldLabel = "Profile.Edit.patronymic"
        }

        textFieldState = .init(dataState: .init(label: textFieldLabel))

        makeTextFieldSubscription()
    }

}

extension AutocompleteFieldViewModel {

    func viewAppeared() {
        textFieldState.viewState = .focused
    }

    func selected(hint: AttributedString) {
        query = String(hint.characters)
    }

    func complete() {
        router.close(animated: true) { [weak self] in
            guard let self else {
                return
            }

            let query = query
            let selected = self.hints.first {
                String($0.text.characters) == query && $0.gender != nil
            }
            let trimmedText = query.trimmingCharacters(in: .whitespaces)
            self.selectedCompletion?(trimmedText, selected?.gender)
        }
    }

    func lostFocus() {
        textFieldState.viewState = .default
    }

}

private extension AutocompleteFieldViewModel {

    func loadSuggestions(for query: String) {
        guard !query.isEmpty else {
            hints = []
            return
        }

        isLoading = true

        apiService.getSuggestions(for: query, type: fieldType) { [weak self, query] response in
            guard let self else {
                return
            }

            isLoading = false

            guard let data = response.data else {
                return
            }

            let userInput = [
                Model.Hint(text: makeSuggestionString(for: query, with: query), gender: nil)
            ]
            let suggestions = data.map { suggestion in
                let text = self.makeSuggestionString(for: suggestion.text, with: suggestion.highlightedText)
                return Model.Hint(text: text, gender: suggestion.gender)
            }
            
            self.hints = suggestions.isEmpty ? userInput : suggestions
        }
    }

    func makeSuggestionString(for text: String, with highlightedText: String) -> AttributedString {
        var title = AttributedString(text, attributes: titleAttributeContainer)

        if let substringRange = title.range(of: highlightedText) {
            title[substringRange].mergeAttributes(titleBoldAttributeContainer)
        }

        return title
    }

}

private extension AutocompleteFieldViewModel {

    func makeTextFieldSubscription() {
        $query
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            .map({ $0.trimmingCharacters(in: .whitespaces) })
            .removeDuplicates()
            .sink { [weak self] query in
                self?.loadSuggestions(for: query)
            }
            .store(in: &cancellables)
    }

}
