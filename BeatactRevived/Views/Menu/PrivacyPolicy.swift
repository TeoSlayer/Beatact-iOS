//
//  PrivacyPolicy.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI
import WebKit

struct PrivacyPolicy: View {
    var body: some View {
        ZStack{
            PrivacyPolicyWebView()
        }.navigationBarTitle("Privacy Policy")
    }
}

struct PrivacyPolicy_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPolicy()
    }
}

struct PrivacyPolicyWebView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> WKWebView  {
            let webView = WKWebView()
            let request = URLRequest(url: URL(string: "https://beatact-website.herokuapp.com/Legal/PrivacyPolicy")!)
            webView.load(request)
            return webView
        }

    func updateUIView(_ uiView: WKWebView, context: Context) { }
    
}
