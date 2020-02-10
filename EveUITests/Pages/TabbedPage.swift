//
//  TabbedPage.swift
//  EventsManagerUITests
//
//  Created by Rodrigo Taipe on 2/9/20.
//  Copyright © 2020 Jagger Brulato. All rights reserved.
//

import Foundation
import XCTest

class TabbedPage: Page {
    lazy var discoverTab = app.buttons["Discover"].firstMatch
    lazy var forYouTab = app.buttons["For You"].firstMatch
    lazy var myEventsTab = app.buttons["My Events"].firstMatch
    lazy var myProfileTab = app.buttons["My Profile"].firstMatch

    func openDiscover() -> EventsDiscoveryPage {
        discoverTab.tap()
        return EventsDiscoveryPage(app)
    }

    func openForYou() -> ForYouPage {
        forYouTab.tap()
        return ForYouPage(app)
    }

    func openMyEvents() -> MyEventsPage {
        myEventsTab.tap()
        return MyEventsPage(app)
    }

    func openMyProfile() -> MyProfilePage {
        myProfileTab.tap()
        return MyProfilePage(app)
    }
}
