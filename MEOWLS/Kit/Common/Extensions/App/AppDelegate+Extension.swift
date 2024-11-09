//
//  AppDelegate+Extension.swift
//  MEOWLS
//
//  Created by Artem Mayer on 05.10.2024.
//

import Kingfisher

extension AppDelegate {

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        clearKFCache()
    }

    private func clearKFCache() {
        ImageCache.default.clearMemoryCache()
        KingfisherManager.shared.downloader.cancelAll()
    }

}
