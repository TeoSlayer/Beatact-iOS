//
//  NavView.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 09.04.2021.
//

import SwiftUI

class NavView : ObservableObject{
    static let shared = NavView()
    
    @Published var addNewCard = false
    @Published var isActive  = false
    @Published var selection: String? = nil
    
    init(){}
    
}
