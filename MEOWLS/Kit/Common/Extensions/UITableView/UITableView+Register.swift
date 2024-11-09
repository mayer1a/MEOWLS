//
//  UITableView+Register.swift
//  MEOWLS
//
//  Created by Artem Mayer on 17.09.2024.
//

import UIKit

public extension UITableView {

    // MARK: - Register UITableViewCell

    func register<C: UITableViewCell>(cell: C.Type, with identifier: String? = nil) {
        self.register(C.self, forCellReuseIdentifier: identifier ?? String(describing: C.self))
    }

    func dequeueReusable<C: UITableViewCell>(cell: C.Type,
                                             with identifier: String? = nil,
                                             for indexPath: IndexPath) -> C {

        let nibName = String(describing: C.self)
        if let cell = self.dequeueReusableCell(withIdentifier: identifier ?? nibName, for: indexPath) as? C {
            return cell
        } else {
            assertionFailure("Wrong cell type or nib file (\(nibName))")
            return C()
        }
    }

    // MARK: - Register UITableViewHeaderFooterView

    func register<H: UITableViewHeaderFooterView>(header: H.Type, with identifier: String? = nil) {
        self.register(H.self, forHeaderFooterViewReuseIdentifier: identifier ?? String(describing: H.self))
    }

    func dequeueReusable<H: UITableViewHeaderFooterView>(header: H.Type, with identifier: String? = nil) -> H {

        let nibName = String(describing: H.self)
        if let header = self.dequeueReusableHeaderFooterView(withIdentifier: identifier ?? nibName) as? H {
            return header
        } else {
            assertionFailure("Wrong cell type or nib file (\(nibName))")
            return H()
        }
    }

}
