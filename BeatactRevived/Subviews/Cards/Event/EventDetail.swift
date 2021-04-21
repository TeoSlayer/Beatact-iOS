//
//  EventDetail.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct EventDetail: View {
    @StateObject var locationManager = LocationManager()
        
        var userLatitude: String {
            return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
        }
        
        var userLongitude: String {
            return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
        }
    @EnvironmentObject var navView : NavView
    @State var selected = 0
    @Binding var isActive : Bool
    var event : Event
    var body: some View {
        ZStack{
            if(self.selected == 0){
            ScrollView{
                VStack(alignment: .leading){
                    AsyncImage(url: URL(string: event.images.first!)!, placeholder:
                                
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
                    EventWidgetLarge(event: event)
                    OrganiserCard(organiser: testOrganiser)
                    Spacer()
                }.padding(.leading,60)
            }
            }
            if(self.selected == 2){
                ScrollView{
                VStack(alignment: .leading){
                    AsyncImage(url: URL(string: event.images.first!)!, placeholder:
                                
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
                    LocationCard(event: event)
                        .frame(maxWidth: .infinity,alignment: .center)
                        .frame(height: 400)
                        .modifier(EventCardModifier())
                        .padding(.all, 10)
                    
                    Button(action: {
                        let targetURL = URL(string: "http://maps.apple.com/?daddr=\(event.location.lat),\(event.location.lon)")!
                        let isAvailable = UIApplication.shared.canOpenURL(targetURL)
                        UIApplication.shared.openURL(targetURL)

                    }, label: {
                        HStack{
                            Text("Open In")
                                .font(.system(size: 17, weight: .regular, design: .default))
                                .foregroundColor(.white)
                            Image("Apple-Maps")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.white)
                                .frame(height: 20)
                        }.frame(height: 50)
                        .frame(maxWidth: .infinity,alignment: .center)
                        .background(beatactViolet)
                        .modifier(EventCardModifier())
                        .padding(.all, 10)
                        .padding(.bottom,20)
                        Spacer()
                        
                    })
                        
                }.padding(.leading,60)
              }
            }
            SideMenu(selected: $selected, options: ["Info","Details","Location"])
            VStack(alignment: .center){
                if(!OrderData.shared.orderExists(eventid: event.id)){
                    Spacer()
                    Button(action: {
                        self.navView.selection = "Order"
                    }, label: {
                        HStack{
                        Text("Buy")
                            .foregroundColor(Color.white)
                            .font(.title)
                        Capsule()
                            .foregroundColor(Color.white)
                            .frame(height: 40)
                            .frame(maxWidth: 100)
                            .overlay(Text("\(String.init(String(describing: event.price))) RON")
                                .foregroundColor(beatactViolet))
                            
                        } .frame(height: 50)
                        .frame(maxWidth: .infinity,alignment: .center)
                        .background(beatactViolet)
                        .modifier(EventCardModifier())
                        .padding(.all, 10)
                        .padding(.bottom,20)
                    })
                    NavigationLink(
                        destination: OrderTicket(isActive: self.$isActive, event: event),
                        tag: "Order", selection: $navView.selection){ EmptyView() }
                }
                
                
                
            
               }
                .ignoresSafeArea(.all)
        }.navigationBarTitle(event.name)
    }
    
}

struct EventDetail_Previews: PreviewProvider {
    static var previews: some View {
        EventDetail(isActive: .constant(false), event: testEvent).environmentObject(NavView.shared)
    }
}
