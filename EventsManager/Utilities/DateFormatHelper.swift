//
//  DateFormatHelper.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/10/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import Foundation

class DateFormatHelper {
    private static let dateFromStringFormatter:DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            formatter.timeZone = TimeZone(abbreviation: "EST")
            return formatter
    }()
    
    private static let hourMinuteFromDateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm a"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        return formatter
    }()
    
    private static let monthFromDateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMM"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        return formatter
    }()
    
    private static let dayFromDateFormatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        return formatter
    }()
    
    public static func date(from string:String) -> Date?{
        return dateFromStringFormatter.date(from: string)
    }
    public static func hourMinute(from date:Date) -> String {
        return hourMinuteFromDateFormatter.string(from: date)
    }
    public static func month(from date:Date) -> String {
        return monthFromDateFormatter.string(from: date)
    }
    public static func day(from date:Date) -> String {
        return dayFromDateFormatter.string(from: date)
    }
    
    
}
