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
                followingTags: [],
                organizationClicks: [:],
                tagClicks: [:],
                reminderEnabled: true,
                reminderTime: ReminderTimeOptions.getInt(from: .fifteenMinutesBefore)
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
    
    static func serverToken() -> String? {
        if let user = UserData.getLoggedInUser() {
            return user.serverAuthToken
        }
        return nil
    }

    /**
     Add an organization into a user's followed organizations.
     Returns true if operation is successful, false otherwise.
     Requires: user is logged in.
     */
    static func follow(organization: Int) -> Bool {
        if var user = UserData.getLoggedInUser() {
            user.followingOrganizations.append(organization)
            return UserData.login(for: user)
        }
        return false
    }

    /**
     Add a tag into a user's followed tags.
     Returns true if operation is successful, false otherwise.
     Requires: user is logged in.
     */
    static func follow(tag: Int) -> Bool {
        if var user = UserData.getLoggedInUser() {
            user.followingTags.append(tag)
            return UserData.login(for: user)
        }
        return false
    }
    
    /**
     Set reminderEnabled
    */
    static func setReminderEnabled(rem: Bool) -> Bool {
        if var user = UserData.getLoggedInUser() {
            user.reminderEnabled = rem
            return UserData.login(for: user)
        }
        return false
    }
    

    /**
     Get reminderEnabled
     */
    
    static func getReminderEnabled() -> Bool? {
        if let user = UserData.getLoggedInUser() {
            return user.reminderEnabled
        }
        
        return nil
    }

    /**
     Set reminderTime
     */
    
    static func setReminderTime(timeReminderOption: ReminderTimeOptions) -> Bool {
        if var user = UserData.getLoggedInUser() {
            user.reminderTime = ReminderTimeOptions.getInt(from: timeReminderOption)
            return UserData.login(for: user)
        }
        return false
        
    }

    /**
     Get reminderTime
     */
    
    static func getReminderTime() -> Int? {
        if let user = UserData.getLoggedInUser() {
            return user.reminderTime
        }
        return nil
        
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
    
    /**
     Add a click count to the organization specified by parameter pk
     */
    static func addClickForOrganization(pk: Int) -> Bool{
        if var user = UserData.getLoggedInUser() {
            if user.organizationClicks[pk] != nil {
                user.organizationClicks[pk] = user.organizationClicks[pk]! + 1
            }
            else {
                user.organizationClicks[pk] = 1
            }
            return UserData.login(for: user)
        }
        return false
    }
    
    /**
     Add a click count to the organization specified by parameter pk
     */
    static func addClickForTag(pk: Int) -> Bool{
        if var user = UserData.getLoggedInUser() {
            if user.tagClicks[pk] != nil {
                user.tagClicks[pk] = user.tagClicks[pk]! + 1
            }
            else {
                user.tagClicks[pk] = 1
            }
            return UserData.login(for: user)
        }
        return false
    }
    
    /**
     Add a click for all tags associated with this event and the organization associated with this event.
     */
    static func addClickForEvent(event: Event) -> Bool {
        if var user = UserData.getLoggedInUser() {
            if user.organizationClicks[event.eventOrganizer] != nil {
                user.organizationClicks[event.eventOrganizer] = user.organizationClicks[event.eventOrganizer]! + 1
            }
            else {
                user.organizationClicks[event.eventOrganizer] = 1
            }
            for tag in event.eventTags {
                if user.tagClicks[tag] != nil {
                    user.tagClicks[tag] = user.tagClicks[tag]! + 1
                }
                else {
                    user.tagClicks[tag] = 1
                }
            }
        }
        return false
    }
    
    /**
     Retrieve an array of tuples containing labels indicating recommended type (e.g. "Based on #Cornell DTI"), and
     events that belongs to this type.
     */
    static func getRecommendedLabelAndEvents() -> [(String, [Event])] {
        enum RecommendedType {
            case tag
            case organization
        }
        if let user = UserData.getLoggedInUser() {
            var recommendedData:[(Int, Int, RecommendedType)] = []
            for (orgPk, clicks) in user.organizationClicks {
                recommendedData.append((orgPk, clicks, .organization))
            }
            for (tagPk, clicks) in user.tagClicks {
                recommendedData.append((tagPk, clicks, .tag))
            }
            recommendedData = recommendedData.sorted(by: {$0.1 > $1.1})
            var recommendedLabelEventsPairs: [(String, [Event])] = []
            for (pk, _, type) in recommendedData {
                let label = type == .organization ? "Based on \(AppData.getOrganization(by: pk, startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: false).name)" : "Based on #\(AppData.getTag(by: pk, startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: false).name)"
                recommendedLabelEventsPairs.append((label, type == .organization ? AppData.getEventsAssociatedWith(organization: pk) : AppData.getEventsAssociatedWith(tag: pk)))
            }
            return recommendedLabelEventsPairs
        }
        return []
    }
}
