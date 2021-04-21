//
//  TermsAndConditions.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI
import WebKit

struct TermsAndConditions: View {
    var body: some View {
        ZStack{
            TCWebView()
        }.navigationBarTitle("Terms & Conditions")
    }
}

struct TermsAndConditions_Previews: PreviewProvider {
    static var previews: some View {
        TermsAndConditions()
    }
}

struct TCWebView: UIViewRepresentable {
    func makeUIView(context: Context) -> WKWebView  {
            let webView = WKWebView()
            let request = URLRequest(url: URL(string: "https://beatact-website.herokuapp.com/Legal/T&C")!)
            webView.load(request)
            return webView
        }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
}
