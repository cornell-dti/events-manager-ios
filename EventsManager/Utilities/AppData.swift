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
    static let DUMMY_URL = "http://ethanhu.me/images/background.jpg"
    static let DUMMY_TAG = "#CornellDTI"
    static let DUMMY_EVENT = Event(id: 0, startTime: Date(), endTime: Date(), eventName: "DTI", eventLocation: 0, eventImage: URL(string: AppData.DUMMY_URL)!, eventOrganizer: 0, eventDescription: "", eventTags: [], eventParticipantCount: 0, isPublic: false, location: Location(id: 0, building: "Gates Hall", room: "G01", placeId: "ChIJndqRYRqC0IkR9J8bgk3mDvU"))
    
    /**
     Returns the tuple of string of the location the PK corresponds to, and the placeID. The string returned is a full string, including the building and the room
     Requires: pk is a valid location id. If no existing locations match pk, an empty string will be returned.
     */
    static func getLocationPlaceIdTuple(by pk: Int, startLoading: (@escaping () -> Void) -> Void, endLoading: @escaping ()-> Void, noConnection: () -> Void, updateData: Bool) -> (String, String) {
        if updateData {
            if CheckInternet.Connection() {
                if let serverToken = UserData.serverToken() {
                    startLoading {
                        Internet.fetchLocation(serverToken: serverToken, locationPk: pk, completion: { location in
                            if let location = location {
                                do {
                                    let jsonData = try JSONEncoder().encode(location)
                                    UserDefaults.standard.set(jsonData, forKey: "\(LOC_QUERY_KEY)\(pk)")
                                } catch {
                                    print (error)
                                }
                                runAsyncFunction{
                                    NotificationCenter.default.post(name: .updatedLocation, object: nil)
                                    endLoading()
                                }
                            }
                        })
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
                        Internet.fetchOrganizationDetail(serverToken: serverToken, id: pk, completion: { organization in
                            if let organization = organization {
                                do {
                                    let jsonData = try JSONEncoder().encode(organization)
                                    UserDefaults.standard.set(jsonData, forKey: "\(ORG_QUERY_KEY)\(pk)")
                                } catch {
                                    print (error)
                                }
                            }
                            runAsyncFunction{
                                NotificationCenter.default.post(name: .updatedOrg, object: nil)
                                endLoading()
                            }
                        })
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
                        Internet.fetchSingleTag(serverToken: serverToken, id: pk, completion: { tag in
                            if let tag = tag {
                                do {
                                    let jsonData = try JSONEncoder().encode(tag)
                                    UserDefaults.standard.set(jsonData, forKey: "\(TAG_QUERY_KEY)\(pk)")
                                } catch {
                                    print (error)
                                }
                            }
                            runAsyncFunction{
                                NotificationCenter.default.post(name: .updatedTag, object: nil)
                                endLoading()
                            }
                        })
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
                            runAsyncFunction{
                                NotificationCenter.default.post(name: .updatedEvent, object: nil)
                                endLoading()
                            }
                        })
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
                    let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: Date()))!
                    let endDate = Calendar.current.date(byAdding: .year, value: 1, to: startDate)!
                    startLoading{
                        Internet.fetchUpdatedEvents(serverToken: serverToken, timestamp: startDate, start: startDate, end: endDate, completion: {events, deleted, timestamp in
                            if let events = events {
                                var savedEventsPk:[Int] = []
                                var uniqueLocId = Set<Int>()
                                var uniqueOrgId = Set<Int>()
                                var uniquetagId = Set<Int>()
                                for event in events {
                                    savedEventsPk.append(event.id)
                                    uniqueLocId.insert(event.eventLocation)
                                    uniqueOrgId.insert(event.eventOrganizer)
                                    event.eventTags.forEach{uniquetagId.insert($0)}
                                    do {
                                        let jsonData = try JSONEncoder().encode(event)
                                        UserDefaults.standard.set(jsonData, forKey: "\(EVENT_QUERY_KEY)\(event.id)")
                                    } catch {
                                        print (error)
                                    }
                                }
                                //update locationion, orgs, tags
                                uniqueLocId.forEach{ tagId in
                                    let group = DispatchGroup()
                                    group.enter()
                                    DispatchQueue.global(qos: .default).async {
                                        _ = getLocationPlaceIdTuple(by: tagId, startLoading: GenericLoadingHelper.voidLoading(), endLoading: {
                                            group.leave()
                                        }, noConnection: {}, updateData: true)
                                    }
                                    group.wait()
                                }
                                uniqueOrgId.forEach{ orgId in
                                    let group = DispatchGroup()
                                    group.enter()
                                    DispatchQueue.global(qos: .default).async {
                                        _ = getOrganization(by: orgId, startLoading: GenericLoadingHelper.voidLoading(), endLoading: {group.leave()}, noConnection: {}, updateData: true)
                                    }
                                    group.wait()
                                }
                                uniquetagId.forEach{ tagId in
                                    let group = DispatchGroup()
                                    group.enter()
                                    DispatchQueue.global(qos: .default).async {
                                        _ = getTag(by: tagId, startLoading: GenericLoadingHelper.voidLoading(), endLoading: {group.leave()}, noConnection: {}, updateData: true)
                                    }
                                    group.wait()
                                }
                                UserDefaults.standard.set(savedEventsPk, forKey: SAVED_EVENTS_KEY)
                                runAsyncFunction({
                                    NotificationCenter.default.post(name: .reloadData, object: nil)
                                    endLoading()
                                })
                            }
                        })
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
    static func getEventsAssociatedWith(tag: Int) -> [Event] {
        let events = AppData.getEvents(startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: false)
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
    static func getEventsAssociatedWith(organization: Int) -> [Event] {
        let events = getEvents(startLoading: {_ in}, endLoading: {}, noConnection: {}, updateData: false)
        var filteredEvents:[Event] = []
        for event in events {
            if event.eventOrganizer == event.eventOrganizer {
                filteredEvents.append(event)
            }
        }
        return filteredEvents
    }
    
    /**
     Runs `function` asynchronously. Use when attempting to modify UI from functions that involve internet connections. This is required because the UI thread must be independent from the internet threads in iOS, and not using this function will result in an exception.
     - parameter function: Function to run
     */
    private static func runAsyncFunction(_ function:(() -> ())?)
    {
        if (function == nil) {
            return
        }
        DispatchQueue.main.async(execute: {
            function?()
        })
    }
}


/**
 Names for custom notifications. Classes interested in receiving notifications for a particular event should subscribe to the event's corresponding notification. Another class generates notifications for the particular event.
 */
extension Notification.Name
{
    static let reloadData = Notification.Name("reloadData")
    static let updatedLocation = Notification.Name("updatedLocation")
    static let updatedOrg = Notification.Name("updatedOrg")
    static let updatedTag = Notification.Name("updatedTag")
    static let updatedEvent = Notification.Name("updatedEvent")
}


