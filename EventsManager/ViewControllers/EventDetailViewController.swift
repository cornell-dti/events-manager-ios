//
//  EventDetailViewController.swift
//  EventsManager
//
//  Created by Ethan Hu on 3/20/18.
//
//

import UIKit
import MapKit
import Kingfisher
import GoogleMaps
import GooglePlaces
import UserNotifications

class EventDetailViewController: UIViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    //Constants
    let gAnalyticsScreenName = "event detail pg"
    
    let buttonHeight: CGFloat = 40
    let standardEdgeSpacing: CGFloat = 20
    let imageViewHeight: CGFloat = 220
    let buttonStackInnerSpacing: CGFloat = 15
    let infoStackEdgeSpacing: CGFloat = 40
    let iconSideLength: CGFloat = 25
    let infoStackIconLabelSpacing: CGFloat = 20
    let infoTableSpacing: CGFloat = 12
    let eventDescriptionFontSize = CGFloat(integerLiteral: 16)
    let mapViewHeight: CGFloat = 220
    let mapViewDirectionsBarHeight: CGFloat = 35
    let mapViewDirectionsBarOpacity: Float = 0.7
    let tagScrollViewHeight = CGFloat(integerLiteral: 50)
    let tagHorizontalSpacing = CGFloat(integerLiteral: 8)
    let tagLabelFontSize = CGFloat(integerLiteral: 22)
    let eventImageGradientOpcaity: Float = 0.3
    let eventImageGradientStartPoint = CGPoint(x: 0.5, y: 0.0)
    let eventImageGradientEndPoint = CGPoint(x: 0.5, y: 1.0)
    let floatingButtonSideLength: CGFloat = 35
    let floatingButtonSideSpacing: CGFloat = 20
    let floatingButtonTopSpacing: CGFloat = 8
    let backButtonLeftInset: CGFloat = 10
    let backButtonTopBottomInset: CGFloat = 7
    let backButtonRightInset: CGFloat = 0
    let buttonImageWidth: CGFloat = 23
    let buttonImageHeight: CGFloat = 26
    let buttonImageTopSpacing: CGFloat = 7
    let buttonImageLeftSpacing: CGFloat = 15
    let modifiedEdgeSpacing: CGFloat = 70
    let modifiedbuttonImageLeftSpacing: CGFloat = 65
    let buttonFontSize: CGFloat = 16
    let shadowOpacity: Float = 0.6
    let shadowRadius: CGFloat = 5
    let shadowOffset = CGSize(width: 1.5, height: 1.5)
    let eventTitleFontSize: CGFloat = 18
    let defaultDescriptionLines = 3
    let defaultTitleLines = 2
    let directionsButtonRightSpacing: CGFloat = 10
    
    //datasource
    var event: Event?
    var placesClient = GMSPlacesClient.shared()
    var mapLocation: CLLocationCoordinate2D?
    
    //view elements
    var scrollView = UIScrollView()
    var contentView = UIView()
    let eventImageContainerView = UIView()
    var eventImage = UIImageView()
    let eventName = UILabel()
    let eventDescription = UILabel()
    let eventDescriptionShowMoreButton = UIButton()
    let shareButton = UIButton()
    let bookmarkedButton = UIButton()
    var eventTime = UILabel()
    var eventParticipantCount = UILabel()
    var eventOrganizer = UILabel()
    var eventLocation = UILabel()
    let eventMapViewWrapper = UIView()
    let eventMapDirectionsBar = UIView()
    let eventMapViewDirectionsButton = UIButton()
    var eventMapView = GMSMapView()
    var tagScrollView = UIScrollView()
    var tagStack = UIStackView()
    let backButton = UIButton()
    let loadingViewController = LoadingViewController()
    
    var statusBarHeight: CGFloat = 0
    var statusBarHidden: Bool = false
    weak var navigationControllerInteractivePopGestureRecognizerDelegate: UIGestureRecognizerDelegate?
    
    //Hide and show the nav bar on entering and exiting the details page.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.interactivePopGestureRecognizer?.delegate = navigationControllerInteractivePopGestureRecognizerDelegate ?? nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationControllerInteractivePopGestureRecognizerDelegate = navigationController?.interactivePopGestureRecognizer?.delegate
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        GoogleAnalytics.trackScreen(screenName: gAnalyticsScreenName)
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        setLayouts()
    }
    
    /* Sets all the layout elements in the details view */
    func setLayouts() {
        loadingViewController.configure(with: NSLocalizedString("loading", comment: ""))
        
        view.addSubview(scrollView)
        statusBarHeight = UIApplication.shared.statusBarFrame.height
        scrollView.backgroundColor = UIColor.white
        scrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(-statusBarHeight)
            make.right.equalTo(view)
            make.left.equalTo(view)
            make.bottom.equalTo(view)
        }
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(scrollView)
            make.width.equalTo(view.frame.width)
        }
        
        //Image gradient
        let eventImageGradient = CAGradientLayer()
        eventImageGradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: imageViewHeight)
        eventImageGradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        eventImageGradient.opacity = eventImageGradientOpcaity
        eventImageGradient.startPoint = eventImageGradientStartPoint
        eventImageGradient.endPoint = eventImageGradientEndPoint
        eventImage.layer.insertSublayer(eventImageGradient, at: 0)
        
        eventImage.clipsToBounds = true
        eventImage.contentMode = .scaleAspectFill
        
        //floating Buttons
        backButton.backgroundColor = UIColor.white
        var backButtonIcon = #imageLiteral(resourceName: "back")
        backButtonIcon = backButtonIcon.withRenderingMode(.alwaysTemplate)
        backButton.setImage(backButtonIcon, for: .normal)
        //backButton.imageEdgeInsets = UIEdgeInsets(top: backButtonTopBottomInset, left: backButtonLeftInset, bottom: backButtonTopBottomInset, right: backButtonRightInset)
        backButton.contentEdgeInsets = UIEdgeInsets(top: backButtonTopBottomInset, left: backButtonLeftInset, bottom: backButtonTopBottomInset, right: backButtonRightInset)
        backButton.tintColor = UIColor(named: "primaryPink")
        backButton.layer.cornerRadius = floatingButtonSideLength / 2
        backButton.layer.shadowColor = UIColor.gray.cgColor
        backButton.layer.shadowOpacity = shadowOpacity
        backButton.layer.shadowRadius = shadowRadius
        backButton.layer.shadowOffset = shadowOffset
        backButton.addTarget(self, action: #selector(self.backButtonPressed(_:)), for: .touchUpInside)
        
        //Name and description
        eventName.numberOfLines = defaultTitleLines
        eventName.font = UIFont.boldSystemFont(ofSize: eventTitleFontSize)
        eventName.textAlignment = .center
        
        eventDescriptionShowMoreButton.setTitleColor(UIColor(named: "primaryBlue"), for: .normal)
        eventDescriptionShowMoreButton.titleLabel?.font = UIFont.systemFont(ofSize: eventDescriptionFontSize)
        eventDescriptionShowMoreButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0.01, bottom: 0, right: 0.01)
        eventDescriptionShowMoreButton.addTarget(self, action: #selector(detailsMoreButtonPressed(_:)), for: .touchUpInside)
        eventDescription.numberOfLines = defaultDescriptionLines
        eventDescription.textColor = UIColor.gray
        eventDescription.textAlignment = .justified
        eventDescription.font = UIFont.systemFont(ofSize: eventDescriptionFontSize)
        
        //buttons
        
        
        bookmarkedButton.backgroundColor = UIColor.white
        bookmarkedButton.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
        //        bookmarkedButton.imageEdgeInsets = UIEdgeInsetsMake(0, bookmarkedButton.titleLabel.frame.size.width, 0, -bookmarkedButton.titleLabel.frame.size.width);
        bookmarkedButton.setTitle(NSLocalizedString("details-bookmark-button", comment: ""), for: .normal)
        bookmarkedButton.tintColor = UIColor(named: "primaryPink")
        bookmarkedButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        bookmarkedButton.layer.cornerRadius = buttonHeight / 2
        bookmarkedButton.layer.shadowColor = UIColor.gray.cgColor
        bookmarkedButton.layer.shadowOpacity = shadowOpacity
        bookmarkedButton.layer.shadowRadius = shadowRadius
        bookmarkedButton.layer.shadowOffset = shadowOffset
        bookmarkedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonFontSize)
        bookmarkedButton.addTarget(self, action: #selector(self.bookmarkedButtonPressed(_:)), for: .touchUpInside)
        
        bookmarkedButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
        }
        
        bookmarkedButton.imageView?.snp.makeConstraints { make in
            make.top.equalTo(bookmarkedButton).offset(buttonImageTopSpacing)
            make.left.equalTo(bookmarkedButton).offset(modifiedbuttonImageLeftSpacing)
            make.width.equalTo(buttonImageWidth)
            make.height.equalTo(buttonImageHeight)
        }
        
        shareButton.backgroundColor = UIColor.white
        shareButton.setImage(UIImage(named: "share1")?.withRenderingMode(.alwaysTemplate), for: .normal)
        shareButton.setTitle(NSLocalizedString("details-share-button", comment: ""), for: .normal)
        shareButton.tintColor = UIColor(named: "primaryPink")
        shareButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
        shareButton.layer.cornerRadius = buttonHeight / 2
        shareButton.layer.shadowColor = UIColor.gray.cgColor
        shareButton.layer.shadowOpacity = shadowOpacity
        shareButton.layer.shadowRadius = shadowRadius
        shareButton.layer.shadowOffset = shadowOffset
        shareButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: buttonFontSize)
        shareButton.addTarget(self, action: #selector(self.shareButtonPressed(_:)), for: .touchUpInside)
        shareButton.isHidden = true
        
        shareButton.snp.makeConstraints { make in
            make.height.equalTo(buttonHeight)
        }
        
        shareButton.imageView?.snp.makeConstraints { make in
            make.top.equalTo(shareButton).offset(buttonImageTopSpacing)
            make.left.equalTo(shareButton).offset(buttonImageLeftSpacing)
            make.width.equalTo(buttonImageWidth)
            make.height.equalTo(buttonImageHeight)
        }
        
        let buttonStack = UIStackView(arrangedSubviews: [bookmarkedButton])
        buttonStack.alignment = .center
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fill
        buttonStack.spacing = buttonStackInnerSpacing
        
        //table of info
        let calendarIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        calendarIcon.image = #imageLiteral(resourceName: "date")
        calendarIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let calendarStack = UIStackView(arrangedSubviews: [calendarIcon, eventTime])
        calendarStack.alignment = .center
        calendarStack.axis = .horizontal
        calendarStack.distribution = .fill
        calendarStack.spacing = infoStackIconLabelSpacing
        
        let participantIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        participantIcon.image = #imageLiteral(resourceName: "friends")
        participantIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let participantStack = UIStackView(arrangedSubviews: [participantIcon, eventParticipantCount])
        participantStack.alignment = .center
        participantStack.axis = .horizontal
        participantStack.distribution = .fill
        participantStack.spacing = infoStackIconLabelSpacing
        
        let organizerIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        organizerIcon.image = #imageLiteral(resourceName: "organization")
        organizerIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let organizerStack = UIStackView(arrangedSubviews: [organizerIcon, eventOrganizer])
        organizerStack.alignment = .center
        organizerStack.axis = .horizontal
        organizerStack.distribution = .fill
        organizerStack.spacing = infoStackIconLabelSpacing
        
        let organzationTapGesture = UITapGestureRecognizer(target: self, action: #selector(orgNamePressed(_:)))
        eventOrganizer.addGestureRecognizer(organzationTapGesture)
        eventOrganizer.isUserInteractionEnabled = true
        
        let locationIcon = UIImageView(frame: CGRect(x: 0, y: 0, width: iconSideLength, height: iconSideLength))
        locationIcon.image = #imageLiteral(resourceName: "lcation")
        locationIcon.snp.makeConstraints {make in
            make.height.equalTo(iconSideLength)
            make.width.equalTo(iconSideLength)
        }
        let locationStack = UIStackView(arrangedSubviews: [locationIcon, eventLocation])
        locationStack.alignment = .center
        locationStack.axis = .horizontal
        locationStack.distribution = .fill
        locationStack.spacing = infoStackIconLabelSpacing
        
        let infoTableStack = UIStackView(arrangedSubviews: [calendarStack, participantStack, organizerStack, locationStack])
        infoTableStack.alignment = .leading
        infoTableStack.axis = .vertical
        infoTableStack.distribution = .fill
        infoTableStack.spacing = infoTableSpacing
        
        let tagLabel = UILabel()
        tagLabel.text = NSLocalizedString("tag-button", comment: "")
        tagLabel.font = UIFont.boldSystemFont(ofSize: tagLabelFontSize)
        tagStack.insertArrangedSubview(tagLabel, at: 0)
        tagStack.alignment = .center
        tagStack.axis = .horizontal
        tagStack.distribution = .fill
        tagStack.spacing = tagHorizontalSpacing
        tagScrollView.addSubview(tagStack)
        
        contentView.addSubview(eventImageContainerView)
        eventImageContainerView.addSubview(eventImage)
        contentView.addSubview(eventName)
        contentView.addSubview(eventDescription)
        contentView.addSubview(eventDescriptionShowMoreButton)
        contentView.addSubview(buttonStack)
        contentView.addSubview(infoTableStack)
        contentView.addSubview(eventMapViewWrapper)
        contentView.addSubview(tagScrollView)
        view.addSubview(backButton)
        
        //Constraints for UI elements
        backButton.snp.makeConstraints { make in
            make.width.equalTo(floatingButtonSideLength)
            make.height.equalTo(floatingButtonSideLength)
            make.left.equalTo(view).offset(floatingButtonSideSpacing)
            make.top.equalTo(view).offset(floatingButtonTopSpacing + statusBarHeight)
        }
        
        eventImageContainerView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.height.equalTo(imageViewHeight).priority(.required)
        }
        
        eventImage.snp.makeConstraints {make in
            make.top.equalTo(view)
            make.left.equalTo(eventImageContainerView)
            make.right.equalTo(eventImageContainerView)
            make.bottom.equalTo(eventImageContainerView)
        }
        
        eventName.snp.makeConstraints { make in
            make.top.equalTo(eventImage.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        
        eventDescription.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventName.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
        }
        eventDescriptionShowMoreButton.snp.makeConstraints { make in
            make.top.equalTo(eventDescription.snp.bottom)
            make.right.equalTo(eventDescription.snp.right)
        }
        
        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(eventDescriptionShowMoreButton.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(modifiedEdgeSpacing)
            make.right.equalTo(contentView).offset(-modifiedEdgeSpacing)
        }
        
        infoTableStack.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(buttonStack.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(infoStackEdgeSpacing)
            make.right.equalTo(contentView).offset(-infoStackEdgeSpacing)
        }
        
        eventMapViewWrapper.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(infoTableStack.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
            make.height.equalTo(mapViewHeight)
        }
        eventMapViewWrapper.addSubview(eventMapView)
        eventMapView.snp.makeConstraints { make in
            make.edges.equalTo(eventMapViewWrapper)
        }
        eventMapDirectionsBar.backgroundColor = UIColor.white
        eventMapDirectionsBar.layer.opacity = mapViewDirectionsBarOpacity
        eventMapViewWrapper.addSubview(eventMapDirectionsBar)
        eventMapDirectionsBar.snp.makeConstraints { make in
            make.height.equalTo(mapViewDirectionsBarHeight)
            make.bottom.equalTo(eventMapViewWrapper)
            make.left.equalTo(eventMapViewWrapper)
            make.right.equalTo(eventMapViewWrapper)
        }
        eventMapDirectionsBar.addSubview(eventMapViewDirectionsButton)
        eventMapViewDirectionsButton.setTitleColor(view.tintColor, for: .normal)
        eventMapViewDirectionsButton.setTitle(NSLocalizedString("event-details-directions-button", comment: ""), for: .normal)
        eventMapViewDirectionsButton.snp.makeConstraints { make in
            make.right.equalTo(eventMapDirectionsBar).offset(-directionsButtonRightSpacing)
            make.centerY.equalTo(eventMapDirectionsBar)
        }
        eventMapViewDirectionsButton.addTarget(self, action: #selector(self.directionsButtonPressed(_:)), for: .touchUpInside)
        
        tagScrollView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(eventMapViewWrapper.snp.bottom).offset(standardEdgeSpacing)
            make.left.equalTo(contentView).offset(standardEdgeSpacing)
            make.right.equalTo(contentView).offset(-standardEdgeSpacing)
            make.height.equalTo(tagScrollViewHeight)
            make.bottom.equalTo(contentView)
        }
        
        tagStack.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(tagScrollView)
        }
        
    }
    
    /* Allow client to configure the event detail page by passing in an event object */
    func configure(with eventPk: Int) {
        let event = AppData.getEvent(pk: eventPk, startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController), endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController), noConnection: GenericLoadingHelper.noConnection(from: self), updateData: true)
        self.event = event
        let _ = UserData.addClickForEvent(event: event)
        eventImage.kf.setImage(with: event.eventImage)
        
        eventName.text = event.eventName
        eventDescriptionShowMoreButton.setTitle(NSLocalizedString("description-more-button", comment: ""), for: .normal)
        eventDescription.text = event.eventDescription
        eventTime.text = "\(NSLocalizedString("from", comment: "")) \(DateFormatHelper.hourMinute(from: event.startTime)) \(NSLocalizedString("to", comment: "")) \(DateFormatHelper.hourMinute(from: event.endTime))"
        eventOrganizer.text = AppData.getOrganization(
            by: event.eventOrganizer,
            startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController),
            endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController),
            noConnection: GenericLoadingHelper.noConnection(from: self),
            updateData: false).name
        eventLocation.text = AppData.getLocationPlaceIdTuple(by: event.eventLocation,
                                                             startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController),
                                                             endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController),
                                                             noConnection: GenericLoadingHelper.noConnection(from: self),
                                                             updateData: false).0
        eventParticipantCount.text = "\(event.eventParticipantCount) \(NSLocalizedString("participant-going", comment: ""))"
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.all.rawValue))!
        placesClient.fetchPlace(fromPlaceID: AppData.getLocationPlaceIdTuple(by: event.eventLocation,
                                                                             startLoading: GenericLoadingHelper.startLoadding(from: self, loadingVC: loadingViewController),
                                                                             endLoading: GenericLoadingHelper.endLoading(loadingVC: loadingViewController),
                                                                             noConnection: GenericLoadingHelper.noConnection(from: self),
                                                                             updateData: false).1, placeFields: fields, sessionToken: nil, callback: {
                                                                                (result: GMSPlace?, error: Error?) in
                                                                                if let error = error {
                                                                                    print("An error occurred: \(error.localizedDescription) when fetching google places")
                                                                                    return
                                                                                }
                                                                                
                                                                                if let result = result {
                                                                                    self.mapLocation = result.coordinate
                                                                                    self.eventMapView.moveCamera(GMSCameraUpdate.fit(result.viewport!))
                                                                                    let mapMarker = GMSMarker(position: result.coordinate)
                                                                                    mapMarker.map = self.eventMapView
                                                                                    self.eventMapView.selectedMarker = mapMarker
                                                                                }
        })
        
        
        for tagPk in event.eventTags {
            let tagButton = EventTagButton()
            tagButton.setTag(with: tagPk)
            tagButton.addTarget(self, action: #selector(self.tagButtonPressed(_:)), for: .touchUpInside)
            tagStack.addArrangedSubview(tagButton)
        }
        
    }
    
    /**
     Handler for pressing the directions button in the map. Should open google maps (if installed) or apple maps and shows the desired location.
     - sender: the sender of the action
     */
    @objc func directionsButtonPressed(_ sender: UIButton) {
        if let mapLocation = mapLocation {
            let url: URL
            if UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) {
                url = URL(string: "comgooglemaps://center=?q=\(mapLocation.latitude),\(mapLocation.longitude)")!
            } else {
                url = URL(string: "http://maps.apple.com/?q=\(mapLocation.latitude),\(mapLocation.longitude)")!
            }
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    /**
     Handler for the pressing action of the organization name. Should segue to the correct organization page.
     - sender: the sender of the action
     */
    @objc func orgNamePressed(_ sender: UITapGestureRecognizer) {
        let orgController = OrganizationViewController()
        orgController.configure(organizationPk: event?.eventOrganizer ?? 0)
        navigationController?.pushViewController(orgController, animated: true)
    }
    
    /**
     Handler for the pressing action of tag buttons. Should segue to the correct tagview controller.
     - sender: the sender of the action.
     */
    @objc func tagButtonPressed(_ sender: UIButton) {
        let tagViewController = TagViewController()
        if let tagButton = sender as? EventTagButton {
            let tag = tagButton.getTagPk()
            if let rootViewEventsDiscoveryController = navigationController?.viewControllers.first as? EventsDiscoveryController {
                //Ganalytics
                GoogleAnalytics.trackEvent(category: "button click", action: "tag", label: "event detail pg")
                tagViewController.setup(with: rootViewEventsDiscoveryController.events, for: tag)
                navigationController?.pushViewController(tagViewController, animated: true)
            }
        }
    }
    
    /**
     Handler for the pressing action of the back button floating at the top left of the page. Should navigate back to the previous page.
     */
    @objc func backButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    /**
     Handler for the pressing action of the bookmark button. Should change the color of the button and add it to the user's bookmarked list.
     */
    @objc func bookmarkedButtonPressed(_ sender: UIButton) {
        let center = UNUserNotificationCenter.current()
        if var user = UserData.getLoggedInUser() {
            if bookmarkedButton.backgroundColor == UIColor.white {
                bookmarkedButton.backgroundColor = UIColor(named: "primaryPink")
                bookmarkedButton.setTitle(NSLocalizedString("bookmarked-button-clicked", comment: ""), for: .normal)
                bookmarkedButton.setTitleColor(UIColor.white, for: .normal)
                bookmarkedButton.tintColor = UIColor.white
                bookmarkedButton.setImage(UIImage(named: "filledbookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
                if let event = event {
                    user.bookmarkedEvents.append(event.id)
                    if user.reminderEnabled {
                        let content = UNMutableNotificationContent()
                        content.title = NSLocalizedString("notification-title", comment: "")
                        content.body = "\(NSLocalizedString("notificaition-body-1", comment: "")) \(event.eventName)\(NSLocalizedString("notification-body-2", comment: ""))"
                        content.sound = .default
                        let minutesBeforeEvent = ReminderTimeOptions.getValue(from: ReminderTimeOptions.getCase(by: user.reminderTime))
                        let minuteComp = DateComponents(minute: -minutesBeforeEvent)
                        let remindDate = Calendar.current.date(byAdding: minuteComp, to: event.startTime)
                        if let remindDate = remindDate {
                            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: remindDate)
                            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                                        repeats: false)
                            let notificationIdentifier = "\(NSLocalizedString("notification-identifier", comment: ""))\(event.id)"
                            let request = UNNotificationRequest(identifier: notificationIdentifier,
                                                                content: content, trigger: trigger)
                            center.add(request, withCompletionHandler: { (error) in
                            })
                        }
                        
                    }
                }
                
                //Ganalytics
                GoogleAnalytics.trackEvent(category: "button click", action: "bookmark", label: "event detail page")
            }
            else {
                bookmarkedButton.backgroundColor = UIColor.white
                bookmarkedButton.setTitleColor(UIColor(named: "primaryPink"), for: .normal)
                bookmarkedButton.setTitle(NSLocalizedString("details-bookmark-button", comment: ""), for: .normal)
                bookmarkedButton.setImage(UIImage(named: "bookmark")?.withRenderingMode(.alwaysTemplate), for: .normal)
                bookmarkedButton.tintColor = UIColor(named: "primaryPink")
                if let index = user.bookmarkedEvents.index(of: (event?.id)!) {
                    user.bookmarkedEvents.remove(at: index)
                }
                if let event = event {
                    let notificationIdentifier = "\(NSLocalizedString("notification-identifier", comment: ""))\(event.id)"
                    UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier])
                }
                //Ganalytics
                GoogleAnalytics.trackEvent(category: "button click", action: "unbookmark", label: "event detail page")
            }
        }
    }
    
    @objc func shareButtonPressed(_ sender: UIButton) {
        let eventText = event?.eventDescription ?? ""
        let textToShare = [eventText]
        let activityVC = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = sender
        self.present(activityVC, animated: true, completion: nil)
        //Ganalytics
        GoogleAnalytics.trackEvent(category: "button click", action: "share", label: "event detail page")
    }
    
    /**
     Handler for the pressing action of the "more" button under event description. Should extend event description or shrink.
     */
    @objc func detailsMoreButtonPressed(_ sender: UIButton) {
        eventDescription.numberOfLines = eventDescription.numberOfLines == 0 ? defaultDescriptionLines : 0
        eventDescriptionShowMoreButton.setTitle(eventDescription.numberOfLines == 0 ? NSLocalizedString("description-less-button", comment: "") : NSLocalizedString("description-more-button", comment: ""), for: .normal)
    }
    
    //scrollview delegate method. Will be triggered when scrollview scrolled.
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if statusBarHidden != shouldHideStatusBar {
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            statusBarHidden = shouldHideStatusBar
        }
    }
    
    //hide status bar when the image is scrolled over
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar: Bool {
        let height = scrollView.contentOffset.y + statusBarHeight * 2
        return height >= imageViewHeight
    }
    
    //Delegate method of UIGestureRecognizer. Used to enable swipe left to return
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
