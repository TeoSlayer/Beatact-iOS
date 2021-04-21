//
//  LeaderBoard.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 13.04.2021.
//

import SwiftUI

struct LeaderBoard: View {
    @EnvironmentObject var leaderBoardData : LeaderBoardData
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Name")
                    Spacer()
                    Text("Orders")
                }.padding(.horizontal)
                Divider()
                List{
                    ForEach(leaderBoardData.leaderbaordUsers){ user in
                        HStack{
                            Text("#" + String(describing: getIndex(id: user.id)))
                                .font(.system(size: 16, weight: .bold, design: .default))
                                .foregroundColor(getColor(place: getIndex(id: user.id)))
                            Text(user.name)
                            if(getIndex(id: user.id) < 4){
                                Image("Leaderboard")
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(getColor(place: getIndex(id: user.id)))
                                    .frame(height: 25)
                            }
                            Spacer()
                            
                            
                            Text(String(describing: user.orders))
                        }
                    }
                }
            }
            VStack(){
                    Spacer()
                    Divider()
                        .frame(height: 2)
                        .background(beatactViolet)
                    HStack{
                        Text("Your Name")
                        Spacer()
                        Text("Your Orders")
                    }.padding(.horizontal)
                    HStack{
                        Text(UserData.shared.user!.name)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .default))
                        Spacer()
                        Text(String(describing: OrderData.shared.Orders.count))
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .bold, design: .default))
                    }.padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom)
                    .background(beatactViolet)
                    
            }
        }.navigationTitle("Leaderboard").ignoresSafeArea()
    }
    
    func getColor(place : Int) -> Color{
        if(place == 1){
            return Color(gold)
        }
        
        if(place == 2){
            return Color(silver)
        }
        
        if(place == 3){
            return Color(bronze)
        }
        
        return Color.gray
    }
    func getIndex(id: String) -> Int{
        let index = leaderBoardData.leaderbaordUsers.firstIndex(where: { $0.id == id})
        return index! + 1
    }
}

struct LeaderBoard_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoard().environmentObject(LeaderBoardData.shared).onAppear(perform: {
            LeaderBoardData.shared.retrieveLeaderBoard()
        })
    }
}
