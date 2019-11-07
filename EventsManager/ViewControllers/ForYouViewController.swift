//
//  EventsDiscoveryTableViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 2/27/18.
//
//

import UIKit
import Firebase

class ForYouViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, EventCardCellDelegate {
    
    //used for refreshing the view controller
    var refreshControl = UIRefreshControl()
    
    //Constants
    let gAnalyticsScreenName = "for you pg"
    
    let headerHeight: CGFloat = 35
    
    //View Elements
    let tableView = UITableView(frame: CGRect(), style: .grouped)
    
    //Models
    let labelEventsPair = UserData.getRecommendedLabelAndEvents()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.tintColor = UIColor(named: "primaryPink")
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        setup()
    }
    
    /**
     * View initial setups
     */
    func setup() {
        
        view.backgroundColor = UIColor.white
        
        //NAVIGATION STUFFS
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        //Tableview stuffs
        tableView.backgroundColor = UIColor(named: "tableViewBackground")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.register(EventCardCell.self, forCellReuseIdentifier: EventCardCell.identifer)
        tableView.register(EventTableHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: EventTableHeaderFooterView.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        //tableview layout
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(view)
        }
        
    }

    
    @objc func refresh(sender:AnyObject) {
        // Code to refresh table view
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return labelEventsPair.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EventCardCell.identifer) as? EventCardCell{
            cell.selectionStyle = .none
            cell.configure(with: labelEventsPair[indexPath.section].1)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventTableHeaderFooterView.identifier) as! EventTableHeaderFooterView
        header.setMainTitle(labelEventsPair[section].0)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func push(detailsViewController: EventDetailViewController) {
        navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
}
