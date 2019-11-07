//
//  Endpoint.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 4/13/19.
//

import Foundation

class Endpoint {
    public static let baseURL = "https://cuevents-staging.herokuapp.com/"
    
    public enum Addresses {
        case serverTokenAddress
        case tagAddress
        case locationAddress
        case eventsFeedAddress
        case eventDetailsAddress
        case organizationAddress
        case organizationEventAddress
        case incrementAttendanceAddress
        case decrementAttendanceAddress
        case eventUniversalLink
    }
    
    public enum QueryParam {
        case tagPk
        case locationPk
        case eventPk
        case organizationPk
        case googleToken
    }
    
    public static func getURLString (address: Addresses, queryParams : [QueryParam:String]) -> String {
        switch address {
        case .serverTokenAddress:
            return baseURL + "generate_token/" + queryParams[.googleToken]! + "/"
        case .tagAddress:
            return baseURL + "tag/" + queryParams[.tagPk]! + "/"
        case .locationAddress:
            return baseURL + "loc/" + queryParams[.locationPk]! + "/"
        case .eventsFeedAddress:
            return baseURL + "feed/events/"
        case .eventDetailsAddress:
            return baseURL + "event/" + queryParams[.eventPk]! + "/"
        case .organizationAddress:
            return baseURL + "org/" + queryParams[.organizationPk]! + "/"
        case .organizationEventAddress:
            return baseURL + "org/" + queryParams[.organizationPk]! + "/events/"
        case .incrementAttendanceAddress:
            return baseURL + "attendance/increment/" + queryParams[.eventPk]! + "/"
        case .decrementAttendanceAddress:
            return baseURL + "attendance/unincrement/" + queryParams[.eventPk]! + "/"
        case .eventUniversalLink:
            return "https://www.cuevents.org/event/" + queryParams[.eventPk]! + "/"
        }
    }
    
}
