//
//  Organization.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation

struct Organization:Codable {
    let id: Int
    let name: String
    let description: String
    let avatar: URL
    let website: String
    let email: String
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case avatar = "avatar"
        case website = "website"
        case email = "email"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(avatar, forKey: .avatar)
        try container.encode(website, forKey: .website)
        try container.encode(email, forKey: .email)
    }
}
