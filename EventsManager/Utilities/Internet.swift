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
    
    static func fetchLocation(serverToken: String, locationPk:Int , completion: @escaping (Location?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        
        let qp = [Endpoint.QueryParam.locationPk: String(locationPk)]
        let URL = Endpoint.getURLString(address: .locationAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completion(JSONParserHelper.parseLocation(json: json))
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
                    completion(JSONParserHelper.parseEvent(json: json))
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
        }
        
    }
    
    static func fetchSingleTag(serverToken: String, id: Int, completion: @escaping (Tag?) -> Void){
        let headers : HTTPHeaders = ["Authorization" : serverToken]
        
        let qp = [Endpoint.QueryParam.tagPk : String(id)]
        let URL = Endpoint.getURLString(address: .tagAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(JSONParserHelper.parseTag(json: json))
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
            }
    }
    
    static func fetchLocationDetail(serverToken: String, id: Int, completion: @escaping (Location?) -> Void){
        let headers : HTTPHeaders = ["Authorization" : serverToken]
        
        let qp = [Endpoint.QueryParam.locationPk : String(id)]
        let URL = Endpoint.getURLString(address: .locationAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(JSONParserHelper.parseLocation(json: json))
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
        }
    }

    static func fetchOrganizationDetail(serverToken: String, id: Int, completion: @escaping (Organization?) -> Void){
        let headers : HTTPHeaders = ["Authorization" : serverToken]
        
        let qp = [Endpoint.QueryParam.organizationPk : String(id)]
        let URL = Endpoint.getURLString(address: .organizationAddress, queryParams: qp)
        
        Alamofire.request(URL, headers: headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(JSONParserHelper.parseOrganization(json: json))
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
        }
    }
    
    static func fetchEventsByOrganization(serverToken: String, id: Int, completion: @escaping ([Event]?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken
        
        let qp = [Endpoint.QueryParam.organizationPk : String(id)]
        let URL = Endpoint.getURLString(address: .organizationEventAddress, queryParams: qp)
        
        Alamofire.request(URL, parameters: [:], headers: headers).validate().responseJSON
            { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    print(json)
                    var events : [Event] = []
                    if let updatedJSON = json["updated"].array{
                    for subJSON in updatedJSON {
                            let event = JSONParserHelper.parseEvent(json: subJSON)
                            if event != nil {
                                events.append(event!)
                            }
                        }
                        completion(events)
                    }
                    else {
                        completion(nil)
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(nil)
                }
        }
        
    }
    
    
    
}
