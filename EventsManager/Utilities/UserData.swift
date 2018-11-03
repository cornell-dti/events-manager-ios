//
//  UserData.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation
import GoogleSignIn
import Alamofire

class UserData {
    static let USER_INFO_KEY = "user info"
    static let USER_IMAGE_DIMENTION: UInt = 500

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
    static func getLoggedInUser() -> User? {
        if didLogin() {
            if let jsonData = UserDefaults.standard.data(forKey: USER_INFO_KEY) {
                do {
                    return try JSONDecoder().decode(User.self, from: jsonData)
                } catch {
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
                googleIdToken: idToken,
                serverAuthToken: nil,
                name: fullName,
                avatar: avatar,
                bookmarkedEvents: [],
                followingOrganizations: [],
                followingTags: []
            )
        }
        return nil
    }

    /** Logs a user into the app */
    static func login(for user: User) -> Bool {
        do {
            let jsonData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(jsonData, forKey: USER_INFO_KEY)
            return true
        } catch {
            print (error)
            return false
        }
    }

    /**
     Add an organization into a user's followed organizations.
     Returns true if operation is successful, false otherwise.
     Requires: user is logged in.
     */
    static func follow(organization: Organization) -> Bool {
        if var user = UserData.getLoggedInUser() {
            user.followingOrganizations.append(organization.id)
            return UserData.login(for: user)
        }
        return false
    }

    /**
     Add a tag into a user's followed tags.
     Returns true if operation is successful, false otherwise.
     Requires: user is logged in.
     */
    static func follow(tag: Tag) -> Bool {
        if var user = UserData.getLoggedInUser() {
            user.followingTags.append(tag.id)
            return UserData.login(for: user)
        }
        return false
    }

    /**
     Check if user has completed the onboarding process.
     */
    static func didCompleteOnboarding() -> Bool {
        if let user = UserData.getLoggedInUser() {
            if user.followingTags.count > 0 && user.followingOrganizations.count > 0 {
                return true
            }
        }
        return false
    }
}
