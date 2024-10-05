//
//  UIDevice+ModelName.swift
//  MEOWLS
//
//  Created by Artem Mayer on 12.09.2024.
//

import UIKit

public extension UIDevice {

    /// pares the deveice name as the standard name
    static var modelName: String {

        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
        // iPhone
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return "4"
        case "iPhone4,1":                                return "4s"
        case "iPhone5,1", "iPhone5,2":                   return "5"
        case "iPhone5,3", "iPhone5,4":                   return "5c"
        case "iPhone6,1", "iPhone6,2":                   return "5s"
        case "iPhone7,2":                                return "6"
        case "iPhone7,1":                                return "6Plus"
        case "iPhone8,1":                                return "6s"
        case "iPhone8,2":                                return "6sPlus"
        case "iPhone9,1", "iPhone9,3":                   return "7"
        case "iPhone9,2", "iPhone9,4":                   return "7Plus"
        case "iPhone8,4":                                return "SE"
        case "iPhone10,1", "iPhone10,4":                 return "8"
        case "iPhone10,2", "iPhone10,5":                 return "8Plus"
        case "iPhone10,3", "iPhone10,6":                 return "X"
        case "iPhone11,2":                               return "XS"
        case "iPhone11,4", "iPhone11,6":                 return "XSMax"
        case "iPhone11,8":                               return "XR"
        case "iPhone12,1":                               return "11"
        case "iPhone12,3":                               return "11Pro"
        case "iPhone12,5":                               return "11ProMax"
        case "iPhone12,8":                               return "SE2"
        case "iPhone13,1":                               return "12Mini"
        case "iPhone13,2":                               return "12"
        case "iPhone13,3":                               return "12Pro"
        case "iPhone13,4":                               return "12ProMax"
        case "iPhone14,2":                               return "13Pro"
        case "iPhone14,3":                               return "13ProMax"
        case "iPhone14,4":                               return "13Mini"
        case "iPhone14,5":                               return "13"
        case "iPhone14,6":                               return "SE3rdGen"
        case "iPhone14,7":                               return "14"
        case "iPhone14,8":                               return "14Plus"
        case "iPhone15,2":                               return "14Pro"
        case "iPhone15,3":                               return "14ProMax"
        case "iPhone15,4":                               return "15"
        case "iPhone15,5":                               return "15Plus"
        case "iPhone16,1":                               return "15Pro"
        case "iPhone16,2":                               return "15ProMax"
        // iPad
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "2"
        case "iPad3,1", "iPad3,2", "iPad3,3":            return "3rdGen"
        case "iPad3,4", "iPad3,5", "iPad3,6":            return "4thGen"
        case "iPad6,11", "iPad6,12":                     return "5thGen"
        case "iPad7,5", "iPad7,6":                       return "6thGen"
        case "iPad7,11", "iPad7,12":                     return "7thGen"
        case "iPad11,6", "iPad11,7":                     return "8thGen"
        case "iPad4,1", "iPad4,2", "iPad4,3":            return "Air"
        case "iPad5,3", "iPad5,4":                       return "Air2"
        case "iPad11,3", "iPad11,4":                     return "Air3rdGen"
        case "iPad13,1", "iPad13,2":                     return "Air4thGen"
        case "iPad2,5", "iPad2,6", "iPad2,7":            return "Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":            return "Mini2"
        case "iPad4,7", "iPad4,8", "iPad4,9":            return "Mini3"
        case "iPad5,1", "iPad5,2":                       return "Mini4"
        case "iPad11,1", "iPad11,2":                     return "Mini5thGen"
        case "iPad6,3", "iPad6,4":                       return "Pro9dot7inch"
        case "iPad7,3", "iPad7,4":                       return "Pro10dot5inch"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4": return "Pro11inch1stGen"
        case "iPad8,9", "iPad8,10":                      return "Pro11inch2ndGen"
        case "iPad6,7", "iPad6,8":                       return "Pro12dot9inch1stGen"
        case "iPad7,1", "iPad7,2":                       return "Pro12dot9inch2ndGen"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8": return "Pro12dot9inch3rdGen"
        case "iPad8,11", "iPad8,12":                     return "Pro12dot9inch4thGen"
        case "iPad12,1":                                 return "9thGenWiFi"
        case "iPad12,2":                                 return "9thGenWiFiCellular"
        case "iPad14,1":                                 return "Mini6thGenWiFi"
        case "iPad14,2":                                 return "Mini6thGenWiFiCellular"
        case "iPad13,4":                                 return "Pro11inch5thGen"
        case "iPad13,5":                                 return "Pro11inch5thGen"
        case "iPad13,6":                                 return "Pro11inch5thGen"
        case "iPad13,7":                                 return "Pro11inch5thGen"
        case "iPad13,8":                                 return "Pro12dot9inch5thGen"
        case "iPad13,9":                                 return "Pro12dot9inch5thGen"
        case "iPad13,10":                                return "Pro12dot9inch5thGen"
        case "iPad13,11":                                return "Pro12dot9inch5thGen"
        case "iPad13,16":                                return "Air5thGenWiFi"
        case "iPad13,17":                                return "Air5thGenWiFiCellular"
        case "iPad13,18":                                return "10thGen"
        case "iPad13,19":                                return "10thGen"
        case "iPad14,3":                                 return "Pro11inch4thGen"
        case "iPad14,4":                                 return "Pro11inch4thGen"
        case "iPad14,5":                                 return "Pro12dot9inch6thGen"
        case "iPad14,6":                                 return "Pro12dot9inch6thGen"

        default:                                         return "undefined"
        }
    }

}

