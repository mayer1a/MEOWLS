//
//  PreviewUtility.swift
//  MEOWLS
//
//  Created by Artem Mayer on 27.09.2024.
//

import SwiftUI

@available(iOS 17, *)
public struct CustomPreview<Content: View>: View {

    private var content: Content

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
        setupAppearance()
    }

    public var body: some View {
        content
    }

    private func setupAppearance() {
        let uiNavigationBarAppearance = UINavigationBarAppearance()
        uiNavigationBarAppearance.configureWithOpaqueBackground()
        uiNavigationBarAppearance.shadowColor = nil
        uiNavigationBarAppearance.shadowImage = nil
        uiNavigationBarAppearance.backgroundColor = UIColor(resource: .backgroundWhite)
        UINavigationBar.appearance().standardAppearance = uiNavigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = uiNavigationBarAppearance

        let tableHeaderViewFrame = CGRect(x: 0, y: 0, width: 0, height: CGFloat.leastNonzeroMagnitude)
        UITableView.appearance().tableHeaderView = .init(frame: tableHeaderViewFrame)
        UITableView.appearance().sectionHeaderTopPadding = .leastNormalMagnitude

        let appearance = UINavigationBar.appearance()
        appearance.tintColor = UIColor(resource: .textTertiary)
        appearance.backIndicatorImage = UIImage(resource: .navigationBack)
        appearance.backIndicatorTransitionMaskImage = UIImage(resource: .navigationBack)

        UITabBarItem.appearance().badgeColor = UIColor(resource: .accentPrimary)
    }

}
