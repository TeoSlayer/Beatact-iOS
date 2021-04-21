//
//  LoginPage.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 31.03.2021.
//

import SwiftUI
import FirebaseAuth
import UIKit
import AuthenticationServices
import CryptoKit
import GoogleSignIn

fileprivate var currentNonce: String?

struct LoginView: View {
    
    // Currently Logged In User -- Assign
    // Form Data Variables

    
    // UI State and Form error handling variables
    @State private var showFields: Bool = false
    @EnvironmentObject var userdata : UserData
    
    var backgroundImage = Image("backgroundlogin")
    
    var body: some View {
        if(self.userdata.onBoarding == false){
            ZStack(alignment: .bottom) {
            SocialLogin().frame(width: 0, height: 0, alignment: .center)
            
            // Change your Background Image in `Assets.xcassets`
            backgroundImage
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: UIScreen.main.bounds.width)
            
            // Change your Brand Image in `Assets.xcassets`
            VStack {
                Spacer()
                VStack{
                Image("beatactLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width/2,alignment: .center)
                    .opacity(showFields ? 0 : 1)

                Text("BeatAct")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(beatactViolet)
                        .padding()
                        .opacity(showFields ? 0 : 1)
                        .padding(.bottom)
                        
                }.background(Color.white)
                 .modifier(EventCardModifier())
                 .opacity(showFields ? 0 : 1)
                Spacer()
            }.padding(.bottom, 100)
            
            VStack(spacing: 0) {
                Spacer()
                Color.white
                    .frame(width: 55, height: 5, alignment: .center)
                    .cornerRadius(3)
                    .padding(.bottom, 12)
                
                VStack(alignment: .center, spacing: 8) {
                        SignUpWithAppleView()
                            .frame(height: 70)
                            .padding([.trailing,.leading],40)
                    
                    SignInWithGoogleButton().frame(height: 70).padding(.bottom,50).padding([.trailing,.leading],40)
                    
                }
                .padding(.all, 20)
                .background(Color.white)
            }.offset(x: 0, y: showFields ? -40 : UIScreen.main.bounds.height)
            
            VStack{
            Button(action: {
                if !showFields {
                    withAnimation(.easeInOut) {
                        showFields = true
                    }
                } else {
                    showFields = false
                }
            }, label: {
                        
                Text(showFields ? "Back" : "Sign in to your account")
                    .font(.system(size: 20, weight: .bold, design: .default))
                    .foregroundColor(beatactViolet)
                    .padding(.bottom, 40)
                    .padding(.vertical, 20)
                    
                }
                    
            ).frame(maxWidth: .infinity)
            .background(Color.white)
            }
            
           
            
        }
        }
        
        else{
            OnBoarding(isActive: $userdata.onBoarding)
        }
        
    }
}


struct SignUpWithAppleView: UIViewRepresentable {
    
    func makeCoordinator() -> AppleSignUpCoordinator {
        return AppleSignUpCoordinator(self)
    }
    
    func makeUIView(context: Context) -> ASAuthorizationAppleIDButton {

        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn,
                                                  authorizationButtonStyle: .black)
        button.cornerRadius = 15
        
        
        button.addTarget(context.coordinator,
                         action: #selector(AppleSignUpCoordinator.didTapButton),
                         for: .touchUpInside)
            
        return button
    }
    
    func updateUIView(_ uiView: ASAuthorizationAppleIDButton, context: Context) {
    }
}

class AppleSignUpCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var parent: SignUpWithAppleView?
    
    init(_ parent: SignUpWithAppleView) {
        self.parent = parent
        super.init()

    }
    
    @objc func didTapButton() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func sha256(_ input: String) -> String {
     let inputData = Data(input.utf8)
     let hashedData = SHA256.hash(data: inputData)
     let hashString = hashedData.compactMap {
       return String(format: "%02x", $0)
     }.joined()

     return hashString
    }

    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        let vc = UIApplication.shared.windows.last?.rootViewController
        return (vc?.view.window!)!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
    
              guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
              }
              guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
              }
              guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
              }
              // Initialize a Firebase credential.
              let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                        idToken: idTokenString,
                                                        rawNonce: nonce)
              // Sign in with Firebase.
                Auth.auth().signIn(with: credential) { (authResult, error) in
                if (error != nil) {
                    
                  print(error?.localizedDescription)
                  return
                }
                print("Apple login")
                UserData.shared.checkIfUserExists(id: Auth.auth().currentUser?.uid ?? "", completion: ({result in
                    if result == false{
                        print("User does not exist, continuing to onboarding...")
                        UserData.shared.onBoarding = true
                        
                    }
                    else{
                        print("Fetching user info, logging in...")
                        UserData.shared.retrieveUser(userId: (Auth.auth().currentUser?.uid)!)
                    }
                }))
                
                
        
                
              }
            }

    }

    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        //Set this to true even if it threw an error in order to be able to work on the app anyways
        
        print("Sign in with Apple errored: \(error)")
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(UserData.shared)
            .preferredColorScheme(.dark)
    }
}

func randomNonceString(length: Int = 32) -> String {
 precondition(length > 0)
 let charset: Array<Character> =
     Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
 var result = ""
 var remainingLength = length

 while remainingLength > 0 {
   let randoms: [UInt8] = (0 ..< 16).map { _ in
     var random: UInt8 = 0
     let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
     if errorCode != errSecSuccess {
       fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
     }
     return random
   }

   randoms.forEach { random in
     if remainingLength == 0 {
       return
     }

     if random < charset.count {
       result.append(charset[Int(random)])
       remainingLength -= 1
     }
   }
 }

 return result
}

struct SignInWithGoogleButton : View {
    var body: some View {
        GeometryReader{geometry in
        Button(action: {
            SocialLoginVC.shared.attemptLoginGoogle()
        }) {
            Rectangle()
                .cornerRadius(10)
                .overlay(
                    ZStack{
                        Rectangle()
                            .foregroundColor(Color.black)
                            .cornerRadius(10)
                        Rectangle()
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .frame(width: geometry.size.width-geometry.size.width/40, height: geometry.size.height-geometry.size.height/10, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Image("btn_google_light_normal_ios")
                            .padding(.trailing,geometry.size.width/1.6)
                        Text("Sign in with Google")
                            .font(.headline)
                            .foregroundColor(Color.black)
                            .padding(.leading,geometry.size.width/5)
                            
                    })
                

        }
        }
    }
}


struct SocialLogin: UIViewRepresentable {

    typealias  UIViewControllerType = SocialLoginVC
    
    func makeUIView(context: UIViewRepresentableContext<SocialLogin>) -> UIView {
        let view = SocialLoginVC.shared
        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<SocialLogin>) {
    }

   

}

class SocialLoginVC : UIView{
    
    static let shared = SocialLoginVC()
    
    func attemptLoginGoogle() {
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        GIDSignIn.sharedInstance()?.signIn()
    }
}


