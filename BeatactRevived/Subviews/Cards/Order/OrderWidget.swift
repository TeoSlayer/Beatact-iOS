//
//  OrderWidget.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI
import CoreImage.CIFilterBuiltins
import UIKit
import URLImage
import PassKit

let context = CIContext()
let filter = CIFilter.qrCodeGenerator()

struct OrderWidget: View {
    @Environment(\.colorScheme) var colorScheme
    var order : Order
    var body: some View {
        VStack(alignment: .center){
            NavigationLink(
                destination: OrderDetail(order: order),
                label: {
                    AsyncImage(url: URL(string: order.event.images.first!)!, placeholder:
                                
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
                })
            
            
            
            Text(order.event.name)
                .font(.system(size: 30, weight: .bold, design: .default))
                .padding([.top,.trailing],5)
                .padding(.leading,15)
            Text("\(order.event.venue), \(order.event.location.city)")
                .font(.system(size: 14, weight: .bold, design: .default))
                .foregroundColor(colorScheme == .dark ? Color.white : Color.gray)
                .padding([.bottom,.trailing],5)
                .padding(.leading,15)
            HStack(alignment: .center){
                Text(dateComponents(start: order.event.startDate))
                .font(.system(size: 16, weight: .bold, design: .default))
                .padding(.leading,15)
                
            }
            
            HStack{
                Spacer()
                VStack{
                    Image(uiImage: generateQRCode(from: order.ticketCode + ":" + order.userId))
                        .interpolation(.none)
                        .resizable()
                        .frame(width: 200,height: 200)
                        .border(beatactViolet, width: 4)
                        .padding(.bottom,20)
                    Text("Booking Number: \(order.ticketCode)")
                        .foregroundColor(beatactViolet)
                        .padding(.bottom,35)
                }
                Spacer()
            }
            
            
            }
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

struct OrderWidget_Previews: PreviewProvider {
    static var previews: some View {
        OrderWidget(order: testOrder)
    }
}

func generateQRCode(from string: String) -> UIImage {
    let data = Data(string.utf8)
    filter.setValue(data, forKey: "inputMessage")

    if let outputImage = filter.outputImage {
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            return UIImage(cgImage: cgimg)
        }
    }

    return UIImage(systemName: "xmark.circle") ?? UIImage()
}
