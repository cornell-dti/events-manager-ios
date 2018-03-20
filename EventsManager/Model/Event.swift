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
    
    //requires: 3 avatars must be provided
    init(startTime:String, endTime:String, eventName:String, eventLocation:String, eventParticipant:String, avatars:[URL]) {
        self.startTime = startTime
        self.endTime = endTime
        self.eventName = eventName
        self.eventLocation = eventLocation
        self.eventParticipant = eventParticipant
        self.avatars = avatars
    }
}
