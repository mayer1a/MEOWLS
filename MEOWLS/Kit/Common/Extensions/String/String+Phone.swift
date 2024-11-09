//
// String+Phone.swift
// MEOWLS
//
// Created by Artem Mayer on 05.11.2024
// Copyright © 2024 Artem Mayer. All rights reserved.
//  

import Foundation
import PhoneNumberKit

extension String {

    func phoneFormatted() -> String {
        let phoneNumberKit = PhoneNumberKit()
        if let number = try? phoneNumberKit.parse(self, withRegion: "RU") {
            return phoneNumberKit.format(number, toType: .international)
        }
        return self
    }

}
