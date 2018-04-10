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
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone(abbreviation: "EST")
        return formatter
    }()
    
    public static func date(from string:String) -> Date?{
        return dateFromStringFormatter.date(from: string)
    }
    public static func hourMinute(from date:Date) -> String {
        return hourMinuteFromDateFormatter.string(from: date)
    }
    
    
}
