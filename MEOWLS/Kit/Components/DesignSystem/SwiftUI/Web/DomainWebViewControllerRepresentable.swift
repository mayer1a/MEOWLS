//
//  DomainWebViewControllerRepresentable.swift
//  MEOWLS
//
//  Created by Artem Mayer on 31.10.2024.
//

import UIKit
import SwiftUI
import WebKit


struct DomainWebViewControllerRepresentable: UIViewControllerRepresentable {
    
    private var url: URL?
    private var title: String?

    init(urlString: String, title: String?) {
        self.init(url: URL(string: urlString), title: title)
    }

    init(url: URL?, title: String?) {
        self.url = url
        self.title = title
    }

    func makeUIViewController(context: Context) -> DomainWebViewController {
        DomainWebViewController(for: url, title: title)
    }

    func updateUIViewController(_ uiViewController: DomainWebViewController, context: Context) {
        if let url {
            uiViewController.reloadWebView(with: url)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject {

        var parent: DomainWebViewControllerRepresentable

        init(_ parent: DomainWebViewControllerRepresentable) {
            self.parent = parent
        }

    }

}
