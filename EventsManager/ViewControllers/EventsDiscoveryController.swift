//
//  EventsDiscoveryTableViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//  Copyright © 2018 Jagger Brulato. All rights reserved.
//

import UIKit

class EventsDiscoveryController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchControllerDelegate {
    
    var tableView = UITableView()

    var events:[Event] = []
    
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    /**
    * View initial setups
    */
    func setup(){
        //for testing
        for _ in 1...20 {
            events.append(Event(startTime: "9:00 AM", endTime: "10:00 AM", eventName: "Cornell DTI Meeting", eventLocation: "Upson B02", eventParticipant: "David, Jagger, and 10 others", avatars: [URL(string:"http://cornelldti.org/img/team/davidc.jpg")!, URL(string:"http://cornelldti.org/img/team/jaggerb.JPG")!], eventImage: URL(string:"http://ethanhu.me/images/background.jpg")!, eventOrganizer: "Cornell DTI", eventDiscription: "THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION THIS IS THE DISCRIPTION "))
        }
        
        //NAVIGATION STUFFS
        searchController.delegate = self
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        //Tableview stuffs
        //let topBarHeight = (navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.height //statusbar + navbar + tagbar
        //let bottomBarHeight = CGFloat(integerLiteral: 0)
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventsDiscoveryCell", for: indexPath) as! EventsDiscoveryTableViewCell
        cell.configure(event: events[indexPath.row])
        // Configure the cell...

        return cell
    }
    
    /*
     segue to the selected eventsDetailController
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = EventDetailViewController()
        detailsViewController.configure(with: events[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

}
