//
//  UserData.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation
import GoogleSignIn

class UserData {
    static let USER_INFO_KEY = "user info"
    static let USER_IMAGE_DIMENTION:UInt = 500
    
    /** Check if user logged in */
    static func didLogin() -> Bool {
        if UserDefaults.standard.data(forKey: USER_INFO_KEY) == nil {
            return false
        }
        return true
    }
    
    /** Log out the user from the app */
    static func logOut() {
        UserDefaults.standard.removeObject(forKey: USER_INFO_KEY)
        GIDSignIn.sharedInstance()?.signOut()
        (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController = LoginViewController()
        (UIApplication.shared.delegate as! AppDelegate).window?.makeKeyAndVisible()
    }
    
    /** Gets the current loggined user */
    static func getLoggedInUser() -> User?{
        if didLogin() {
            if let jsonData = UserDefaults.standard.data(forKey: USER_INFO_KEY) {
                do {
                    return try JSONDecoder().decode(User.self, from: jsonData)
                }
                catch {
                    print(error)
                    return nil
                }
            }
        }
        return nil
    }
    
    /** Creates a new user based on google login information */
    static func newUser(from googleUser: GIDGoogleUser) -> User? {
        if let userId = googleUser.userID,
            let idToken = googleUser.authentication.idToken,
            let fullName = googleUser.profile.name,
            let email = googleUser.profile.email,
            let avatar = googleUser.profile.imageURL(withDimension: USER_IMAGE_DIMENTION),
            let netID = email.split(separator: "@").first {
            return User(
                netID: String(netID),
                userID: userId,
                idToken: idToken,
                name: fullName,
                avatar: avatar,
                bookmarkedEvents: [],
                followingOrganizations: [],
                followingTags:[]
            )
        }
        return nil
    }
    
    /** Logs a user into the app */
    static func login(for user:User) -> Bool{
        do {
            let jsonData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(jsonData, forKey:USER_INFO_KEY)
            return true
        }
        catch {
            print (error)
            return false
        }
    }
}
