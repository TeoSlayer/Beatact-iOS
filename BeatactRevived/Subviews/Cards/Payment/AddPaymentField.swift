//
//  AddPaymentField.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 09.04.2021.
//

import SwiftUI
import Stripe
import UIKit

struct StripePaymentCardTextField: UIViewRepresentable {
    
    @Binding var cardParams: STPPaymentMethodCardParams
    @Binding var isValid: Bool
    @Binding var billing : STPPaymentMethodBillingDetails
    
    
    func makeUIView(context: Context) -> STPPaymentCardTextField {
        let input = STPPaymentCardTextField()
        input.borderColor = getColorFromHex(hex: 0x7653DB, alpha: 1.0)
        input.borderWidth = 5
        input.cornerRadius = 15
        input.delegate = context.coordinator
        return input
    }
    
    func makeCoordinator() -> StripePaymentCardTextField.Coordinator { Coordinator(self) }

    func updateUIView(_ view: STPPaymentCardTextField, context: Context) { }
    
    class Coordinator: NSObject, STPPaymentCardTextFieldDelegate {

        var parent: StripePaymentCardTextField
        
        init(_ textField: StripePaymentCardTextField) {
            parent = textField
            parent.billing.email = UserData.shared.user?.email
            parent.billing.name = UserData.shared.user?.name
            parent.billing.phone = UserData.shared.user?.phone
        }
        
        func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
            parent.cardParams = textField.cardParams
            parent.isValid = textField.isValid
            parent.billing.address?.postalCode = textField.postalCode
        }
    }
}

struct StripePaymentCardTextField_Previews: PreviewProvider {
    static var previews: some View {
        StripePaymentCardTextField(cardParams: .constant(STPPaymentMethodCardParams()), isValid: .constant(true), billing: .constant(STPPaymentMethodBillingDetails()))
            .frame(height: 80)
            .padding()
    }
}

