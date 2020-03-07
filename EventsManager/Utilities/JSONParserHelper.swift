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
            let desc = json["bio"].string,
            let email = json["email"].string,
            let website = json["website"].string {
            var photo = AppData.DEFAULT_IMAGE_URL
            if let photos = json["photo"].array {
                if photos.count > 0 {
                    if let firstPhoto = photos[0]["link"].string {
                        photo = firstPhoto
                    }
                }
            }
            let photo_url = URL(string: photo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") ?? URL(string: AppData.DEFAULT_IMAGE_URL)!

            return Organization(id: pk, name: name, description: desc, avatar: photo_url, website: website, email: email)
        }
        return nil

    }

    public static func parseTag(json: JSON) -> Tag? {
        if let id = json["pk"].int,
            let name = json["name"].string {
            let tagInstance = Tag(id: id, name: name)
            return tagInstance
        }
        return nil
    }

    public static func parseLocation(json: JSON) -> Location? {
        if let pk = json["pk"].int,
            let buildingName = json["building"].string,
            let roomName = json["room"].string,
            let placeId = json["place_id"].string {

            let locationInstance = Location(id: pk, building: buildingName, room: roomName, placeId: placeId)
            return locationInstance
        } else {
            return nil
        }
    }

    public static func parseEverything(json: JSON) -> (Event?, Organization?, [Tag], Location?) {
        //parse singletons
        if let pk = json["pk"].int,
            let name = json["name"].string,
            let description = json["description"].string,
            let start_date = json["start_date"].string,
            let end_date = json["end_date"].string,
            let start_time = json["start_time"].string,
            let end_time = json["end_time"].string,
            let participantCount = json["num_attendees"].int,
            let isPublic = json["is_public"].bool,
            // parse imbedded objects
            let org_json = json["organizer"].dictionary,
            let tags_json = json["tags"].array,
            let medias_json = json["media"].array,
            let location_data = try? json["location"].rawData(),
            let location = try? JSONDecoder().decode(Location.self, from: location_data) {
            //get org id and location id
            let location_id = location.id
            if let orgId = org_json["id"]?.int,
                let orgName = org_json["name"]?.string,
                let orgBio = org_json["bio"]?.string,
                let website = org_json["website"]?.string,
                let orgEmail = org_json["email"]?.string {
                var photo = AppData.DEFAULT_IMAGE_URL
                if let photos = org_json["photo"]?.array {
                    if photos.count > 0 {
                        if let firstPhoto = photos[0]["link"].string {
                            photo = firstPhoto
                        }
                    }
                }
                let photo_url = URL(string: photo.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") ?? defaultImageURL
                let orgObj = Organization(id: orgId, name: orgName, description: orgBio, avatar: photo_url, website: website, email: orgEmail)

                // get tags and media
                var tags:[Int] = []
                var tagObjs:[Tag] = []
                for tag_json in tags_json {
                    if let tagId = tag_json["id"].int,
                        let tagName = tag_json["name"].string {
                        tags.append(tagId)
                        tagObjs.append(Tag(id: tagId, name: tagName))
                    }
                }
                var media = AppData.DEFAULT_IMAGE_URL
                for media_json in medias_json {
                    if let media_string = media_json["link"].string {
                        media = media_string
                    }
                    break
                }
                let media_url = URL(string: media.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") ?? defaultImageURL

                // change start time and end time to swift date formats
                if let startDate = DateFormatHelper.datetime(from: "\(start_date) \(start_time)"),
                    let endDate = DateFormatHelper.datetime(from: "\(end_date) \(end_time)") {
                    let eventObj = Event(id: pk, startTime: startDate, endTime: endDate, eventName: name, eventLocation: location_id, eventImage: media_url, eventOrganizer: orgId, eventDescription: description, eventTags: tags, eventParticipantCount: participantCount, isPublic: isPublic, location: location)
                    return (eventObj, orgObj, tagObjs, location)
                }
            }

        }
        return (nil, nil, [], nil)
    }

    public static func parseEvent(json: JSON) -> Event? {
        //parse singletons
        if let pk = json["pk"].int,
            let name = json["name"].string,
            let description = json["description"].string,
            let start_date = json["start_date"].string,
            let end_date = json["end_date"].string,
            let start_time = json["start_time"].string,
            let end_time = json["end_time"].string,
            let participantCount = json["num_attendees"].int,
            let isPublic = json["is_public"].bool,
            // parse imbedded objects
            let org_json = json["organizer"].dictionary,
            let tags_json = json["tags"].array,
            let medias_json = json["media"].array,
            let location_data = try? json["location"].rawData(),
            let location = try? JSONDecoder().decode(Location.self, from: location_data) {
            //get org id and location id
             let location_id = location.id
            if let orgId = org_json["id"]?.int {
                // get tags and media
                var tags:[Int] = []
                for tag_json in tags_json {
                    if let tagId = tag_json["id"].int {
                        tags.append(tagId)
                    }
                }
                var media = AppData.DEFAULT_IMAGE_URL
                for media_json in medias_json {
                    if let media_string = media_json["link"].string {
                        media = media_string
                    }
                    break
                }
                let media_url = URL(string: media.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") ?? URL(string: AppData.DEFAULT_IMAGE_URL)!

                // change start time and end time to swift date formats
                if let startDate = DateFormatHelper.datetime(from: "\(start_date) \(start_time)"),
                    let endDate = DateFormatHelper.datetime(from: "\(end_date) \(end_time)") {
                    return Event(id: pk, startTime: startDate, endTime: endDate, eventName: name, eventLocation: location_id, eventImage: media_url, eventOrganizer: orgId, eventDescription: description, eventTags: tags, eventParticipantCount: participantCount, isPublic: isPublic, location: location)
                }
            }

        }
        return nil
    }
}
