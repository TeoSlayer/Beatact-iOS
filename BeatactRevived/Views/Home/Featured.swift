//
//  Events.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI

struct Featured: View {
    @EnvironmentObject var eventdata : EventData
    var body: some View {
            ScrollView{
                VStack{
                    ForEach(eventdata.Events){event in
                        EventWidget(event: event).environmentObject(NavView.shared)
                    }
                    Button(action: {
                        EventData.shared.retrieveEvents()
                    }, label: {
                        Text("Load More")
                            .foregroundColor(beatactViolet)
                    })
                    
                    Spacer()
                }
            }.navigationBarTitle("Featured")
        }
}

struct Featured_Previews: PreviewProvider {
    static var previews: some View {
        Featured().environmentObject(EventData.shared)
    }
}
