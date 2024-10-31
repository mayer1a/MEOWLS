//
//  DomainWebView.swift
//  MEOWLS
//
//  Created by Artem Mayer on 31.10.2024.
//

import SwiftUI

public struct DomainWebView: View {

    @State public var url: URL?
    @State public var title: String?
    @State public var asPageSheet: Bool = false

    public var body: some View {
        ZStack {
            Color(.backgroundWhite)
            VStack {
                DomainWebViewControllerRepresentable(url: url, title: title)
                    .edgesIgnoringSafeArea(.all)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.backgroundWhite))
            }
        }
        .padding(.top, asPageSheet ? 40 : 0)
        .ignoresSafeArea(.all, edges: asPageSheet ? [.bottom] : [])
    }

}


#Preview {
    NavigationView {
        DomainWebView(url: "https://static.artemayer.ru/".toURL)
            .navigationBarTitleDisplayMode(.inline)
    }
}
