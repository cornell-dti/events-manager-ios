//
//  OnBoardingPage.swift
//  EveUITests
//
//  Created by Rodrigo Taipe on 2/8/20.
//  Copyright © 2020 Jagger Brulato. All rights reserved.
//

import Foundation
import XCTest

class EventDiscoveryPage: Page {
    lazy var myEventsTab = app.buttons["My Events"].firstMatch
    
    func openMyEvents() {
        myEventsTab.tap()
    }
}

