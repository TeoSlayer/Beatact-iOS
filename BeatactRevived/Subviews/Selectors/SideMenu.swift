//
//  SideMenu.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI

struct SideMenu: View {
    @Binding var selected: Int
    var options: [String]
    @Environment(\.colorScheme) var colorScheme
        
    var body: some View {
        GeometryReader { geo in
            HStack {
                ForEach(options.indices) { i in
                    Button(action: {
                        withAnimation {
                            self.selected = i
                        }

                    }, label: {
                        Text(options[i])
                            .font(.body)
                            .fontWeight(.bold)
                            .padding(.horizontal, 10)
                            .foregroundColor(self.selected == i ? beatactViolet : colorScheme == .dark ? Color.white : Color.black.opacity(0.6))
                    }).buttonStyle(PlainButtonStyle())

                    if i < options.count - 1 {
                        Divider()
                            .frame(width: nil, height: 45, alignment: .center)
                            .opacity(0.7)
                    }

                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 15)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
            .offset(x: geo.size.height * -0.65, y: -10)
            .rotationEffect(Angle(degrees: -90), anchor: .topLeading)

        }
    }
}


struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu(selected: .constant(1), options: ["Info","Location","Details"])
    }
}
