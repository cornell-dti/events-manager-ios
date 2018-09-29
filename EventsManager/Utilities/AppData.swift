//
//  AppData.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/19/18.
//

import Foundation

/**
 AppData contains helper functions that deals with app data like organization, tags, and events.
 */
class AppData {

    /**
     Returns the organization struct with id pk.
     Requires: pk is a valid organization id. If no existing organizations match pk, any organization might be returned.
     */
    static func getOrganization(by pk: Int) -> Organization {
        return Organization(id: 1, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email:"connect@cornelldti.org")
    }

    /**
     Returns the tag with id pk.
     Requires: pk is a valid tag id. If no existing tags match pk, an empty string will be returned.
     */
    static func getTag(by pk: Int) -> String {
        return "lolol"
    }
}
