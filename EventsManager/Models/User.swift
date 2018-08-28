//
//  User.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation

struct User {
    let netID:String
    let name:String
    let avatar:URL //temporary
    let interestedEvents:[Int]
    let goingEvents:[Int]
    let followingOrganizations:[Organization]
    let preferredCategories:[Int]
    let followingTags:[String]
}
