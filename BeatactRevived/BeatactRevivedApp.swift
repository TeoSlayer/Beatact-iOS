//
//  BeatactRevivedApp.swift
//  BeatactRevived
//
//  Created by Calin Teodor on 30.03.2021.
//

import SwiftUI
import UIKit
import Sentry
import CoreData
import Stripe
import Firebase
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase
import FirebaseMessaging


@main
struct BeatactRevivedApp: App {
    @UIApplicationDelegateAdaptor(FirebaseDelegate.self) var appDelegate
    
    init() {
        
        FirebaseApp.configure()
        FirebaseConfiguration.shared.setLoggerLevel(.min)
        Stripe.setDefaultPublishableKey("pk_test_51H30KpDnwFAoDU0Q6r1LB893uzQB6EeKz9vAmrf01OdP6SF9BMqGcxiYlrwFE2G2FV1VezwJvBdDGqttKy5lCvbV00W79OKogW")
        SentrySDK.start { options in
            options.dsn = "https://fa5f008741dd4b968043a21792d995d4@o418234.ingest.sentry.io/5320523"
            options.debug = true // Enabled debug when first installing is always helpful
        }
        
        
        UserData.shared.listenForAuth()
        if(UserData.shared.loggedIn){
            EventData.shared.retrieveEvents()
            print("Retrieving Events")
            OrderData.shared.retrieveOrders()
            print("Retrieving Orders")
            LeaderBoardData.shared.retrieveLeaderBoard()
            LeaderBoardData.shared.retrievePersonalLeaderBoard()
        }
        
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(EventData.shared).environmentObject(UserData.shared) 
                        .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                
        }
    }
}



extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

class FirebaseDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser?, withError error: Error?) {
      guard let authentication = user?.authentication else {
        
        return
      }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
      Auth.auth().signIn(with: credential) { (authResult, error) in
        if error != nil {
            return
          }
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

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
    GIDSignIn.sharedInstance().delegate = self
    // 1
    UNUserNotificationCenter.current().delegate = self
    // 2
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions) { _, _ in }
    // 3
    application.registerForRemoteNotifications()
    Messaging.messaging().delegate = self
    return true
  }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
      Messaging.messaging().apnsToken = deviceToken
    }
}

extension FirebaseDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
    @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([[.banner, .sound]])
  }

  func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}


extension FirebaseDelegate: MessagingDelegate {
  func messaging(
    _ messaging: Messaging,
    didReceiveRegistrationToken fcmToken: String?
  ) {
    let tokenDict = ["token": fcmToken ?? ""]
    NotificationCenter.default.post(
      name: Notification.Name("FCMToken"),
      object: nil,
      userInfo: tokenDict)
  }
}
