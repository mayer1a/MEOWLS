//
//  NiblessTableViewController.swift
//  MEOWLS
//
//  Created by Artem Mayer on 26.09.2024.
//

import UIKit

public class NiblessTableViewController: UIViewController {

    public init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable, message: "Loading this table view controller from a nib is unsupported")
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable, message: "Loading this table view controller from a nib is unsupported")
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Loading this table view controller from a nib is unsupported")
    }

}

extension NiblessTableViewController: UITableViewDelegate, UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        fatalError("Should implements \(#function)")
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        fatalError("Should implements \(#function)")
    }
}

extension NiblessTableViewController: UIScrollViewDelegate {}
