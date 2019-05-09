
//
//  JSONParserHelper.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 4/13/19.
//

import Foundation
import SwiftyJSON

class JSONParserHelper {
    private static let defaultImageURL = URL(string: "http://ethanhu.me/images/background.jpg")!
    private static let mediaAddress = Endpoint.baseURL + "app/media/"
    
    public static func parseOrganization(json: JSON) -> Organization? {
        if let pk = json["pk"].int,
            let name = json["name"].string,
            let desc = json["description"].string,
            let verified = json["verified"].bool,
            let email = json["contact"].string
        {
            let website = defaultImageURL.absoluteString
            var avatarURL = defaultImageURL
            if let photo_id = json["photo_id"].string{
                avatarURL = URL(string: mediaAddress + String(photo_id))!
            }
            let orgInstance = Organization.init(id: pk, name: name, description: desc, avatar: avatarURL, website: website, email: email)
            return orgInstance
        }
        else {
            return nil
        }
        
    }
    
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
    
    public static func parseLocation(json: JSON) -> Location? {
        if let pk = json["pk"].int,
            let buildingName = json["building"].string,
            let roomName = json["room"].string,
            let placeId = json["place_id"].string {
            
            let locationInstance = Location.init(id: pk, building: buildingName, room: roomName, placeId: placeId)
            return locationInstance
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
