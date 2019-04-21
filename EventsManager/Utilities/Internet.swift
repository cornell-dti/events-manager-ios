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

    static func getServerAuthToken(for googleToken: String, _ completion: @escaping (String?) -> Void) {
        let qp = [Endpoint.QueryParam.googleToken : googleToken]
        let URL = Endpoint.getURLString(address: .serverTokenAddress, queryParams: qp)
        Alamofire.request(URL).validate().responseJSON { response in
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
    
    //fetch tag
    static func fetchTag(serverToken: String, tagPk:Int , completion: @escaping (Tag?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        
        let qp = [Endpoint.QueryParam.tagPk : String(tagPk)]
        let URL = Endpoint.getURLString(address: .tagAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON { response in
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
    
    //single location
    static func fetchLocation(serverToken: String, locationPk:Int , completion: @escaping (Location?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        
        let qp = [Endpoint.QueryParam.locationPk: String(locationPk)]
        let URL = Endpoint.getURLString(address: .locationAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                if let buildingName = json["building"].string,
                    let roomName = json["room"].string,
                    let placeId = json["place_id"].string {
                    let locationInstance = Location(id: locationPk, building: buildingName, room: roomName, placeId: placeId)
                    completion(locationInstance)
                }
                else {
                    print("Error occured while fetching a location")
                    completion(nil)
                }
            case .failure(let error):
                print(error)
                completion(nil)
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
        
        let URL = Endpoint.getURLString(address: .eventsFeedAddress, queryParams: [:])
        
        Alamofire.request(URL, parameters: params, headers: headers).validate().responseJSON
        { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                var events : [Event] = []
                if let updatedJSON = json["updated"].array {
                    for subJSON in updatedJSON {
                        let event = JSONParserHelper.parseEvent(json: subJSON)
                        if event != nil {
                            events.append(event!)
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
    
    //Returns Array of events, array of deleted event ids, and timestamp as a string.
    static func fetchEventDetails(serverToken: String, id: Int, completion: @escaping (Event?) -> Void) {
        print(serverToken)
        let headers : HTTPHeaders = ["Authorization" : serverToken]
        
        let qp = [Endpoint.QueryParam.eventPk : String(id)]
        let URL = Endpoint.getURLString(address: .eventDetailsAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("SUCCESS: \(json)")
                    completion(JSONParserHelper.parseEvent(json: json))
                case .failure(let error):
                    print("ERROR: \(error)")
                    completion(nil)
                }
        }
        
    }
    
    //organization details
    static func fetchOrgDetails(serverToken: String, id:Int , completion: @escaping (Organization?) -> Void) {
        let headers : HTTPHeaders = ["Authorization" : serverToken]
        let qp = [Endpoint.QueryParam.orgPk : String(id)]
        let URL = Endpoint.getURLString(address: .orgDetailsAddress, queryParams: qp)
        
        Alamofire.request(URL, headers:headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("SUCCESS: \(json)")
                    completion(JSONParserHelper.parseOrganization(json: json))
                case .failure(let error):
                    print("ERROR: \(error)")
                    completion(nil)
                }
            }
                
        }
    
    //events by organization
    static func fetchEventsbyOrg(serverToken: String, orgPk: Int, completion: @escaping ([Event]?) -> Void) {
        print(serverToken)
        let headers : HTTPHeaders = ["Authorization" : serverToken]
        
        let qp = [Endpoint.QueryParam.orgPk : String(orgPk)]
        let URL = Endpoint.getURLString(address: .eventsByOrgAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("SUCCESS: \(json)")
                    //completion(JSONParserHelper.parseEvent(json: json))
                case .failure(let error):
                    print("ERROR: \(error)")
                    completion(nil)
                }
        }
        
    }
    
    //single tag
    static func fetchSingleTag(serverToken: String, id: Int, completion: @escaping (Tag?) -> Void){
        let headers : HTTPHeaders = ["Authorization" : serverToken]
        
        let qp = [Endpoint.QueryParam.tagPk : String(id)]
        let URL = Endpoint.getURLString(address: .tagAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print("SUCCESS: \(json)")
                    completion(JSONParserHelper.parseTag(json: json))
                case .failure(let error):
                    print("ERROR: \(error)")
                    completion(nil)
                }
            }
    }

}
