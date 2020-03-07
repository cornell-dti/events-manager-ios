//
//  Endpoint.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 4/13/19.
//

import Foundation

class Endpoint {
    //public static let baseURL = "https://cuevents-staging.herokuapp.com/api/"
    public static let baseURL = "https://cuevents-app.herokuapp.com/api/"
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
    }

    public enum QueryParam {
        case tagPk
        case locationPk
        case eventPk
        case organizationPk
        case googleToken
        case timeStamp
        case startTime
        case endTime
    }

    public static func getURLString (address: Addresses, queryParams : [QueryParam:String]) -> String {
        switch address {
        case .serverTokenAddress:
            return baseURL + "get_token/" + queryParams[.googleToken]!
        case .tagAddress:
            return baseURL + "get_tag/" + queryParams[.tagPk]! + "/"
        case .locationAddress:
            return baseURL + "get_location/" + queryParams[.locationPk]! + "/"
        case .eventsFeedAddress:
            return baseURL + "get_event_feed/"
        case .eventDetailsAddress:
            return baseURL + "get_event/" + queryParams[.eventPk]! + "/"
        case .organizationAddress:
            return baseURL + "get_profile/" + queryParams[.organizationPk]! + "/"
        case .organizationEventAddress:
            return baseURL + "get_events/" + queryParams[.organizationPk]! + "/events/"
        case .incrementAttendanceAddress:
            return baseURL + "increment_attendance/" + queryParams[.eventPk]! + "/"
        case .decrementAttendanceAddress:
            return baseURL + "decrement_attendance/" + queryParams[.eventPk]! + "/"
        }
    }

}
