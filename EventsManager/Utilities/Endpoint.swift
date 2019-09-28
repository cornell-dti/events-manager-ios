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
            return baseURL + "generate_token/" + queryParams[QueryParam.googleToken]! + "/"
        case .tagAddress:
            return baseURL + "tag/" + queryParams[QueryParam.tagPk]! + "/"
        case .locationAddress:
            return baseURL + "loc/" + queryParams[QueryParam.locationPk]! + "/"
        case .eventsFeedAddress:
            return baseURL + "feed/events/"
        case .eventDetailsAddress:
            return baseURL + "event/" + queryParams[QueryParam.eventPk]! + "/"
        case .organizationAddress:
            return baseURL + "org/" + queryParams[QueryParam.organizationPk]! + "/"
        case .organizationEventAddress:
            return baseURL + "org/" + queryParams[QueryParam.organizationPk]! + "/events/"
        case .incrementAttendanceAddress:
            return baseURL + "attendance/increment/" + queryParams[QueryParam.eventPk]! + "/"
        case .decrementAttendanceAddress:
            return baseURL + "attendance/unincrement/" + queryParams[QueryParam.eventPk]! + "/"
        }
    }
    
}
