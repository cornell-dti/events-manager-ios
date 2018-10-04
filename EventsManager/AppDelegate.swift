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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        let tabBarVC = TabBarViewController()

        //Initialize google maps
        GMSServices.provideAPIKey("AIzaSyABs4C2LzrrU4m6LVQ2Ef7ZoNoVn6NIzr8")
        GMSPlacesClient.provideAPIKey("AIzaSyABs4C2LzrrU4m6LVQ2Ef7ZoNoVn6NIzr8")

        //initiallize Google Sign In
        GIDSignIn.sharedInstance()?.clientID = "498336876169-c0tedkl028ga401h2qj4g4gelnr68pen.apps.googleusercontent.com"
        GIDSignIn.sharedInstance()?.hostedDomain = "cornell.edu"

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
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Dosis-Bold", size: 19)!, NSAttributedStringKey.foregroundColor: UIColor(named: "primaryPink") ?? UIColor.red]
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "Dosis-Bold", size: 32)!, NSAttributedStringKey.foregroundColor: UIColor(named: "primaryPink") ?? UIColor.red]
        window?.tintColor = UIColor(named: "primaryPink")

        return true
    }

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

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

}
