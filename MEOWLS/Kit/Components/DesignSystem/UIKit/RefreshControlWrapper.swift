//
//  RefreshControlWrapper.swift
//  MEOWLS
//
//  Created by Artem Mayer on 08.10.2024.
//

import UIKit
import SnapKit

public final class RefreshControllWrapper: NSObject {

    private let loaderSize: CGFloat = 26.0
    private weak var tableView: UITableView?
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Colors.Accent.accentPrimary.color
        refreshControl.backgroundColor = .clear

        return refreshControl
    }()

}

extension RefreshControllWrapper {

    public func configureRefreshControl(color: UIColor? = nil, tableView: UITableView, target: Any?, action: Selector) {
        refreshControl.tintColor = color ?? refreshControl.tintColor
        refreshControl.addTarget(target, action: action, for: .valueChanged)

        self.tableView = tableView
        self.tableView?.refreshControl = refreshControl
    }

    public func endRefreshingControl(contentOffset: CGPoint = .zero, prorogue: TimeInterval = 0.5, resetOffset: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + prorogue) { [weak self] in
            if resetOffset {
                self?.tableView?.setContentOffset(contentOffset, animated: false)
            }

            self?.tableView?.refreshControl?.endRefreshing()
        }
    }

}
