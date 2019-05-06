
//
//  JSONParserHelper.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 4/13/19.
//  Copyright © 2019 Jagger Brulato. All rights reserved.
//

import Foundation
import SwiftyJSON

class JSONParserHelper {
    private static let defaultImageURL = URL(string: "http://ethanhu.me/images/background.jpg")!
    private static let mediaAddress = Endpoint.baseURL + "app/media/"
    
    public static func parseTag(json: JSON) -> Tag? {
        if let id = json["id"].int,
            let name = json["name"].string
        {
            let tagInstance = Tag.init(id: id, name: name)
            return tagInstance
        }
        else {
            return nil
        }
    }
    
    public static func parseOrganization(json: JSON) -> Organization? {
        if let pk = json["pk"].int,
        let name = json["name"].string,
        let description = json["description"].string,
        let contact = json["contact"].string
        {
            let orgInstance = Organization.init(id: pk, name: name, description: description, avatar: URL(string: mediaAddress)!, website: mediaAddress, email: contact)
            return orgInstance
        }
        else {
            return nil
        }
        
    }
    
    public static func parseEvent(json: JSON) -> Event? {
        if let pk = json["pk"].int,
            let name = json["name"].string,
            let description = json["description"].string,
            let start_date = json["start_date"].string,
            let end_date = json["end_date"].string,
            let start_time = json["start_time"].string,
            let end_time = json["end_time"].string,
            let num_attendees = json["num_attendees"].int,
            let is_public = json["is_public"].bool,
            let organizer = json["organizer"].int,
            let location = json["location"].int,
            let event_tags = json["event_tags"].array,
            let event_media = json["event_media"].array
        {
            let startDateTime = DateFormatHelper.datetime(from: "\(start_date) \(start_time)")
            let endDateTime = DateFormatHelper.datetime(from: "\(end_date) \(end_time)")
            var imageURL = defaultImageURL
            if event_media.count > 0 {
                let imageId = event_media[0].int!
                imageURL = URL(string: mediaAddress + String(imageId))!
            }
            var eventTags : [Int] = []
            for tag in event_tags {
                eventTags.append((tag.int)!)
            }
            let eventInstance = Event.init(id: pk, startTime: startDateTime!, endTime: endDateTime!, eventName: name, eventLocation: location, eventImage: imageURL, eventOrganizer: organizer, eventDescription: description, eventTags: eventTags, eventParticipantCount: num_attendees, isPublic: is_public)
            return eventInstance
        }
        else {
            return nil
        }
    }
}
