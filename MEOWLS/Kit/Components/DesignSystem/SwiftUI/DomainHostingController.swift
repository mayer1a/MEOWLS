//
//  DomainHostingController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 23.10.2024.
//

import SwiftUI

public class DomainHostingController<RootView: View>: UIHostingController<RootView> {

    private var navigationBarHidden: Bool = false
    private var dynamicBarShowing: Bool = false
    private var animated: Bool = true
    private var isTransparent: Bool = false
    private var navBarWasHidden: Bool?

    public convenience init(rootView: RootView,
                            navigationBarHidden: Bool = false,
                            dynamicBarShowing: Bool = false,
                            animated: Bool = true,
                            isTransparent: Bool = false) {

        self.init(rootView: rootView)

        self.navigationBarHidden = navigationBarHidden
        self.dynamicBarShowing = dynamicBarShowing
        self.animated = animated
        self.isTransparent = isTransparent

        if self.isTransparent {
            view.isOpaque = false
            view.backgroundColor = .clear
        }
    }

    public override init(rootView: RootView) {
        super.init(rootView: rootView)
    }

    @available(*, unavailable)
    @MainActor public required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(self.animated)

        navBarWasHidden = navigationController?.isNavigationBarHidden
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationController?.setNavigationBarHidden(navigationBarHidden, animated: self.animated)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(self.animated)

        if navBarWasHidden == false, dynamicBarShowing {
            navigationController?.setNavigationBarHidden(false, animated: self.animated)
        }
    }

}
