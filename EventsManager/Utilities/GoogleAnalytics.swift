//
//  GoogleAnalytics.swift
//  EventsManager
//
//  Created by Ethan Hu on 8/31/19.
//

import Foundation

class GoogleAnalytics {
    
    static func trackEvent(category: String, action: String, label: String, value: Int? = nil) {
        guard
            let tracker = GAI.sharedInstance().defaultTracker,
            let builder = GAIDictionaryBuilder.createEvent(withCategory: category, action: action, label: label, value: NSNumber(integerLiteral: value ?? 0))
            else { return }
        
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    static func trackScreen(screenName: String) {
        guard let tracker = GAI.sharedInstance().defaultTracker else { return }
        tracker.set(kGAIScreenName, value: screenName)
        
        guard let builder = GAIDictionaryBuilder.createScreenView() else { return }
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
}
