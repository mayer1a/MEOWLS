//
//  UICollectionView+Register.swift
//  MEOWLS
//
//  Created by Artem Mayer on 03.10.2024.
//

import UIKit

extension UICollectionView {

    // MARK: - Register UITableViewCell

    func register<C: UICollectionViewCell>(cell: C.Type, with identifier: String? = nil) {
        register(C.self, forCellWithReuseIdentifier: identifier ?? String(describing: C.self))
    }

    func dequeueReusable<C: UICollectionViewCell>(cell: C.Type,
                                                  with identifier: String? = nil,
                                                  for indexPath: IndexPath) -> C {

        let nibName = String(describing: C.self)
        if let cell = self.dequeueReusableCell(withReuseIdentifier: identifier ?? nibName, for: indexPath) as? C {
            return cell
        } else {
            assertionFailure("Wrong cell type or nib file (\(nibName))")
            return C()
        }
    }

    // MARK: - Register UICollectionReusableView

    func register<H: UICollectionReusableView>(header: H.Type, with identifier: String? = nil) {
        register(H.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: identifier ?? String(describing: H.self))
    }

    func register<F: UICollectionReusableView>(footer: F.Type, with identifier: String? = nil) {
        register(F.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: identifier ?? String(describing: F.self))
    }

    func dequeueReusable<H: UICollectionReusableView>(header: H.Type,
                                                      with identifier: String? = nil,
                                                      for indexPath: IndexPath) -> H {

        let nibName = String(describing: H.self)
        let kind = UICollectionView.elementKindSectionHeader
        let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: nibName, for: indexPath) as? H

        if let header {
            return header
        } else {
            assertionFailure("Wrong cell type or nib file (\(nibName))")
            return H()
        }
    }

    func dequeueReusable<F: UICollectionReusableView>(footer: F.Type,
                                                      with identifier: String? = nil,
                                                      for indexPath: IndexPath) -> F {

        let nibName = String(describing: F.self)
        let kind = UICollectionView.elementKindSectionFooter
        let header = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: nibName, for: indexPath) as? F

        if let header {
            return header
        } else {
            assertionFailure("Wrong cell type or nib file (\(nibName))")
            return F()
        }
    }

}
