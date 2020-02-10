//
//  EventsDiscoveryPage.swift
//  EventsManagerUITests
//
//  Created by Rodrigo Taipe on 2/9/20.
//  Copyright © 2020 Jagger Brulato. All rights reserved.
//

import Foundation
import XCTest

class EventsDiscoveryPage: TabbedPage {
    lazy var title = app.staticTexts["Discover"]
    lazy var navBar = app.navigationBars["Discover"]
    lazy var searchButton = navBar.buttons["search"]
    lazy var popularSectionTitle = app.staticTexts["POPULAR"]
    
    @discardableResult
    func openEventsSearchPage() -> EventsSearchPage {
        XCTAssertTrue(searchButton.exists)
        searchButton.tap()
        return EventsSearchPage(app)
    }
}
