//
//  DomainWebViewController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 31.10.2024.
//

import UIKit
import WebKit
import SnapKit

public final class DomainWebViewController: NiblessViewController {

    private var url: URL?
    private var pageTitle: String?
    private var wKWebView: WKWebView!
    private lazy var loader = LoaderWrapper()

    public convenience init(for urlString: String, title: String? = nil) {
        self.init(for: URL(string: urlString), title: title)
    }

    public convenience init(for url: URL? = nil, title: String? = nil) {
        self.init()

        self.title = title
        self.pageTitle = title
        self.url = url
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if url != nil {
            loader.hideLoading()
            wKWebView.stopLoading()
            wKWebView.navigationDelegate = nil
        }
    }

}

public extension DomainWebViewController {

    func reloadWebView(with url: URL) {
        if url != self.url {
            self.url = url
            openPage(with: url)
        }
    }

}

private extension DomainWebViewController {

    func setupUI() {
        view.backgroundColor = UIColor(resource: .backgroundWhite)

        if isModal {
            navigationController?.appendLeftNavigationItems(leftButtons: .close())
        }

        if let url {
            setupWebView()
            setupConstraints()
            openPage(with: url)
        }
    }

    func setupWebView() {
        wKWebView = WKWebView(frame: .zero)
        wKWebView.navigationDelegate = self

        loader.showLoadingOnCenter(inView: view)
    }

    func setupConstraints() {
        view.addSubview(wKWebView)

        wKWebView.snp.makeConstraints { make in
            make.directionalHorizontalEdges.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

}

private extension DomainWebViewController {

    func openPage(with url: URL) {
        let request = URLRequest(url: url)
        wKWebView.load(request)
    }

}

extension DomainWebViewController: WKNavigationDelegate {

    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        loader.showLoadingOnCenter(inView: view)
    }

    public func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @MainActor @escaping (WKNavigationActionPolicy) -> Void) {

        decisionHandler(.allow)
    }

    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        navigationItem.title = pageTitle.isNilOrEmpty ? webView.title : pageTitle
        loader.hideLoading()
        wKWebView.isUserInteractionEnabled = true
    }

    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: any Error) {
        loader.hideLoading()
        wKWebView.isUserInteractionEnabled = true
    }

    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        loader.showLoadingOnCenter(inView: view)
        wKWebView.isUserInteractionEnabled = false
    }

}
