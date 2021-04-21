//
//  RatingCard.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import SwiftUI

struct RatingCard: View {
    var rating : Rating
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.yellow)
                    .frame(height: 15)
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.yellow)
                    .frame(height: 15)
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.yellow)
                    .frame(height: 15)
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.yellow)
                    .frame(height: 15)
                Image(systemName: "star.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.yellow)
                    .frame(height: 15)
               
            }
            
            Text(rating.title ?? "Rating")
                .font(.system(size: 14, weight: .bold, design: .default))
            
            Text(rating.userName)
                .font(.system(size: 10, weight: .light, design: .default))
            Text(rating.text ?? "")
                .font(.system(size: 8, weight: .bold, design: .default))
            Spacer()
        }.padding()
         .frame(height:100)
         .frame(maxWidth: .infinity,alignment: .leading)
         .background(Color(UIColor.systemBackground))
         .modifier(EventCardModifier())
        .padding(.horizontal, 10)
    }
}

struct RatingCard_Previews: PreviewProvider {
    static var previews: some View {
        RatingCard(rating: testRating)
    }
}
