//
//  Extensions.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 29.09.2021.
//

import Foundation
import UIKit

extension UIColor {
    convenience init? (hexValue: String, alpha: CGFloat) {
        if hexValue.hasPrefix("#") {
            let scanner = Scanner(string: hexValue)
            scanner.currentIndex = scanner.string.index(after: scanner.currentIndex)
            
            var hexInt32: UInt64 = 0
            if hexValue.count == 7 {
                if scanner.scanHexInt64(&hexInt32) {
                    let red = CGFloat((hexInt32 & 0xFF0000) >> 16) / 255
                    let green = CGFloat((hexInt32 & 0x00FF00) >> 8) / 255
                    let blue = CGFloat(hexInt32 & 0x0000FF) / 255
                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }
        }
        return nil
    }
}

