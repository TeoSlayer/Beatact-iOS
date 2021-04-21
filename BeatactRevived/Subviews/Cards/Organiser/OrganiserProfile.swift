//
//  OrganiserProfile.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 01.04.2021.
//

import SwiftUI

struct OrganiserProfile: View {
    var organiser : Organiser
    @State var selected = 0
    var ratings : [Rating]
    var events : Event
    var body: some View {
        ZStack(){
            ScrollView{
                VStack(alignment: .leading){
                    OrganiserCard(organiser: organiser)
                    if(selected == 0){
                        ContactOrganiser(organiser: organiser)
                    }
                    if(selected == 1){
                        ForEach(ratings){rating in
                            RatingCard(rating: rating)
                            
                        }
                    }
                    if(selected == 2){
                        
                    }
                    
                    
                }.padding(.leading,60)
            }
            SideMenu(selected: $selected, options: ["Contact","Ratings","Past Events"])
            
        }
    }
}


struct OrganiserProfile_Previews: PreviewProvider {
    static var previews: some View {
        OrganiserProfile(organiser: testOrganiser,ratings: testRatings, events: testEvent)
    }
}
