//
//  TabBarViewController.swift
//  EventsManager
//
//  Created by Amanda Ong on 3/15/18.
//
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    var discoverNavVC = UINavigationController()
    var myEventsNavVC = UINavigationController()
    var myProfileNavVC = UINavigationController()
    var forYouNavVC = UINavigationController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        setUpViewControllers()

        // Tab Bar
        tabBar.tintColor = UIColor(named: "primaryPink") // Icon color of Active tab
        tabBar.unselectedItemTintColor = UIColor.gray // Icon color of Inactive tab

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    private func setUpViewControllers() {
        discoverNavVC = makeNavVC(viewController: EventsDiscoveryController(), title: NSLocalizedString("discover", comment: ""), tabBarIcon: #imageLiteral(resourceName: "discover"))
        forYouNavVC = makeNavVC(viewController: ForYouViewController(), title: NSLocalizedString("for-you",
            comment: ""), tabBarIcon: #imageLiteral(resourceName: "foryou"))
        myEventsNavVC = makeNavVC(viewController: MyEventsViewController(), title: NSLocalizedString("my-events", comment: ""), tabBarIcon: #imageLiteral(resourceName: "myevents"))
        myProfileNavVC = makeNavVC(viewController: MyProfileViewController(), title: NSLocalizedString("my-profile", comment: ""), tabBarIcon: #imageLiteral(resourceName: "profile"))

        let controllers = [discoverNavVC, forYouNavVC, myEventsNavVC, myProfileNavVC]
        self.viewControllers = controllers
    }

    private func makeNavVC(viewController: UIViewController, title: String, tabBarIcon: UIImage) -> UINavigationController {
        // Set up each view controller's tab bar
        let tabBarItem = UITabBarItem(title: title, image: tabBarIcon, selectedImage: tabBarIcon)
        viewController.tabBarItem = tabBarItem

        // Set up each view controller's nav bar
        viewController.navigationItem.title = title

        let navVC = UINavigationController(rootViewController: viewController)
        return navVC
    }

}
