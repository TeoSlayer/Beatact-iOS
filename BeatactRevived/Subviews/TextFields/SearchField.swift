//
//  SearchField.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI

struct SearchField: View {
    @State var text : String = ""
    @Binding var isPresented : Bool
    var body: some View {
        ZStack{
            Capsule(style: .circular)
                .stroke(lineWidth: 2)
                .frame(height: 50)
                .foregroundColor(beatactViolet)
                .padding(.all,15)
            HStack{
                TextField("Search...", text: $text)
                    .padding(.leading,50)
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Image(systemName: "magnifyingglass")
                        .padding(.trailing,15)
                })
                Button(action: {
                    self.isPresented = true
                }, label: {
                    Image(systemName: "slider.horizontal.3")
                        .padding(.trailing,35)
                })
            }
        }
    }
}

struct SearchField_Previews: PreviewProvider {
    static var previews: some View {
        SearchField(isPresented: .constant(false))
    }
}
