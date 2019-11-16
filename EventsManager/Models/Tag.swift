//
//  Category.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation

struct Tag:Codable, Hashable {
    let id: Int
    let name: String

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
    }

}
