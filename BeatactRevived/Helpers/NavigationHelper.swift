//
//  NavigationHelper.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import Foundation
import SwiftUI

class NavigationHelper: ObservableObject {
    static let shared = NavigationHelper()
    @Published var isFindNavActive = false
}
