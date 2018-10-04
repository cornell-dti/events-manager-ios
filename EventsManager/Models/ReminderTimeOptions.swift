//
//  ReminderTimeOptions.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/28/18.
//

import Foundation

enum ReminderTimeOptions {
    case oneHourBefore
    case halfAnHourBefore
    case fifteenMinutesBefore
    case none

    static let count = 3

    /**
     Gets the reminder time option by its index in the enum
     - index: The index of the time option to fetch
    */
    static func getCase(by index: Int) -> ReminderTimeOptions {
        switch index {
            case 0:
                return .oneHourBefore
            case 1:
                return .halfAnHourBefore
            case 2:
                return .fifteenMinutesBefore
            default:
                return .none
        }
    }
}
