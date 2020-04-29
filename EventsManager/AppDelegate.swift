//
//  AppDelegate.swift
//  EventsManager
//
//  Created by Jagger Brulato on 1/28/18.
//
//

import UIKit
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import Firebase
import UserNotifications
import UXCam

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UXCam.optIntoSchematicRecordings()
        UXCam.start(withKey:"bgqqy0hez9v6qm5")
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarVC = TabBarViewController()

        //Initialize google maps
        GMSServices.provideAPIKey("AIzaSyA8IuxX8MI39hgPfa8CJLa0GeqLtQXHdXo")
        GMSPlacesClient.provideAPIKey("AIzaSyA8IuxX8MI39hgPfa8CJLa0GeqLtQXHdXo")

        //initiallize Google Sign In
        GIDSignIn.sharedInstance()?.clientID = "498336876169-c0tedkl028ga401h2qj4g4gelnr68pen.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.hostedDomain = "cornell.edu"

        FirebaseApp.configure()

        //check if logged in
        if UserData.didLogin() {
            if UserData.didCompleteOnboarding() {
                window?.rootViewController = tabBarVC
            } else {
                 window?.rootViewController = UINavigationController(rootViewController: OnBoardingViewController())
            }
        } else {
            window?.rootViewController = LoginViewController()
        }
        window?.makeKeyAndVisible()

        // Set global appearance attributes
        UITabBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 19)!, NSAttributedString.Key.foregroundColor: UIColor(named: "primaryPink") ?? UIColor.red]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "SFProText-Bold", size: 32)!, NSAttributedString.Key.foregroundColor: UIColor(named: "primaryPink") ?? UIColor.red]
        window?.tintColor = UIColor(named: "primaryPink")

        //request notifications
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options, completionHandler: {(_, _) in   
        })
        //log notifications that have been sent and are in the notification center (have not been clicked by the user)
        notificationCenter.getDeliveredNotifications(completionHandler: { notifications in
            for notification in notifications {
                if notification.request.content.title == "Here is an event you may be interested in" {
                    Analytics.logEvent("tailoredNotificationAppeared", parameters: [
                        "description": notification.request.content
                    ])
                } else {
                    Analytics.logEvent("notificationAppeared", parameters: [
                        "description": notification.request.content
                    ])
                }
            }
        })

        return true
    }

    //track notifications that have been clicked
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        if response.notification.request.content.title == "Here is an event you may be interested in" {
            Analytics.logEvent("tailoredNotificationClicked", parameters: [
                "description": response.notification.request.content
            ])
        } else {
            Analytics.logEvent("notificationClicked", parameters: [
                "description": response.notification.request.content
            ])
        }

        completionHandler()
    }

//    func application(_ app: UIApplication, open url: URL,
//                     options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
//        if let scheme = url.scheme,
//            scheme.localizedCaseInsensitiveCompare("org.cuevents") == .orderedSame,
//            let view = url.host {
////            url = URL(string: "cuevents.org/event/[event.id]")!
//        }
//        UIApplication.shared.open(url, options: [:], completionHandler: nil)
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL,
          let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        let category = String(components.path.split(separator: "/")[0])
        let id = components.path.digits
        if category == "event" {
            if let tabVC = window?.rootViewController as? TabBarViewController {
                let detailsVC = EventDetailViewController()
                detailsVC.configure(with: Int(id)!)
                tabVC.selectedIndex = tabVC.discoverIndex
                tabVC.discoverNavVC.pushViewController(detailsVC, animated: true)
            }
        }
        if category == "org" {
            if let tabVC = window?.rootViewController as? TabBarViewController {
                let detailsVC = OrganizationViewController()
                detailsVC.configure(organizationPk: Int(id)!)
                tabVC.selectedIndex = tabVC.discoverIndex
                tabVC.discoverNavVC.pushViewController(detailsVC, animated: true)
            }
        }
        return false
    }
}
