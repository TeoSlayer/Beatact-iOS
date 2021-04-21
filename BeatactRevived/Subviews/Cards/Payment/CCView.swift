//
//  CCView.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 09.04.2021.
//

import SwiftUI
import Stripe
import CreditCardView




struct CCView: UIViewRepresentable {
    
    @Binding var cardNum : String
    @Binding var cardExpM : String
    @Binding var cardExpY : String
    
    func makeUIView(context: Context) -> CreditCardView {
        let view = UIScreen.main
        let frameWidth: CGFloat  = view.bounds.width/1.05
        let frameHeight:CGFloat  = view.bounds.width/2
        
        let c1:UIColor = getColorFromHex(hex: 0x7653db, alpha: 1.0)
        let c2:UIColor = getColorFromHex(hex: 0xdb7653, alpha: 1.0)
        let c3:UIColor = getColorFromHex(hex: 0x454851, alpha: 1.0)
        
        let cardView = CreditCardView(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: frameWidth, height: frameHeight), template: .Basic(c1, c2, c3))
        cardView.nameLabel.text = UserData.shared.user?.name
        cardView.brandLabel.text = "Beatact User"
        cardView.brandImageView.image = UIImage(imageLiteralResourceName: "beatactLogo")
        cardView.brandImageView.backgroundColor = getColorFromHex(hex: 0x454851, alpha: 1.0)
        
        return cardView
    }

    func updateUIView(_ view: CreditCardView, context: Context) {
        
        view.expLabel.text = cardExpM + "/" + cardExpY
        view.numLabel.text = cardNum
    }
}

/*struct CCView_Previews: PreviewProvider {
    static var previews: some View {
        CCView(cardNum: .constant("4242 4242 4242 4242"), cardExpM: "05", cardExpY: "2048")
    }
}*/

