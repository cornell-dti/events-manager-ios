//
//  Organization.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation

struct Organization {
    let id: Int
    let name: String
    let description: String
    let avatar: URL
    let photoID: [Int]
    let events: [Int]
    let members: [String]
    let website: String
    let email: String
}
