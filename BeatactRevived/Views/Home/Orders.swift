//
//  Orders.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI

struct Orders: View {
    @EnvironmentObject var orderData : OrderData
    var body: some View {
            ScrollView{
                VStack{
                    ForEach(orderData.Orders){ order in
                        if(order.event.endDate > Date()){
                            OrderWidget(order: order)
                        }
                    }
                    Spacer()
                }
            }.navigationBarTitle("Orders")
    }
}

struct Orders_Previews: PreviewProvider {
    static var previews: some View {
        Orders().environmentObject(OrderData.shared)
    }
}
