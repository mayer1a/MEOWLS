//
//  IntroViewController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 02.09.2024.
//

import UIKit
import Combine
import SnapKit

final class IntroViewController<VM: IntroViewModelProtocol>: NiblessViewController {

    private var viewModel: VM
    private var cancellables: Set<AnyCancellable> = []

    required init(viewModel: VM) {
        self.viewModel = viewModel
        super.init()

        binding()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        viewModel.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel.viewDidAppear()
    }

    private lazy var brandTextLogoView = {
        let view = UIImageView(image: UIImage(resource: .brandTextLogo))
        view.contentMode = .scaleAspectFit

        return view
    }()
    private lazy var loaderView = UIImageView(image: UIImage(resource: .loader))

    #if POS

    private lazy var posView = {
        let view = UIImageView(image: UIImage(resource: .posLogo))
        view.contentMode = .scaleAspectFit

        return view
    }()

    #endif

}

private extension IntroViewController {

    func setupUI() {
        if viewModel.isStore {
            view.backgroundColor = ColorsAsset.Background.backgroundWhite.color
        } else {
            view.backgroundColor = ColorsAsset.Background.backgroundDark.color
        }

        setupConstraints()
    }

    func setupConstraints() {
        view.addSubview(brandTextLogoView)
        view.addSubview(loaderView)

        brandTextLogoView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }

        loaderView.snp.makeConstraints { make in
            make.centerX.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.snp.centerY).multipliedBy(1.5)
            make.size.equalTo(48.0)
        }

        #if POS
            view.addSubview(posView)

            posView.snp.makeConstraints { make in
                make.centerX.bottom.equalTo(view.safeAreaLayoutGuide)
                make.width.equalTo(120)
                make.height.equalTo(posView.snp.width).dividedBy(2.62)
            }
        #endif
    }

}

private extension IntroViewController {

    func binding() {
        viewModel.isLoadingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self else {
                    return 
                }

                if isLoading {
                    loaderView.rotate()
                } else {
                    loaderView.stopRotating()
                }
            }
            .store(in: &cancellables)
    }

}

// MARK: - Previews

#if DEBUG

private final class MockViewModel: IntroViewModelProtocol {
    
    @Published var isLoading: Bool = false

    var isLoadingPublisher: Published<Bool>.Publisher {
        $isLoading
    }

    #if Store

    let isStore = true

    #else

    let isStore = false

    #endif

    func viewDidLoad() {}

    func viewDidAppear() {
        isLoading = true
    }

    func viewDidDisappear() {
        isLoading = false
    }

}

@available(iOS 17, *)
#Preview {
    IntroViewController(viewModel: MockViewModel())
}

#endif
