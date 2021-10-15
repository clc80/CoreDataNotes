//
//  Category.swift
//  Notes
//
//  Created by claudia maciel on 10/14/21.
//

import UIKit

extension Category {
    var color: UIColor? {
        get {
            guard let hex = colorAsHex else { return nil }
            return UIColor(hex: hex)
        }
        set(newColor) {
            if let newColor = newColor {
                colorAsHex = newColor.toHex
            }
        }
    }
}
