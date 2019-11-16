//
//  Event.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/2/18.
//
//

import Foundation

struct Event:Codable, Hashable {
    let id: Int
    let startTime: Date
    let endTime: Date
    let eventName: String
    let eventLocation: Int
    let eventImage: URL //id
    let eventOrganizer: Int
    let eventDescription: String
    let eventTags: [Int]
    let eventParticipantCount: Int
    let isPublic: Bool
    let location: Location

    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case startTime = "start_time"
        case endTime = "end_time"
        case eventName = "event_name"
        case eventLocation = "event_location"
        case eventImage = "event_image"
        case eventOrganizer = "event_organizer"
        case eventDescription = "event_description"
        case eventTags = "event_tags"
        case eventParticipantCount = "event_participant_count"
        case isPublic = "is_public"
        case location
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(eventName, forKey: .eventName)
        try container.encode(eventLocation, forKey: .eventLocation)
        try container.encode(eventImage, forKey: .eventImage)
        try container.encode(eventOrganizer, forKey: .eventOrganizer)
        try container.encode(eventDescription, forKey: .eventDescription)
        try container.encode(eventTags, forKey: .eventTags)
        try container.encode(eventParticipantCount, forKey: .eventParticipantCount)
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(location, forKey: .location)
    }
}
