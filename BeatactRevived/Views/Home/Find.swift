//
//  Find.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI

struct Find: View {
    @EnvironmentObject var eventdata : EventData
    
    
    var body: some View {
            ScrollView{
                VStack{
                    
                    SearchField(isPresented: $eventdata.filterPresented)
                    
                    if(self.eventdata.filterActive == false){
                        ForEach(self.eventdata.Events){event in
                            EventWidget(event: event).environmentObject(NavView.shared)
                        }
                        Button(action: {
                            EventData.shared.retrieveEvents()
                        }, label: {
                            Text("Load More")
                                .foregroundColor(beatactViolet)
                        })
                        
                    }
                    else{
                        ForEach(self.eventdata.FilteredEvents){event in
                            EventWidget(event: event)
                        }
                        
                    
                    }
                    Spacer()
                    }
            }.navigationBarTitle("Find")
            .sheet(isPresented: $eventdata.filterPresented, content: {
                FilterSheet().environmentObject(EventData.shared)
            })
    }
    
}

struct Find_Previews: PreviewProvider {
    static var previews: some View {
        Find().environmentObject(EventData.shared)
    }
}
