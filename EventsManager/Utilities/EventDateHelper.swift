//
//  EventDateHelper.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/8/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//
import Foundation

class EventDateHelper {
    /**
     filters the input events and
     returns a tuple containing
     1. valid date sections, sorted from small date to large date, unique
     2. array whose row represents index in sectionDates, column represents events on that date
     */
    public static func getEventsFilteredByDate(with events: [Event]) -> ([Date], [[Event]]) {
        var sectionDateSet = getUniqueDates(in: events)
        sectionDateSet = removePastDates(from: sectionDateSet)
        let sectionDates = sectionDateSet.sorted()
        var eventsOnDate:[[Event]] = []
        for date in sectionDates {
            eventsOnDate.append(getEvents(on: date, for: events))
        }
        assert(sectionDates.count == eventsOnDate.count, "MyEventsVC: num of date sections doesn't match num of date section index keys in eventsOnDate")
        return (sectionDates, eventsOnDate)
    }

    /**
     Get all unique dates
     - events: the array of events this function should search dates from
     - returns: a set of dates, retrieved from @events
     */
    private static func getUniqueDates(in events: [Event]) -> Set<Date> {
        var dates:Set<Date> = []
        for event in events {
            let startTime = event.startTime
            let startDateString = DateFormatHelper.date(from: startTime) //convert starttime to yyyy-mm-dd strings to remove time from date
            let startDate = DateFormatHelper.date(from: startDateString) ?? DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
            dates.insert(startDate)
        }
        return dates
    }

    /**
     Removes dates prior to today
     - dates: the set of dates to perform the operation on
     - returns: a set of dates without dates prior to today
     */
    private static func removePastDates(from dates: Set<Date>) -> Set<Date> {
        var dates = dates
        let today = DateFormatHelper.date(from: DateFormatHelper.date(from: Date()))!
        for date in dates {
            if date < today {
                dates.remove(date)
            }
        }
        return dates
    }

    /**
     Gets events whose start time is on a given date
     - date
     - events
     - returns: array of events on that date
     */
    private static func getEvents(on date:Date, for events: [Event]) -> [Event] {
        var eventsOnDate:[Event] = []
        let dateString = DateFormatHelper.date(from: date)
        for event in events {
            let eventDateString = DateFormatHelper.date(from: event.startTime)
            if dateString == eventDateString {
                eventsOnDate.append(event)
            }
        }
        return eventsOnDate
    }
}
