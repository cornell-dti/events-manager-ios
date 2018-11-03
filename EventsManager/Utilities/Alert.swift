//
//  Alert.swift
//  EventsManager
//
//  Created by Ethan Hu on 11/3/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    /**
     Shows a informative alert with message and title.
     */
    static func informative(with message: String, with title: String, from viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("alert-ok", comment: ""), style: .default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
