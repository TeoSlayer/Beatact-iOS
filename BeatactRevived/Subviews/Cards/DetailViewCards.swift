//
//  DetailViewCards.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI
import MapKit
import MessageUI
import UIKit

struct LocationCard : View{
    var event : Event
    
    var body: some View{
        ZStack{
            Map(coordinateRegion: .constant(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: event.location.lat, longitude: event.location.lon), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))), interactionModes: [],annotationItems: [
                Item(latitude: event.location.lat, longitude: event.location.lon)
        ]) { item in
          MapAnnotation(coordinate: item.coordinate) {
            MapAnnotationPin(name: event.name, venue: event.venue)
            }
          }
        }
    }
}

struct TicketCard : View{
    var order : Order
    var body: some View{
        VStack(alignment: .center){
            Image(uiImage: generateQRCode(from: order.ticketCode + ":" + order.userId))
                    .interpolation(.none)
                    .resizable()
                    .frame(width: 200,height: 200)
                    .border(beatactViolet, width: 4)
                    .padding(.bottom,20)
                Text("Booking Number: \(order.ticketCode)")
                    .foregroundColor(beatactViolet)
                Divider()
                Button(action: {
                    AuxAPI.shared.generatePass(eventName : order.event.name, orderId : order.id, eventCode : order.ticketCode,eventPrice : String(describing: order.event.price), eventId: order.event.id)
            }, label: {
                PassbookButtonHelper()
            }).padding()
            }.padding(.bottom,10)
        .padding(.top,35)
        .frame(maxWidth: .infinity,alignment: .center)
        .background(Color(UIColor.systemBackground))
        .modifier(EventCardModifier())
        .padding(.all, 10)
        
    }
    
    
}

struct OrganiserCard : View{
    @Environment(\.colorScheme) var colorScheme
    var organiser : Organiser
    var body: some View{
        VStack(alignment: .center){
                HStack{
                    Spacer()
                    NavigationLink(
                        destination: OrganiserProfile(organiser: organiser, ratings: testRatings, events: testEvent),
                        label: {
                            AsyncImage(url: URL(string: organiser.imageLink)!, placeholder:
                                        
                                        {
                                            HStack{
                                                Spacer()
                                                Text("Loading...")
                                                Spacer()
                                            }
                            },image: {Image(uiImage: $0) .resizable()}
                            )
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150,height: 150)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                        })
                    
                    Spacer()
                }
            Text(organiser.name)
                    .font(.system(size: 30, weight: .bold, design: .default))
                    .padding([.top,.leading,.trailing])
            Text(organiser.description)
                    .font(.system(size: 18, weight: .bold, design: .default))
                    .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                    .padding([.bottom,.leading,.trailing])
                Text("Rating")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                Text("4.96★")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                HStack{
                    Spacer()
                    Link(getCall(url: URL(string: organiser.socialLink)!), destination: URL(string: organiser.socialLink)!)
                    getImage(url: URL(string: organiser.socialLink)!)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(beatactViolet)
                        .frame(width: 20, height: 20, alignment: .center)
                    Spacer()
                
                    }.frame(maxWidth: .infinity)
                     .frame(height: 40)
                     .background(Color(UIColor.systemBackground))
                     .modifier(EventCardModifier())
                     .padding()

                
            }.padding(.bottom,10)
        .padding(.top,35)
        .frame(maxWidth: .infinity,alignment: .center)
        .background(Color(UIColor.systemBackground))
        .modifier(EventCardModifier())
        .padding(.all, 10)
    }
    func getImage(url : URL) -> Image{
        let urlString = url.absoluteString
        if urlString.contains("instagram"){
            return Image("instagramicon")
        }
        if urlString.contains("facebook"){
            return Image("facebookicon")
        }
        if urlString.contains("youtube"){
            return Image("youtubeicon")
        }
        else{
            return Image("link-2")
        }
        
    }
    
    func getCall(url : URL) -> String{
        let urlString = url.absoluteString
        if urlString.contains("instagram"){
            return "Instagram"
        }
        if urlString.contains("facebook"){
            return "Facebook"
        }
        if urlString.contains("youtube"){
            return "Youtube"
        }
        else{
            return "Website"
        }
        
    }
}


struct ContactOrganiser : View{
    var organiser : Organiser
    
    var body: some View{
        VStack(alignment: .leading){
            Text("Questions?")
                .font(.system(size: 22, weight: .bold, design: .default))
                .foregroundColor(beatactViolet)
                .padding(.horizontal)
                .padding(.vertical,3)
            Button(action: {}, label: {
                HStack{
                    Text("Email: \(organiser.contactEmail)")
                    Spacer()
                    Image(systemName: "envelope.fill")
                }.padding(.horizontal)
                .padding(.vertical,4)
            })
            Divider()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                HStack{
                    Text("Message: \(organiser.contactPhone)")
                    Spacer()
                    Image(systemName: "message.circle.fill")
                }.padding(.horizontal)
                .padding(.vertical,4)
            })
            Divider()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    HStack{
                        Text("Call: \(organiser.contactPhone)")
                        Spacer()
                        Image(systemName: "phone.fill")
                    }.padding(.horizontal)
                    .padding(.vertical,4)
                
            })
            
            
            
        }.padding()
        .background(Color(UIColor.systemBackground))
        .modifier(EventCardModifier())
        .padding(.all,10)
        
    }
}

struct CheckoutCard: View {
    @Environment(\.colorScheme) var colorScheme
    var title: String
    var price: Float
    
    var body: some View {
        HStack(alignment: .center) {
            Image("ticket")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .padding(.all, 20)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(size: 26, weight: .bold, design: .default))
                    .foregroundColor(.white)
                Text("Personal Ticket")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .foregroundColor(colorScheme == .dark ? .white : .gray)
                HStack {
                    Text(String.init(String(describing: price) + " RON"))
                        .font(.system(size: 16, weight: .bold, design: .default))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                }
            }.padding(.trailing, 20)
            Spacer()
        }
        .frame(height: 150)
        .frame(maxWidth: .infinity,alignment: .center)
        .background(beatactViolet)
        .modifier(EventCardModifier())
        .padding(.all, 10)
    }
}
