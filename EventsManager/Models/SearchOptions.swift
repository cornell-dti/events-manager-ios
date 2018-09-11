//
//  SearchOptions.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/11/18.
//

import Foundation

enum SearchOptions {
    case events
    case organization
    case tags
    
    func toString() -> String {
        switch self {
            case .events: return NSLocalizedString("search-segment-events", comment: "")
            case .organization: return NSLocalizedString("search-segment-organizations", comment: "")
            case .tags: return NSLocalizedString("search-segment-tags", comment: "")
        }
    }
    
    static func fromString(_ string: String) -> SearchOptions {
        switch string {
            case NSLocalizedString("search-segment-events", comment: ""): return .events
            case NSLocalizedString("search-segment-organizations", comment: ""): return .organization
            case NSLocalizedString("search-segment-tags", comment: ""): return .tags
            default: return .events
        }
    }
}
