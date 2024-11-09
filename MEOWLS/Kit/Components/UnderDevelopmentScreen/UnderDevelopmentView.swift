//
// UnderDevelopmentView.swift
// MEOWLS
//
// Created by Artem Mayer on 09.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//  

import SwiftUI
import UIKit
import Factory

public struct UnderDevelopmentView: View {

    @State public var title: String

    public var body: some View {
        VStack(spacing: 40) {
            Spacer()

            VStack(spacing: 20) {
                Text(headerTitle)
                    .font(.title)
                    .foregroundStyle(Colors.Text.textPrimary.suiColor)
                    .multilineTextAlignment(.center)

                Text("Common.System.underConstructionSubtitle")
                    .font(.body)
                    .foregroundStyle(Colors.Text.textSecondary.suiColor)
                    .multilineTextAlignment(.center)
            }
            Images.underConstruction.suiImage
                .resizable()
                .scaledToFit()
                .shadow(radius: 8)

        }
        .padding(.horizontal)
        .onAppear { title = title.isEmpty ? "Screen title" : title }
        .background(Colors.Background.backgroundWhite.suiColor)
        .navigationTitle(LocalizedStringKey(title))
    }

}

private extension UnderDevelopmentView {

    var headerTitle: String {
        #if Store
            String(format: Strings.Common.System.underConstructionTitle,
                   Strings.Common.System.underConstructionTitleScreen)
        #else
            String(format: Strings.Common.System.underConstructionTitle,
                   Strings.Common.System.underConstructionTitleApp)
        #endif
    }

}

// MARK: - Register container

extension Container {

    var underDevelopmentViewBuilder: ParameterFactory<String, UIViewController> {
        self {
            let view = UnderDevelopmentView(title: $0)
            return DomainHostingController(rootView: view)
        }
    }

}

#if DEBUG

@available(iOS 17, *)
#Preview {
    SceneDelegate.setupAppearance()
    let rootTabController = RootTabController()
    rootTabController.selectedIndex = 1
    return rootTabController
}

#endif
