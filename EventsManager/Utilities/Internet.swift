//
//  Internet.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class Internet {
    private static let serverTokenAddress = "http://cuevents-app.herokuapp.com/generate_token/"
    private static let mediaAddress = "http://cuevents-app.herokuapp.com/app/media/"
    private static let tagAddress = "http://cuevents-app.herokuapp.com/app/tag/"
    private static let locationAddress = "http://cuevents-app.herokuapp.com/app/loc/"
    private static let eventsFeedAddress = "http://cuevents-app.herokuapp.com/feed/events/"
    

    static func getServerAuthToken(for googleToken: String, _ completion: @escaping (String?) -> Void) {
        Alamofire.request("\(serverTokenAddress)\(googleToken)/").validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(json["token"].string)
                case .failure(let error):
                    print(error)
                    completion(nil)
            }
        }
    }
    
    static func fetchMedia(serverToken:String, mediaPk:Int, completion: @escaping (URL?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        Alamofire.request("\(mediaAddress)\(mediaPk)", headers: headers).validate().responseString { response in
            switch response.result {
            case .success(let value):
                let imageURL = URL(string: value)
                completion(imageURL)
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    static func fetchTag(serverToken: String, tagPk:Int , completion: @escaping (Tag?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        Alamofire.request("\(tagAddress)\(tagPk)", headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let tagName = json["name"].string {
                    let tagInstance = Tag(id: tagPk, name: tagName)
                    completion(tagInstance)
                }
                else {
                    print("Error occured while fetching a tag")
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
            }
        }
    }
    
    static func fetchLocation(serverToken: String, locationPk:Int , completion: @escaping (String?, String?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        Alamofire.request("\(locationAddress)\(locationPk)", headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let buildingName = json["building"].string,
                    let roomName = json["room"].string,
                    let placeId = json["place_id"].string {
                    completion("\(buildingName) \(roomName)", placeId)
                }
                else {
                    print("Error occured while fetching a location")
                    completion(nil, nil)
                }
            case .failure(let error):
                print(error)
                completion(nil, nil)
            }
        }
    }
    
    //Returns Array of events, array of deleted event ids, and timestamp as a string.
    static func fetchUpdatedEvents(serverToken: String, timestamp: Date, start: Date, end: Date, completion: @escaping ([Event]?, [Int]?, Date?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        
        let params = [
            "timestamp": DateFormatHelper.datetime(from: timestamp),
            "start": DateFormatHelper.datetime(from: start),
            "end": DateFormatHelper.datetime(from: end)
        ]
        
        Alamofire.request(eventsFeedAddress, parameters: params, headers: headers).validate().responseJSON
        { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                var events : [Event] = []
                if let updatedJSON = json["updated"].array {
                    for subJSON in updatedJSON {
                        if let pk = subJSON["pk"].int,
                        let name = subJSON["name"].string,
                        let description = subJSON["description"].string,
                        let start_date = subJSON["start_date"].string,
                        let end_date = subJSON["end_date"].string,
                        let start_time = subJSON["start_time"].string,
                        let end_time = subJSON["end_time"].string,
                        let num_attendees = subJSON["num_attendees"].int,
                        let is_public = subJSON["is_public"].bool,
                        let organizer = subJSON["organizer"].int,
                        let location = subJSON["location"].int,
                        let event_tags = subJSON["event_tags"].array,
                        let event_media = subJSON["event_media"].array
                        {
                            let startDateTime = DateFormatHelper.datetime(from: "\(start_date) \(start_time)")
                            let endDateTime = DateFormatHelper.datetime(from: "\(end_date) \(end_time)")
                            let imageId = event_media.count > 0 ? event_media[0].int! : 0
                            let imageURL = URL(string: mediaAddress + String(imageId))
                            var eventTags : [Int] = []
                            for tag in event_tags {
                                eventTags.append((tag.int)!)
                            }
                            let eventInstance = Event.init(id: pk, startTime: startDateTime!, endTime: endDateTime!, eventName: name, eventLocation: location, eventImage: imageURL!, eventOrganizer: organizer, eventDescription: description, eventTags: eventTags, eventParticipantCount: num_attendees, isPublic: is_public)
                            events.append(eventInstance)
                        }
                    }
                }
                var deleted : [Int] = []
                if let deletedJSON = json["deleted"].array {
                    for id in deletedJSON {
                        deleted.append(id.int!)
                    }
                }
                
                if let timestamp = json["timestamp"].string,
                    let timestampDateTime = DateFormatHelper.date(from: timestamp) {
                    completion(events, deleted, timestampDateTime)
                }
                else {
                    completion(events, deleted, nil)
                }
                
            case .failure(let error):
                print(error)
                completion(nil, nil, nil)
            }
        }
        
    }
    

}
