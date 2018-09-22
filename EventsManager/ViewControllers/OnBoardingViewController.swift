//
//  OnBoardingViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 9/22/18.
//

import UIKit

class OnBoardingViewController: UIViewController {
    
    //constants
    let navTitleFontSize:CGFloat = 25
    let navSubtitleFontSize:CGFloat = 15
    let titleToTopSpacing:CGFloat = 10
    let titleToSubtitleSpacing:CGFloat = 5
    let sideSpacing:CGFloat = 5
    
    //datasource
    var organizations:[Organization] = []
    var checkOrganization:[Organization] = []
    
    
    var searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
    }
    
    
    /**
     Sets the basic layout of the view
     */
    func setLayout() {
        //navigation stuffs
        navigationController?.title = NSLocalizedString("onboarding-interact-title", comment: "")
        if #available(iOS 11, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true;
            self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        //Navigation bar height cannot be change in > iOS 11. We require the text to be fit into two lines.
        navigationItem.titleView = setTitle(title: "Interact", subtitle: "Choose some on-campus organizations that you would like to follow. ")
        navigationItem.searchController = searchController
        //searchController.delegate = self
        //searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        //searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = NSLocalizedString("search", comment: "")
        definesPresentationContext = true
        
        
        view.backgroundColor = UIColor.white
    }
    
    func setTitle(title:String, subtitle:String) -> UIView {
        
        //Get navigation Bar Height and Width
        let navigationBarWidth = Int(self.navigationController!.navigationBar.frame.width)
        let navigationBarHeight = Int(self.navigationController!.navigationBar.frame.height)
        
        let titleLabel = UILabel()
        let subtitleLabel = UILabel()
        
        titleLabel.font = UIFont(name: "Dosis-Bold", size: navTitleFontSize)
        subtitleLabel.font = UIFont(name: "Dosis-Book", size: navSubtitleFontSize)
        titleLabel.textColor = UIColor(named: "primaryPink")
        subtitleLabel.textColor = UIColor.gray
        subtitleLabel.numberOfLines = 2
        
        titleLabel.text = title
        subtitleLabel.text = subtitle
        
        
        //Add Title and Subtitle to View
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: navigationBarWidth, height: navigationBarHeight))
        titleView.addSubview(titleLabel)
        titleView.addSubview(subtitleLabel)
        
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleView).offset(titleToTopSpacing)
            make.left.equalTo(titleView).offset(sideSpacing)
            make.right.equalTo(titleView).offset(-sideSpacing)
        }
        
        subtitleLabel.snp.makeConstraints{ make in
            make.top.equalTo(titleLabel.snp.bottom).offset(titleToSubtitleSpacing)
            make.left.equalTo(titleView).offset(sideSpacing)
            make.right.equalTo(titleView).offset(-sideSpacing)
        }
        
        return titleView
        
    }
    
    
}
