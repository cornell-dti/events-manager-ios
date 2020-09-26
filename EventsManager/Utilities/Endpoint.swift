//
//  Endpoint.swift
//  EventsManager
//
//  Created by Rodrigo Taipe on 4/13/19.
//

import Foundation

class Endpoint {
    public static let apiBaseURL = "https://cuevents-staging.herokuapp.com/api/"
//    public static let apiBaseURL = "https://cuevents-app.herokuapp.com/api/"
    public static let deeplinksBaseURL = "https://www.cuevents.org/"
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
        case eventDeepLink
        case organizationDeepLink
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
            return apiBaseURL + "get_token/" + queryParams[.googleToken]!
        case .tagAddress:
            return apiBaseURL + "get_tag/" + queryParams[.tagPk]! + "/"
        case .locationAddress:
            return apiBaseURL + "get_location/" + queryParams[.locationPk]! + "/"
        case .eventsFeedAddress:
            return apiBaseURL + "get_event_feed/"
        case .eventDetailsAddress:
            return apiBaseURL + "get_event/" + queryParams[.eventPk]! + "/"
        case .organizationAddress:
            return apiBaseURL + "get_profile/" + queryParams[.organizationPk]! + "/"
        case .organizationEventAddress:
            return apiBaseURL + "get_events/" + queryParams[.organizationPk]! + "/events/"
        case .incrementAttendanceAddress:
            return apiBaseURL + "increment_attendance/" + queryParams[.eventPk]! + "/"
        case .decrementAttendanceAddress:
            return apiBaseURL + "decrement_attendance/" + queryParams[.eventPk]! + "/"
        case .eventDeepLink:
            return deeplinksBaseURL + "event/" + queryParams[.eventPk]! + "/"
        case .organizationDeepLink:
            return deeplinksBaseURL + "org/" + queryParams[.organizationPk]! + "/"
        }
    }

}
