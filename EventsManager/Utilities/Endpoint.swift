//
//  Endpoint.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 4/13/19.
//  Copyright © 2019 Jagger Brulato. All rights reserved.
//

import Foundation

class Endpoint {
    #if DEVELOPMENT
    public static let baseURL = "http://127.0.0.1:8000/"
    #else
    public static let baseURL = "http://cuevents-app.herokuapp.com/"
    #endif
    
    public enum Addresses {
        case serverTokenAddress
        case tagAddress
        case locationAddress
        case eventsFeedAddress
        case eventDetailsAddress
    }
    
    public enum QueryParam {
        case tagPk
        case locationPk
        case eventPk
        case googleToken
    }
    
    public static func getURLString (address: Addresses, queryParams : [QueryParam:String]) -> String {
        switch address {
        case .serverTokenAddress:
            return baseURL + "generate_token/" + queryParams[QueryParam.googleToken]! + "/"
        case .tagAddress:
            return baseURL + "tag/" + queryParams[QueryParam.tagPk]! + "/"
        case .locationAddress:
            return baseURL + "loc/" + queryParams[QueryParam.locationPk]! + "/"
        case .eventsFeedAddress:
            return baseURL + "feed/events/"
        case .eventDetailsAddress:
            return baseURL + "event/" + queryParams[QueryParam.eventPk]! + "/"
        }
    }

}
