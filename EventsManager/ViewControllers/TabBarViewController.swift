//
//  TabBarViewController.swift
//  EventsManager
//
//  Created by Amanda Ong on 3/15/18.
//
//

import UIKit

extension UIScrollView {
    func scrollToTop(navigHeight: CGFloat) {
        let desiredOffset = CGPoint(x: 0, y: -navigHeight-3)
        setContentOffset(desiredOffset, animated: true)
        //self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
   }
    func scrollToTopMyProfile() {
           let desiredOffset = CGPoint(x: 0, y: -(contentInset.top))
           setContentOffset(desiredOffset, animated: true)
      }
}

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {
    let discoverIndex = 0
    let forYouIndex = 1
    let myEventsIndex = 2
    let myProfileIndex = 3

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
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let tabBarIndex = tabBarController.selectedIndex
        if tabBarIndex == 0 {
            let navigVC = viewController as? UINavigationController
            let finalVC = navigVC?.viewControllers[0] as? EventsDiscoveryController
            var navigHeight = finalVC?.navigationController?.navigationBar.frame.maxY ?? 0
            let rectWithinTableView : CGRect = (finalVC?.tableView.rectForRow(at: IndexPath(row: 0, section: 0)))!
            navigHeight += rectWithinTableView.minY
            finalVC?.tableView.scrollToTop(navigHeight: navigHeight)
        } else if tabBarIndex == 1 {
            let navigVC = viewController as? UINavigationController
            let finalVC = navigVC?.viewControllers[0] as? ForYouViewController
            var navigHeight = finalVC?.navigationController?.navigationBar.frame.maxY ?? 0
            let rectWithinTableView : CGRect = (finalVC?.tableView.rectForRow(at: IndexPath(row: 0, section: 0)))!
            navigHeight += rectWithinTableView.minY
            finalVC?.tableView.scrollToTop(navigHeight: navigHeight)
        } else if tabBarIndex == 3 {
            let navigVC = viewController as? UINavigationController
            let finalVC = navigVC?.viewControllers[0] as? MyProfileViewController
            finalVC?.tableView.scrollToTopMyProfile()
        }
    }

}
