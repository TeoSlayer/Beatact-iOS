//
//  PaymentMethodRow.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI

struct PaymentMethodRow: View {
    var isPreffered: Bool
    var number : String
    var expm : Int
    var expy : Int
    var brand : String
    var body: some View {
            HStack(alignment: .center) {
                if(brand.lowercased().contains("mastercard")){
                    Image("Mastercard")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.all,5)
                }
                if(brand.lowercased().contains("maestro")){
                    Image("Maestro")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.all,5)
                }
                if(brand.lowercased().contains("visa")){
                    Image("Visa")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.all,5)
                }
                if(brand.lowercased().contains("american")){
                    Image("American Express")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50)
                        .padding(.all,5)
                }
                Text("····\(number)")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                    .padding(.all,5)
                Spacer()
                if(isPreffered == true){
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.green)
                        .frame(height: 20)
                }
                if(expm != 69){
                    Text("\(expm-10 < 0 ? "0" + String(describing: expm) : String(describing: expm))/\(String(describing: expy%100))")
                    .font(.system(size: 15, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                    .padding(.all,10)
                }
                
            }
            .frame(height: 30)
            .frame(maxWidth: .infinity,alignment: .center)
            .padding(.all, 10)
        
        }
}

struct PaymentMethodRow_Previews: PreviewProvider {
    static var previews: some View {
        PaymentMethodRow(isPreffered: true, number: "1231", expm: 8, expy: 2021, brand: "Visa")
    }
}
