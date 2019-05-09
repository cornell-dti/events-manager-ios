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
    
    static func getInt(from caseTime : ReminderTimeOptions) -> Int {
        switch caseTime {
            case .oneHourBefore:
                return 0
            case .halfAnHourBefore:
                return 1
            case .fifteenMinutesBefore:
                return 2
            default:
                return -1
        }
    }
    
    static func getValue(from caseTime: ReminderTimeOptions) -> Int {
        switch caseTime {
        case .oneHourBefore:
            return 60
        case .halfAnHourBefore:
            return 30
        case .fifteenMinutesBefore:
            return 15
        default:
            return 0
        }
    }
}
