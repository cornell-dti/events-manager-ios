//
//  Event.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/2/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import Foundation

struct Event {
    let startTime:Date
    let endTime:Date
    let eventName:String
    let eventLocation:String
    let eventParticipant:String
    let avatars:[URL]
    let eventImage:URL
    let eventOrganizer:String
    let eventDiscription:String
    let eventTags:[String]
}
