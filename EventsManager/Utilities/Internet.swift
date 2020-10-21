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

    static func fetchLocation(serverToken: String, locationPk:Int, completion: @escaping (Location?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken

        let qp = [Endpoint.QueryParam.locationPk: String(locationPk)]
        let URL = Endpoint.getURLString(address: .locationAddress, queryParams: qp)

        Alamofire.request(URL, headers: headers).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
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

    static func fetchEverything(timestamp: Date, start: Date, end: Date, completion: @escaping(Set<Event>, Set<Organization>, Set<Tag>, Set<Location>) -> Void) {

        let URL = Endpoint.getURLString(address: .eventsFeedAddress, queryParams: [
            .timeStamp: DateFormatHelper.timestamp(from: timestamp),
            .startTime: DateFormatHelper.timestamp(from: start),
            .endTime: DateFormatHelper.timestamp(from: end)
        ])

        Alamofire.request(URL).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var events = Set<Event>()
                    var orgs = Set<Organization>()
                    var tags = Set<Tag>()
                    var locations = Set<Location>()
                    if let updatedJSON = json["events"].array {
                        for subJSON in updatedJSON {
                            let (event, org, subTags, location) = JSONParserHelper.parseEverything(json: subJSON)
                            if event != nil && org != nil && location != nil {
                                events.insert(event!)
                                orgs.insert(org!)
                                locations.insert(location!)
                                for tag in subTags {
                                    tags.insert(tag)
                                }
                            }
                        }
                    }
                    completion(events, orgs, tags, locations)

                case .failure(let error):
                    print(error)
                    completion(Set(), Set(), Set(), Set())
                }
        }
    }

    //Returns Array of events, array of deleted event ids, and timestamp as a string.
    static func fetchUpdatedEvents(serverToken: String, timestamp: Date, start: Date, end: Date, completion: @escaping ([Event]?, [Int]?, Date?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken

        let URL = Endpoint.getURLString(address: .eventsFeedAddress, queryParams: [
            .timeStamp: DateFormatHelper.timestamp(from: timestamp),
            .startTime: DateFormatHelper.timestamp(from: start),
            .endTime: DateFormatHelper.timestamp(from: end)
        ])

        Alamofire.request(URL).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var events : [Event] = []
                    if let updatedJSON = json["events"].array {
                        for subJSON in updatedJSON {
                            let event = JSONParserHelper.parseEvent(json: subJSON)
                            if event != nil {
                                events.append(event!)
                            }
                        }
                    }
                    // not given under first version of api
                    let deleted : [Int] = []
                    completion(events, deleted, Date())

                case .failure(let error):
                    print(error)
                    completion(nil, nil, nil)
                }
        }

    }

    //Returns Array of events, array of deleted event ids, and timestamp as a string.
    static func fetchEventDetails(serverToken: String, id: Int, completion: @escaping (Event?) -> Void) {
        let headers : HTTPHeaders = ["Authorization" : serverToken]

        let qp = [Endpoint.QueryParam.eventPk : String(id)]
        let URL = Endpoint.getURLString(address: .eventDetailsAddress, queryParams: qp)

        Alamofire.request(URL, headers: headers).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
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

    static func fetchSingleTag(serverToken: String, id: Int, completion: @escaping (Tag?) -> Void) {
        let headers : HTTPHeaders = ["Authorization" : serverToken]

        let qp = [Endpoint.QueryParam.tagPk : String(id)]
        let URL = Endpoint.getURLString(address: .tagAddress, queryParams: qp)

        Alamofire.request(URL, headers: headers).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
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

    static func fetchLocationDetail(serverToken: String, id: Int, completion: @escaping (Location?) -> Void) {
        let headers : HTTPHeaders = ["Authorization" : serverToken]

        let qp = [Endpoint.QueryParam.locationPk : String(id)]
        let URL = Endpoint.getURLString(address: .locationAddress, queryParams: qp)

        Alamofire.request(URL, headers: headers).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
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

    static func fetchOrganizationDetail(serverToken: String, id: Int, completion: @escaping (Organization?) -> Void) {
        let headers : HTTPHeaders = ["Authorization" : serverToken]

        let qp = [Endpoint.QueryParam.organizationPk : String(id)]
        let URL = Endpoint.getURLString(address: .organizationAddress, queryParams: qp)

        Alamofire.request(URL, headers: headers).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
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

    static func changeAttendance(serverToken: String, id: Int, attend: Bool, completion: @escaping (Bool) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = "Token \(serverToken)"

        let qp = [Endpoint.QueryParam.eventPk : String(id)]
        let URL = Endpoint.getURLString(address: attend ? .incrementAttendanceAddress : .decrementAttendanceAddress, queryParams: qp)

        Alamofire.request(URL, method: .post, parameters: [:], encoding: JSONEncoding.default, headers: headers).validate().responseString(queue: DispatchQueue.global(qos: .default)) { response in
            switch response.result {
            case .success(let value):
                print("value", value)
                completion(true)
            case .failure(let error):
                print("error", error)
                completion(false)
            }
        }

    }

    static func fetchEventsByOrganization(serverToken: String, id: Int, completion: @escaping ([Event]?) -> Void) {
        var headers = Alamofire.SessionManager.defaultHTTPHeaders
        headers["Authorization"] = serverToken

        let qp = [Endpoint.QueryParam.organizationPk : String(id)]
        let URL = Endpoint.getURLString(address: .organizationEventAddress, queryParams: qp)

        Alamofire.request(URL, parameters: [:], headers: headers).validate().responseJSON(queue: DispatchQueue.global(qos: .default)) { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    var events : [Event] = []
                    if let updatedJSON = json["updated"].array {
                        for subJSON in updatedJSON {
                            let event = JSONParserHelper.parseEvent(json: subJSON)
                            if event != nil {
                                events.append(event!)
                            }
                        }
                        completion(events)
                    } else {
                        completion(nil)
                    }

                case .failure(let error):
                    print(error)
                    completion(nil)
                }
        }

    }

}
