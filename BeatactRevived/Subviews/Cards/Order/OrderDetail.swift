//
//  OrderDetail.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI
import MapKit
import FirebaseAuth
import FirebaseFunctions

struct OrderDetail: View {
    lazy var functions = Functions.functions()
    @State var selected = 0
    var order : Order
    var body: some View {
        ZStack{
            if(self.selected == 0){
            ScrollView{
                VStack(alignment: .leading){
                    AsyncImage(url: URL(string: order.event.images.first!)!, placeholder:
                                
                                {
                                    HStack{
                                        Spacer()
                                        Rectangle()
                                            .foregroundColor(Color.gray.opacity(0.3))
                                            .frame(maxWidth: .infinity)
                                        Spacer()
                                    }
                    },image: {Image(uiImage: $0) .resizable()}
                    )
                        .frame(height: UIScreen.main.bounds.height/3.5)
                        .modifier(EventCardModifier())
                        .padding(.all, 10)
                    EventWidgetLarge(event: order.event)
                    TicketCard(order: order)
                    OrganiserCard(organiser: testOrganiser)
                    Spacer()
                }.padding(.leading,60)
            }
            }
            if(self.selected == 2){
                VStack(alignment: .leading){
                    AsyncImage(url: URL(string: order.event.images.first!)!, placeholder:
                                
                                {
                                    HStack{
                                        Spacer()
                                        Rectangle()
                                            .foregroundColor(Color.gray.opacity(0.3))
                                            .frame(maxWidth: .infinity)
                                        Spacer()
                                    }
                    },image: {Image(uiImage: $0) .resizable()}
                    )
                        .frame(height: UIScreen.main.bounds.height/3.5)
                        .modifier(EventCardModifier())
                        .padding(.all, 10)
                    LocationCard(event: order.event)
                        .modifier(EventCardModifier())
                        .padding(.all, 10)
                        
                }.padding(.leading,60)
            }
            SideMenu(selected: $selected, options: ["Info","Details","Location"])
        }.navigationBarTitle(order.event.name)
    }
    
    
}

struct OrderDetail_Previews: PreviewProvider {
    static var previews: some View {
        OrderDetail(order: testOrder)
    }
}





struct PassbookButtonHelper: View {
    var body: some View {
        PassbookButtonRepresentable()
            .frame(minWidth: 100, maxWidth: 400)
            .frame(height: 60)
            .frame(maxWidth: .infinity)
    }
}

