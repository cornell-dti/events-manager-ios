//
//  Page.swift
//  EventsManagerUITests
//
//  Created by Rodrigo Taipe on 2/9/20.
//  Copyright © 2020 Jagger Brulato. All rights reserved.
//

import Foundation
import XCTest

class Page {
    var app: XCUIApplication
    
    required init(_ app: XCUIApplication) {
        self.app = app
    }
}