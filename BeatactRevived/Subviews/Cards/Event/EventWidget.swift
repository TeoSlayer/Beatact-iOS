//
//  EventWidget.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import Combine
import SwiftUI
import URLImage

struct EventWidget: View {
    @State var detailisActive : Bool = false
    var event : Event
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
            VStack(alignment: .leading){
                AsyncImage(url: URL(string: event.images.first!)!, placeholder:
                            
                            {
                                HStack{
                                    Spacer()
                                    Text("Loading...")
                                    Spacer()
                                }
                },image: {Image(uiImage: $0) .resizable()}
                )
                .aspectRatio(contentMode: .fit)
                .clipShape(Rectangle())
                .cornerRadius(15)
                .overlay(
                    Text(event.style)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding([.leading,.trailing])
                        .padding([.top,.bottom],6)
                        .background(Color.yellow)
                        .cornerRadius(5)
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .frame(maxHeight: .infinity,alignment: .top)
                    
                )
            Text(event.name)
                .font(.system(size: 30, weight: .bold, design: .default))
                .padding([.top,.trailing],5)
                .padding(.leading,15)
                Text("\(event.venue), \(event.location.city)")
                .font(.system(size: 14, weight: .bold, design: .default))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                .padding([.bottom,.trailing],5)
                .padding(.leading,15)
            HStack(alignment: .center){
                Text(dateComponents(start: event.startDate))
                .font(.system(size: 16, weight: .bold, design: .default))
                .padding(.leading,15)
                
            }
                Text("Duration: \(duration(start: event.startDate, end: event.endDate))H")
                .font(.system(size: 14, weight: .bold, design: .default))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                .padding([.bottom,.trailing],5)
                .padding(.leading,15)
            
            HStack(alignment: .center){
            Text("Genre:")
                .font(.system(size: 16, weight: .bold, design: .default))

                .padding(.bottom,5)
                .padding(.leading,15)
                ZStack{
                    Rectangle()
                        .cornerRadius(4)
                        .frame(height:25)
                        .foregroundColor(beatactViolet)
                    Text(event.genre)
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                }.frame(width:100)
                Spacer()
            }
            Divider()
                HStack(alignment: .center){
                    
                    Text(String.init(String(describing: event.price) + " RON"))
                        .font(.system(size: 20, weight: .bold, design: .default))
                        
                    Text("for 1 ticket")
                        .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                        .font(.system(size: 16, weight: .bold, design: .default))
                
                    
                    Spacer()
                    NavigationLink(
                        destination: EventDetail(isActive: self.$detailisActive, event: event).environmentObject(NavView.shared), isActive: self.$detailisActive)
                        {
                            Text("View More")
                                .foregroundColor(.blue)
                                .font(.system(size: 15, weight: .bold, design: .default))
                                .contrast(10)
                                .padding(.trailing,15)
                                
                        }.isDetailLink(false)
                         
                    
                    
                }.padding(.leading,15)
                .padding([.top,.bottom],5)
            }.padding(.bottom,5)
             .frame(maxWidth: .infinity,alignment: .center)
             .background(Color(UIColor.systemBackground))
             .modifier(EventCardModifier())
             .padding(.all, 10)
             
             
             
    }
    
    func duration(start: Date, end: Date) -> Int{
        let diffComponents = Calendar.current.dateComponents([.hour], from: start, to: end)
        let hours = diffComponents.hour
        return hours ?? 0
    }
    
    func dateComponents(start: Date) -> String{
        return String("\(String("\(start.monthAsString())")) \(String("\(start.dayAsString())")), \(String("\(start.yearAsString())")) - \(String("\(start.timeAsString())"))")
    }
    
}

struct EventWidgetLarge: View{
    @Environment(\.colorScheme) var colorScheme
    var event : Event
    var body: some View{
        VStack(alignment: .leading){
        Text(event.headline)
            .font(.system(size: 23, weight: .bold, design: .default))
            .padding(.top,5)
            .padding([.top,.trailing],5)
            .padding(.leading,15)
        Text("\(event.venue)")
            .font(.system(size: 14, weight: .bold, design: .default))
            .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
            .padding([.bottom,.trailing],5)
            .padding(.leading,15)
        HStack(alignment: .center){
            
        Text(dateComponents(start: event.startDate))
            .font(.system(size: 16, weight: .bold, design: .default))
            .padding(.leading,15)
            
        }
        Text("Duration: \(duration(start: event.startDate, end: event.endDate))H")
            .font(.system(size: 14, weight: .bold, design: .default))
            .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
            .padding([.bottom,.trailing],5)
            .padding(.leading,15)
        Divider()
        HStack(alignment: .center){
        Text("Genre:")
            .font(.system(size: 16, weight: .bold, design: .default))
            .padding(.bottom,5)
            .padding(.leading,15)
            ZStack{
                Rectangle()
                    .cornerRadius(4)
                    .frame(height:25)
                    .foregroundColor(beatactViolet)
                Text(event.genre)
                    .foregroundColor(.white)
                    .fontWeight(.semibold)
            }.frame(width:100)
            Spacer()
        }
            HStack(alignment: .top){
                
                Text("Artists:")
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .contrast(10)
            
                Text(event.artists.joined(separator: ", "))
                    .font(.system(size: 16, weight: .bold, design: .default))
                    .frame(width: .infinity)
                    .contrast(10)
                    
            }.padding(.leading,15)
            .padding([.top,.bottom],5)
            HStack(alignment: .center){
                
                Text("Event Type:")
                    .font(.system(size: 16, weight: .bold, design: .default))
                Text(event.style)
                    .font(.system(size: 16, weight: .bold, design: .default))
                Spacer()
            }.padding(.leading,15)
            .padding([.top,.bottom],5)
        }.padding(.bottom,5)
         .frame(maxWidth: .infinity,alignment: .center)
         .background(Color(UIColor.systemBackground))
         .modifier(EventCardModifier())
         .padding(.all, 10)
    }
    
    func duration(start: Date, end: Date) -> Int{
        let diffComponents = Calendar.current.dateComponents([.hour], from: start, to: end)
        let hours = diffComponents.hour
        return hours ?? 0
    }
    
    func dateComponents(start: Date) -> String{
        return String("\(String("\(start.monthAsString())")) \(String("\(start.dayAsString())")), \(String("\(start.yearAsString())")) - \(String("\(start.timeAsString())"))")
    }
}

struct EventWidget_Previews: PreviewProvider {
    static var previews: some View {
        EventWidget(event: testEvent)
    }
}
