//
//  EventsManagerUITests.swift
//  EventsManagerUITests
//
//  Created by Jagger Brulato on 1/28/18.
//
//

import XCTest

class EveUITests: XCTestCase {

    override func setUp() {
        super.setUp()

        // Stop when encounter failure -
        // for future testing, may set to true to test all.
        continueAfterFailure = false
        
        let app = XCUIApplication()
        app.launchArguments.append("-UITesting")
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    /**
     Tests that tab titles exist for the: Discover page, For You page, My Events page, Profile page
     */
    func testAllTabTitles() {
        let app = XCUIApplication()
        XCTAssertTrue(EventsDiscoveryPage(app).openDiscover().title.exists)
        XCTAssertTrue(EventsDiscoveryPage(app).openForYou().title.exists)
        XCTAssertTrue(ForYouPage(app).openMyEvents().title.exists)
        XCTAssertTrue(MyEventsPage(app).openMyProfile().title.exists)
    }

    func testEventsSearchPage() {
        let app = XCUIApplication()
        EventsDiscoveryPage(app).openEventsSearchPage()
    }

    func testEventDetailPage() {
                
    }
//    func testDiscoveryEventsPage() {
//        let app = XCUIApplication()
//        let _ = EventsDiscoveryPage(app).openDiscover()
//        let titleExists = EventsDiscoveryPage(app).title.exists
//        let popularTitleExists = EventsDiscoveryPage(app).popularSectionTitle.exists
//        XCTAssert(titleExists)
//        XCTAssert((popularTitleExists))
//    }
//    func testForYouPage() {
//        let app = XCUIApplication()
//        let _ = EventsDiscoveryPage(app).openForYou()
//
//    }
//    func testMyEventsPage() {
//        let app = XCUIApplication()
//        let _ = EventsDiscoveryPage(app).openMyEvents()
//    }
//    func testMyProfilePage() {
//        let app = XCUIApplication()
//        let _ = EventsDiscoveryPage(app).openMyProfile()
//    }

}
