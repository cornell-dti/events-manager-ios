//
//  TagViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/9/18.
//
//

import UIKit

//Displays the events as a list, with a optional filter bar at the top.
class EventListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    let recommendedTagView = UIView()
    let recommendedTagScrollView = UIScrollView()
    let datePickerContainerView = UIView()
    let datePicker = UIDatePicker()
    let toolBar = UIToolbar()
    let datePickerTag = DatePickerTagView()

    //constants
    let reccommendedTagViewHeight:CGFloat = 50
    let tagSideMargins:CGFloat = 10
    let tagSpacing:CGFloat = 12
    let datePickerHeight:CGFloat = 300
    let animationDuration = 0.2

    //datasource
    var events = [Event]()
    var filteredEvents = [Event]()
    var recommendedTags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: animated)
        }
    }

    /*
     * Sets up the tag view
     * - events: an events array that tha tag view should filter events from
     * - tag: the tag that should be displayed in this tag view
     */
    func setup(with events:[Event], title: String, withFilterBar: Bool) {
        //NAVIGATION STUFFS
        navigationItem.title = title

        //datasource settings
        self.events = events
        filteredEvents = events
        view.backgroundColor = UIColor.white
        //Recommended TagView
        if withFilterBar {
            getTags()
            //set default date to today
            datePickerTag.setDate(Date())
            filterEvents(by: Date())
            recommendedTagView.backgroundColor = UIColor(named: "tableViewBackground")
            let tagStackView = UIStackView()
            tagStackView.alignment = .center
            tagStackView.axis = .horizontal
            tagStackView.distribution = .fill
            tagStackView.spacing = tagSpacing
            tagStackView.addArrangedSubview(datePickerTag)

            let datePickerPressedGesture = UITapGestureRecognizer(target: self, action: #selector(onDatePickerPressed(_:)))
            datePickerTag.addGestureRecognizer(datePickerPressedGesture)
            for tag in recommendedTags {
                let eventTagButton = EventTagButton()
                eventTagButton.setTitle(tag, for: .normal)
                eventTagButton.addTarget(self, action: #selector(tagButtonPressed(_:)), for: .touchUpInside)
                tagStackView.addArrangedSubview(eventTagButton)
            }
            recommendedTagScrollView.addSubview(tagStackView)
            recommendedTagView.addSubview(recommendedTagScrollView)
            view.addSubview(recommendedTagView)
            tagStackView.snp.makeConstraints { make in
                make.left.equalTo(recommendedTagScrollView).offset(tagSideMargins)
                make.right.equalTo(recommendedTagScrollView).offset(-tagSideMargins)
                make.top.equalTo(recommendedTagScrollView).offset(tagSideMargins)
                make.bottom.equalTo(recommendedTagScrollView).offset(-tagSideMargins)
            }
            recommendedTagScrollView.snp.makeConstraints { make in
                make.edges.equalTo(recommendedTagView)
            }
            recommendedTagView.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.height.equalTo(reccommendedTagViewHeight)
            }
        }

        //Tableview stuffs
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EventsDiscoveryTableViewCell.self, forCellReuseIdentifier: EventsDiscoveryTableViewCell.identifer)
        tableView.rowHeight = UITableViewAutomaticDimension
        view.addSubview(tableView)

        if withFilterBar {
            tableView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(recommendedTagView.snp.bottom)
                make.left.equalTo(view)
                make.right.equalTo(view)
                make.bottom.equalTo(view)
            }
        } else {
            tableView.snp.makeConstraints { (make) -> Void in
                make.edges.equalTo(view)
            }
        }

        //datepicker
        view.addSubview(datePickerContainerView)
        datePickerContainerView.addSubview(datePicker)
        datePickerContainerView.addSubview(toolBar)

        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.center = view.center

        //tool bar
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = view.tintColor
        toolBar.sizeToFit()

        //add button to tool bar
        let doneButton = UIBarButtonItem(title: NSLocalizedString("tool-bar-done-button", comment: ""), style: .plain, target: self, action: #selector(toolBarDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: NSLocalizedString("tool-bar-cancel-button", comment: ""), style: .plain, target: self, action: #selector(toolBarCancelClicked))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true

        datePicker.snp.makeConstraints { make in
            make.top.equalTo(toolBar.snp.bottom)
            make.left.equalTo(datePickerContainerView)
            make.right.equalTo(datePickerContainerView)
            make.bottom.equalTo(datePickerContainerView)
        }
        toolBar.snp.makeConstraints { make in
            make.bottom.equalTo(datePicker.snp.top)
            make.right.equalTo(datePickerContainerView)
            make.left.equalTo(datePickerContainerView)
            make.top.equalTo(datePickerContainerView)
        }

        datePickerContainerView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(0)
        }
    }

    /**
     Filter out all tags and put it into @self.recommendedTags from the current event datasource.
    */
    func getTags() {
        for event in events {
            for tag in event.eventTags {
                if !recommendedTags.contains(tag) {
                    recommendedTags.append(tag)
                }
            }
        }
    }

    /**
     Filter the events displayed in the list by
     - date: the day to which to events should be filtered on.
    */
    func filterEvents(by date: Date) {
        filteredEvents = [Event]()
        for event in events {
            if Calendar.current.compare(date, to: event.startTime, toGranularity: .day) == .orderedSame {
                filteredEvents.append(event)
            }
        }
        tableView.reloadData()
    }

    /**
     Action handler for the pressing of the date picker. Should review a date picker at the bottom.
    */
    @objc func onDatePickerPressed(_ sender: UITapGestureRecognizer) {
        if let date = datePickerTag.getDate() {
            loadDatePicker(with: date)
        } else {
            loadDatePicker(with: Date())
        }
    }

    /**
     Loads a date picker at the bottom of the screen, with the inital date to be
     - currentTime: the initial date displayed on the date picker
    */
    func loadDatePicker(with currentTime:Date) {

        //date picker
        datePicker.setDate(currentTime, animated: false)

        UIView.animate(withDuration: animationDuration, animations: {
            if let constraint = (self.datePickerContainerView.constraints.filter {$0.firstAttribute == .height}.first) {
                constraint.constant = self.datePickerHeight
                self.view.layoutIfNeeded()
            }
        })
    }

    /**
     Handles the action of pressing done on the date picker tool bar
    */
    @objc func toolBarDoneClicked() {
        let date = datePicker.date
        datePickerTag.setDate(date)
        filterEvents(by: date)

        datePicker.resignFirstResponder()

        UIView.animate(withDuration: animationDuration, animations: {
            if let constraint = (self.datePickerContainerView.constraints.filter {$0.firstAttribute == .height}.first) {
                constraint.constant = 0
                self.view.layoutIfNeeded()
            }
        })
    }

    /**
     Handles the action of pressing cancel on the date picker tool bar
     */
    @objc func toolBarCancelClicked() {
        UIView.animate(withDuration: animationDuration, animations: {
            if let constraint = (self.datePickerContainerView.constraints.filter {$0.firstAttribute == .height}.first) {
                constraint.constant = 0
                self.view.layoutIfNeeded()
            }
        })
    }

    /*
     * Handler for the pressing action of tag buttons. Should segue to the correct tagview controller.
     * - sender: the sender of the action.
     */
    @objc func tagButtonPressed(_ sender: UIButton) {
        let tagViewController = TagViewController()
        if let tagButton = sender as? EventTagButton {
            let tag = tagButton.getTagName()
            if let rootViewEventsDiscoveryController = navigationController?.viewControllers.first as? EventsDiscoveryController {
                tagViewController.setup(with: rootViewEventsDiscoveryController.events, for: tag)
                navigationController?.pushViewController(tagViewController, animated: true)
            }
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredEvents.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventsDiscoveryTableViewCell.identifer, for: indexPath) as! EventsDiscoveryTableViewCell
        // Configure the cell...
        cell.configure(event: filteredEvents[indexPath.row])

        return cell
    }

    /*
     segue to the selected eventsDetailController
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsViewController = EventDetailViewController()
        detailsViewController.configure(with: filteredEvents[indexPath.row])
        navigationController?.pushViewController(detailsViewController, animated: true)
    }

}
