//
//  PastEvents.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI

struct PastEvents: View {
    @EnvironmentObject var orderData : OrderData
    var body: some View {
            ScrollView{
                VStack{
                    ForEach(orderData.Orders){ order in
                        if(order.event.endDate < Date()){
                            OrderWidget(order: order)
                        }
                    }
                    Spacer()
                }
        }.navigationBarTitle("Past Events")
    }
}

struct PastEvents_Previews: PreviewProvider {
    static var previews: some View {
        PastEvents().environmentObject(OrderData.shared)
    }
}
