//
//  Constants.swift
//  BeatActIOS
//
//  Created by Calin Teodor on 6/23/20.
//  Copyright © 2020 Beatact. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

let beatactViolet = Color.accentColor
let beatactVioletUI = Color.accentColor
let beatactSecondaryColor = getColorFromHex(hex: 0x610F7F, alpha: 1.0)
let lightGreyColor = Color(red: 239.0/255.0, green: 243.0/255.0, blue: 244.0/255.0, opacity: 1.0)
let backgroundGrey = getColorFromHex(hex: 0xCACED8, alpha: 1.0)
let grayBackground: Color = Color.gray.opacity(0.2)
let gold = getColorFromHex(hex: 0xAF9500, alpha: 1.0)
let silver = getColorFromHex(hex: 0xD7D7D7, alpha: 1.0)
let bronze = getColorFromHex(hex: 0x6A3805, alpha: 1.0)


func getColorFromHex(hex: UInt, alpha: CGFloat) -> UIColor {
    return UIColor(
        red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((hex & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(hex & 0x0000FF) / 255.0,
        alpha: CGFloat(alpha)
    )
}
