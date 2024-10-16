//
//  ItemsDataSource.swift
//  MEOWLS
//
//  Created by Artem Mayer on 20.09.2024.
//

import Foundation

public class ItemsDataSource<T: Item> {

    public var sections: [Section<T>]

    public init() {
        sections = []
    }

    public subscript(index: Int) -> Section<T> {
        get {
            sections[index]
        }
        set {
            sections[index] = newValue
        }
    }

    public subscript(indexPath: IndexPath) -> T? {
        if sections.count > indexPath.section, self[indexPath.section].items.count > indexPath.row {
            return self[indexPath.section][indexPath.row]
        }
        return nil
    }

    public func changeItem(_ item: T, for indexPath: IndexPath) {
        sections[indexPath.section][indexPath.row] = item
    }

    public func item(at indexPath: IndexPath) -> T? {
        if sections.count > indexPath.section, self[indexPath.section].items.count > indexPath.row {
            return self[indexPath.section][indexPath.row]
        }
        return nil
    }

    public func numberOfSections() -> Int {
        sections.count
    }

    public func numberOfRowsIn(section: Int) -> Int {
        section < sections.count ? sections[section].items.count : 0
    }

    public func isEmpty() -> Bool {
        sections.isEmpty
    }

    public func isLastSection(at indexPath: IndexPath) -> Bool {
        indexPath.section == numberOfSections() - 1
    }

    public func isLastItemInSection(at indexPath: IndexPath) -> Bool {
        indexPath.row == numberOfRowsIn(section: indexPath.section) - 1
    }

    public func isLastItem(at indexPath: IndexPath) -> Bool {
        isLastSection(at: indexPath) && isLastItemInSection(at: indexPath)
    }

    public func isFirstSection(at indexPath: IndexPath) -> Bool {
        indexPath.section == 0
    }

    public func isFirstItemInSection(at indexPath: IndexPath) -> Bool {
        indexPath.row == 0
    }

    public func isFirstItem(at indexPath: IndexPath) -> Bool {
        isFirstSection(at: indexPath) && isFirstItemInSection(at: indexPath)
    }

    public func sectionHasHeader(_ section: Int) -> Bool {
        self[section].header != nil
    }

    public func headerForSection(_ section: Int) -> Any? {
        self[section].header
    }

    public func sectionHasFooter(_ section: Int) -> Bool {
        self[section].footer != nil
    }

    public func footerForSection(_ section: Int) -> Any? {
        self[section].footer
    }

    public func isValid(section: Int) -> Bool {
        section >= 0 && section < self.numberOfSections()
    }

    public func isValid(_ indexPath: IndexPath) -> Bool {
        isValid(section: indexPath.section)
                && indexPath.row >= 0
                && indexPath.row < self.numberOfRowsIn(section: indexPath.section)
    }

}

extension ItemsDataSource where T: Equatable {

    public func item(at indexPath: IndexPath, before targetItem: T) -> Bool {
        guard isValid(indexPath) else { return false }

        let nextIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)

        guard isValid(nextIndexPath) else { return false }

        let nextItem = item(at: nextIndexPath)
        return nextItem == targetItem
    }

    public func item(at indexPath: IndexPath, after targetItem: T) -> Bool {
        guard isValid(indexPath) else { return false }

        let prevIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)

        guard isValid(prevIndexPath) else { return false }

        let prevItem = item(at: prevIndexPath)
        return prevItem == targetItem
    }

    public func indexPath(for item: T?) -> IndexPath? {
        guard let item else { return nil }

        for (section, sectionItem) in sections.enumerated() {
            if let rowIndex = sectionItem.items.firstIndex(where: { $0 == item }) {
                return IndexPath(row: rowIndex, section: section)
            }
//            for (row, rowItem) in sectionItem.items.enumerated() {
//                if case item = rowItem {
//                    return IndexPath(row: row, section: section)
//                }
//            }
        }
        return nil
    }

}
