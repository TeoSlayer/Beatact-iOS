//
//  AddCard.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 15.04.2021.
//
import SwiftUI
import Stripe


struct addCard : UIViewRepresentable{
    @Binding var params : STPPaymentMethodParams
    @Binding var isValid : Bool
    func makeUIView(context: Context) -> CardDetailsEditView {
        var configuration = PaymentSheet.Configuration()
        configuration.merchantDisplayName = "Example, Inc."
        configuration.applePay = .init(merchantId: "com.foo.example", merchantCountryCode: "RO")
        configuration.billingAddressCollectionLevel = .required
        
        let view = CardDetailsEditView(canSaveCard: false, billingAddressCollection:                                                 configuration.billingAddressCollectionLevel, merchantDisplayName:                                                          configuration.merchantDisplayName, delegate: context.coordinator)
        view.tintColor = getColorFromHex(hex: 0x7653DB, alpha: 1.0)

        return view
    }
    
    func updateUIView(_ uiView: CardDetailsEditView, context: Context) {}
    
    typealias UIViewType = CardDetailsEditView
    
    func makeCoordinator() -> (Coordinator) {
        return Coordinator(self)
    }
  
    class Coordinator: NSObject, AddPaymentMethodViewDelegate  {
        var parent: addCard
        
        init(_ parent: addCard) {
            self.parent = parent
        }
        
        
        func didUpdate(_ addPaymentMethodView: AddPaymentMethodView) {
            parent.params = addPaymentMethodView.paymentMethodParams!
            parent.isValid = true
        }
        
        
        override func didChangeValue(forKey key: String) {
                
        }
        
    }
    
    
}

struct addCard_Previews: PreviewProvider {
    static var previews: some View {
        addCard(params: .constant(STPPaymentMethodParams()), isValid: .constant(true))
            .frame(height : 500)
            .padding()
        
    }
}
