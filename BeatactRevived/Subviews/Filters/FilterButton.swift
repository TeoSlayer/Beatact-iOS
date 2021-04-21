//
//  FilterButton.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI

struct FilterButton: View {
    @Binding var isActive : Bool
    var body: some View {
        if isActive{
            Circle()
                .foregroundColor(beatactViolet)
                .overlay(Image(systemName: "slider.horizontal.3").resizable().aspectRatio(contentMode: .fit).foregroundColor(.white).frame(height : 27))
                .frame(height:50)
        }
        else{
            Circle()
                .stroke(lineWidth: 2)
                .foregroundColor(beatactViolet)
                .overlay(Image(systemName: "slider.horizontal.3").resizable().aspectRatio(contentMode: .fit).foregroundColor(beatactViolet).frame(height : 27))
                .frame(height:50)
        }
    }
}

struct FilterButton_Previews: PreviewProvider {
    static var previews: some View {
        FilterButton(isActive: .constant(false))
    }
}
