//
//  Event.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/2/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import Foundation

class Event {
    var startTime:String
    var endTime:String
    var eventName:String
    var eventLocation:String
    var eventParticipant:String
    var avatars:[URL]
    var eventImage:URL
    var eventOrganizer:String
    var eventDiscription:String
    
    //requires: at most 3 avatars can be provided
    init(startTime:String, endTime:String, eventName:String, eventLocation:String, eventParticipant:String, avatars:[URL], eventImage:URL, eventOrganizer:String, eventDiscription:String) {
        self.startTime = startTime
        self.endTime = endTime
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.eventParticipant = eventParticipant
        self.avatars = avatars
        self.eventImage = eventImage
        self.eventOrganizer = eventOrganizer
        self.eventDiscription = eventDiscription
    }
}
