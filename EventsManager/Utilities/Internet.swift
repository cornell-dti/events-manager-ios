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
    
    

}
