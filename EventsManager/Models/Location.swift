//
//  Location.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/16/19.
//

import Foundation
struct Location: Codable, Hashable {
    let id: Int
    let building: String
    let room: String
    let placeId: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case building
        case room
        case placeId = "place_id"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(building, forKey: .building)
        try container.encode(room, forKey: .room)
        try container.encode(placeId, forKey: .placeId)
    }
}
