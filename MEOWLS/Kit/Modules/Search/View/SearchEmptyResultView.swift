//
//  SearchEmptyResultView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 21.10.2024.
//

import UIKit
import SnapKit

final class SearchEmptyResultView: NiblessView {

    private let title: String
    private let subtitle: String

    init(title: String? = nil, subtitle: String? = nil) {
        self.title = title ?? Strings.Catalogue.Searching.noResultsHeader
        self.subtitle = subtitle ?? Strings.Catalogue.Searching.noResultDetails

        super.init()

        setupUI()
    }

    private lazy var containerStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 18

        return stackView
    }()
    private lazy var noResultsLabel = {
        let label = UILabel()
        label.text = title
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textAlignment = .center
        label.textColor = UIColor(resource: .textPrimary)

        return label
    }()
    private lazy var noResultsDescriptionLabel = {
        let label = UILabel()
        label.text = subtitle
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 3
        label.textColor = UIColor(resource: .textTertiary)

        return label
    }()

}

private extension SearchEmptyResultView {

    func setupUI() {
        setupConstraints()
    }

    func setupConstraints() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(noResultsLabel)
        containerStackView.addArrangedSubview(noResultsDescriptionLabel)

        containerStackView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
        }
    }

}
