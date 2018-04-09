//
//  Event.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/2/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import Foundation

struct Event {
    var startTime:Date
    var endTime:Date
    var eventName:String
    var eventLocation:String
    var eventParticipant:String
    var avatars:[URL]
    var eventImage:URL
    var eventOrganizer:String
    var eventDiscription:String
    var eventTags:[String]
    
    //requires: at most 3 avatars can be provided
    init(startTime:Date, endTime:Date, eventName:String, eventLocation:String, eventParticipant:String, avatars:[URL], eventImage:URL, eventOrganizer:String, eventDiscription:String, eventTags:[String]) {
        self.startTime = startTime
        self.endTime = endTime
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.eventParticipant = eventParticipant
        self.avatars = avatars
        self.eventImage = eventImage
        self.eventOrganizer = eventOrganizer
        self.eventDiscription = eventDiscription
        self.eventTags = eventTags
    }
}
