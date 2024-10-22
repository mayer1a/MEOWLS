//
//  ImageSlideShow+Extension.swift
//  MEOWLS
//
//  Created by Artem Mayer on 19.10.2024.
//

import ImageSlideshow

public extension ImageSlideshow {

    /// Stop loading when the cell is off-screen and reset the current page
    func closeView() {
        slideshowItems.forEach { item in
            item.cancelPendingLoad()
        }

        currentPageChanged = nil
    }

    /// Stop loading when the cell is off-screen
    func toSleep() {
        slideshowItems.forEach { item in
            item.cancelPendingLoad()
        }
    }

}
