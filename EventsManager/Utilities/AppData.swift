//
//  AppData.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/19/18.
//

import Foundation

/**
 AppData contains helper functions that deals with app data like organization, tags, and events.
 */
class AppData {
    static let ORG_QUERY_KEY = "organization_pk_"
    static let LOC_QUERY_KEY = "location_pk_"
    static let TAG_QUERY_KEY = "tag_pk_"
    static let SAVED_EVENTS_KEY = "saved events"
    static let EVENT_QUERY_KEY = "event_pk_"
    static let EVENT_IMAGE_DIMENTION: UInt = 1500
    static let DUMMY_URL = "https://www.cornelldti.org"
    static let DUMMY_TAG = "#CornellDTI"
    static let DUMMY_EVENT = Event(id: 0, startTime: Date(), endTime: Date(), eventName: "DTI", eventLocation: 0, eventImage: URL(string: AppData.DUMMY_URL)!, eventOrganizer: 0, eventDescription: "", eventTags: [], eventParticipantCount: 0, isPublic: false)
    
    /**
     Returns the tuple of string of the location the PK corresponds to, and the placeID. The string returned is a full string, including the building and the room
     Requires: pk is a valid location id. If no existing locations match pk, an empty string will be returned.
     */
    static func getLocationPlaceIdTuple(by pk: Int, startLoading: (() -> Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData: Bool) -> (String, String) {
        if updateData {
            if CheckInternet.Connection() {
                if let serverToken = UserData.serverToken() {
                    startLoading {
                        let group = DispatchGroup()
                        group.enter()
                        Internet.fetchLocation(serverToken: serverToken, locationPk: pk, completion: { location in
                            if let location = location {
                                do {
                                    let jsonData = try JSONEncoder().encode(location)
                                    UserDefaults.standard.set(jsonData, forKey: "\(LOC_QUERY_KEY)\(pk)")
                                } catch {
                                    print (error)
                                }
                                group.leave()
                            }
                        })
                        group.wait()
                        endLoading()
                    }
                }
            }
            else {
                noConnection()
            }
        }
        if let jsonData = UserDefaults.standard.data(forKey: "\(LOC_QUERY_KEY)\(pk)") {
            do {
                let location = try JSONDecoder().decode(Location.self, from: jsonData)
                return ("\(location.building) \(location.room)", location.placeId)
            } catch {
                print(error)
            }
        }
        return ("", "");
    }

    /**
     Returns the organization struct with id pk.
     Requires: pk is a valid organization id. If no existing organizations match pk, any organization might be returned.
     */
    static func getOrganization(by pk: Int, startLoading: (@escaping () -> Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData: Bool) -> Organization {
        if updateData {
            if CheckInternet.Connection() {
                if let serverToken = UserData.serverToken() {
                    startLoading{
                        let group = DispatchGroup()
                        group.enter()
                        Internet.fetchOrganizationDetail(serverToken: serverToken, id: pk, completion: { organization in
                            if let organization = organization {
                                do {
                                    let jsonData = try JSONEncoder().encode(organization)
                                    UserDefaults.standard.set(jsonData, forKey: "\(ORG_QUERY_KEY)\(pk)")
                                } catch {
                                    print (error)
                                }
                            }
                            group.leave()
                        })
                        group.wait()
                        endLoading()
                    }
                }
                
            }
            else {
                noConnection()
            }
        }
        if let jsonData = UserDefaults.standard.data(forKey: "\(ORG_QUERY_KEY)\(pk)") {
            do {
                return try JSONDecoder().decode(Organization.self, from: jsonData)
            } catch {
                print(error)
            }
        }
        return Organization(
            id: 0,
            name: "",
            description: "",
            avatar: URL(string: DUMMY_URL)!,
            website: "",
            email: ""
        )
    }

    /**
     Returns the tag with id pk.
     Requires: pk is a valid tag id. If no existing tags match pk, an empty string will be returned.
     */
    static func getTag(by pk: Int, startLoading: (@escaping ()->Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData: Bool) -> Tag {
        if updateData {
            if CheckInternet.Connection() {
                if let serverToken = UserData.serverToken() {
                    startLoading {
                        let group = DispatchGroup()
                        group.enter()
                        Internet.fetchSingleTag(serverToken: serverToken, id: pk, completion: { tag in
                            if let tag = tag {
                                do {
                                    let jsonData = try JSONEncoder().encode(tag)
                                    UserDefaults.standard.set(jsonData, forKey: "\(TAG_QUERY_KEY)\(pk)")
                                } catch {
                                    print (error)
                                }
                            }
                            group.leave()
                        })
                        group.wait()
                        endLoading()
                    }
                }
                
            }
            else {
                noConnection()
            }
        }
        if let jsonData = UserDefaults.standard.data(forKey: "\(TAG_QUERY_KEY)\(pk)") {
            do {
                return try JSONDecoder().decode(Tag.self, from: jsonData)
            } catch {
                print(error)
            }
        }
        return Tag(id: pk, name: DUMMY_TAG)
    }
    
    static func getEvent(pk:Int, startLoading: (@escaping ()->Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData: Bool) -> Event {
        if updateData {
            if CheckInternet.Connection() {
                if let serverToken = UserData.serverToken() {
                    startLoading {
                        let group = DispatchGroup()
                        group.enter()
                        Internet.fetchEventDetails(serverToken: serverToken, id: pk, completion: { event in
                            if let event = event {
                                _ = getLocationPlaceIdTuple(by: event.eventLocation, startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: true)
                                _ = getOrganization(by: event.eventOrganizer, startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: true)
                                for tag in event.eventTags {
                                    _ = getTag(by: tag, startLoading: {_ in }, endLoading: {}, noConnection: {}, updateData: true)
                                }
                                do {
                                    let jsonData = try JSONEncoder().encode(event)
                                    UserDefaults.standard.set(jsonData, forKey: "\(EVENT_QUERY_KEY)\(event.id)")
                                } catch {
                                    print (error)
                                }
                            }
                            group.leave()
                        })
                        group.wait()
                        endLoading()
                    }
                }
                
            }
        }
        if let jsonData = UserDefaults.standard.data(forKey: "\(EVENT_QUERY_KEY)\(pk)") {
            do {
                return try JSONDecoder().decode(Event.self, from: jsonData)
            } catch {
                print(error)
            }
        }
        return DUMMY_EVENT
    }
    
    /**
     Retrieves all events that are saved locally.
     */
    static func getEvents(startLoading: (@escaping () -> Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData: Bool) -> [Event]{
        if updateData {
            if CheckInternet.Connection() {
                if let serverToken = UserData.serverToken() {
                    startLoading {
                        let group = DispatchGroup()
                        group.enter()
                        let startDate = DateFormatHelper.date(from: "2019-01-01")!
                        let endDate = Date()
                        Internet.fetchUpdatedEvents(serverToken: serverToken, timestamp: startDate, start: startDate, end: endDate, completion: {events, deleted, timestamp in
                            if let events = events {
                                var savedEventsPk:[Int] = []
                                for event in events {
                                    savedEventsPk.append(event.id)
                                    //update location, organization, tags related with event
                                    _ = getLocationPlaceIdTuple(by: event.eventLocation, startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: true)
                                    _ = getOrganization(by: event.eventOrganizer, startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: true)
                                    for tag in event.eventTags {
                                        _ = getTag(by: tag, startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: true)
                                    }
                                    
                                    do {
                                        let jsonData = try JSONEncoder().encode(event)
                                        UserDefaults.standard.set(jsonData, forKey: "\(EVENT_QUERY_KEY)\(event.id)")
                                    } catch {
                                        print (error)
                                    }
                                }
                                UserDefaults.standard.set(savedEventsPk, forKey: "nums")
                            }
                            group.leave()
                        })
                        group.wait()
                        endLoading()
                    }
                }
                
            }
            else {
                noConnection()
            }
        }
        if let savedEventsPk = UserDefaults.standard.array(forKey: SAVED_EVENTS_KEY) as? [Int] {
            var events:[Event] = []
            for id in savedEventsPk {
                if let jsonData = UserDefaults.standard.data(forKey: "\(EVENT_QUERY_KEY)\(id)") {
                    do {
                        events.append(try JSONDecoder().decode(Event.self, from: jsonData))
                    } catch {
                        print(error)
                    }
                }
            }
            return events
        }
        return []
    }
    
    /**
     Retrieves all events associated with tag tag.
     */
    static func getEventsAssociatedWith(tag: Int, startLoading: (() -> Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData: Bool) -> [Event] {
        let events = getEvents(startLoading: startLoading, endLoading: endLoading, noConnection: noConnection, updateData: updateData)
        var filteredEvents:[Event] = []
        for event in events {
            if event.eventTags.contains(tag) {
                filteredEvents.append(event)
            }
        }
        return filteredEvents
    }
    
    
    /**
     Retrieves all events associated with organization organization.
     */
    static func getEventsAssociatedWith(organization: Int, startLoading: (() -> Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData:Bool) -> [Event] {
        let events = getEvents(startLoading: startLoading, endLoading: endLoading, noConnection: noConnection, updateData: updateData)
        var filteredEvents:[Event] = []
        for event in events {
            if event.eventOrganizer == event.eventOrganizer {
                filteredEvents.append(event)
            }
        }
        return filteredEvents
    }
}
