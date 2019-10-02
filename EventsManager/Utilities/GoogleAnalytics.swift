//
//  GoogleAnalytics.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/31/19.
//

import Foundation
import FirebaseAnalytics

class GoogleAnalytics {
    
    static func trackEvent(category: String, action: String, label: String) {
        Analytics.logEvent("eventClicked", parameters: [
            "category": category,
            "action": action,
            "label": label
            
            ])
    }
    
}
