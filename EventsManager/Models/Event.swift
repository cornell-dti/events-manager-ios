//
//  Event.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/2/18.
//
//

import Foundation

struct Event {
    let id: Int
    let startTime: Date
    let endTime: Date
    let eventName: String
    let eventLocation: String
    let eventLocationID: String
    let eventParticipant: String
    let avatars: [URL] //id
    let eventImage: URL //id
    let eventOrganizer: Int
    let eventDescription: String
    let eventTags: [Int]
    let eventParticipantCount: Int
}
