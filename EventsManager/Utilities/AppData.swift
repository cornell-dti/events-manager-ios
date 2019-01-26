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
    static let EVENT_DATA_KEY = "event data"
    static let EVENT_IMAGE_DIMENTION: UInt = 1500

    /**
     Returns the organization struct with id pk.
     Requires: pk is a valid organization id. If no existing organizations match pk, any organization might be returned.
     */
    static func getOrganization(by pk: Int) -> Organization {
        return Organization(id: pk, name: "Cornell DTI", description: "Cornell DTI is a project team that creates technology to address needs on Cornell's campus, and beyond. Our team consists of 50 product managers, designers and developers working on 6 projects ranging from a campus safety app to a course review website. Check out our projects to see what we're up to!", avatar: URL(string: "https://avatars3.githubusercontent.com/u/19356609?s=200&v=4")!, photoID: [], events: [], members: [], website: "cornelldit.org", email: "connect@cornelldti.org")
    }

    /**
     Returns the tag with id pk.
     Requires: pk is a valid tag id. If no existing tags match pk, an empty string will be returned.
     */
    static func getTag(by pk: Int) -> Tag {
        return Tag(id: pk, name: "#lolololol")
    }
    
    /**
     Retrieves all events that are saved locally.
     */
    static func getEvents() -> [Event]{
        //for testing
        var events:[Event] = []
        let date1 = "2019-01-20 16:39:57"
        let date2 = "2019-01-20 18:39:57"
        for _ in 1...20 {
            events.append(Event(id: 1, startTime: DateFormatHelper.datetime(from: date1)!, endTime: DateFormatHelper.datetime(from: date2)!, eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventLocationID: "KORNELLUNIVERSITY", eventImage: URL(string: "http://ethanhu.me/images/background.jpg")!, eventOrganizer: 1, eventDescription: "The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog. The quick brown fox jumps over the lazy dog.", eventTags: [1], eventParticipantCount: 166))
        }
        return events
    }
    
    /**
     Retrieves all events associated with tag tag.
     */
    static func getEventsAssociatedWith(tag: Int) -> [Event] {
        let events = getEvents()
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
        let events = getEvents()
        var filteredEvents:[Event] = []
        for event in events {
            if event.eventOrganizer == event.eventOrganizer {
                filteredEvents.append(event)
            }
        }
        return filteredEvents
    }
    
    
    /**
     Updates all saved events to newest.
    */
    static func updateEvents(){
        
    }
}
