# <img src="https://raw.githubusercontent.com/cornell-dti/events-manager-android/master/cue_text_red.png" width="80" height="35"> (Cornell University Events) v1.0

#### Contents
  - [About](#about)
  - [Getting Started](#getting-started)
  - [Dependencies & Libraries](#dependencies--libraries)
  - [External Documentation](#external-documentation)
  - [Screenshots](#screenshots)
  - [Contributors](#contributors)

## About
An **iOS** app for Cornell students to find events. It allows students to view all campus events in one place, schedule events, and follow organizations and tags they like. 

The **Android** branch can be found [here](https://github.com/cornell-dti/events-manager-android). 
The **Backend** can be found [here](https://github.com/cornell-dti/events-backend). 
The **Website** can be found [here](https://github.com/cornell-dti/events-site)

## Getting Started
You will need **Xcode 10.0** to run the latest version of this app, which uses Swift 4.2 compiled for iOS 12. Xcode can be downloaded from the Mac App Store. Make sure you are not running a beta version of macOS, as Apple will prevent you from publishing to the App Store if you do.
 
_Last updated **06/09/2019**_.

### Code Review
After pushing any changes to the codebase, let's get your code reviewed. Some general guidelines:
- Before you start changing any code, make sure you're synced with the master branch.
- Create a new branch off master, and give it an informative name.
- Commit your changes to this feature branch. Commit often so that you don't accidentally lose your progress!
- Open a pull request (PR), give it a meaningful title and describe the changes that you made. Take note of any future improvements or any existing bugs with the changes you made. Give some steps as to how to test the changes you've made. 
- Notify others of the PR you created, and ask the relevant people to review it for you. They may leave comments and request changes, in which case you should make changes and push new commits to the same branch; the PR will update automatically!
- Finally, when the change is approved by the reviewer, you can go ahead and merge the branch into the master branch.

Some things to watch out for when reviewing someone else's code:
- Is the code documented? Are there comments that give details about what the code is doing?
- Have commented-out lines of code been deleted?
- Are your variable names clear, short, and meaningful?
- Are your functions short and have a single purpose?
- Are there redundancies in your code?

## Dependencies & Libraries
 * [CocoaPods](https://cocoapods.org) - CocoaPods is a dependency manager for Swift and Objective-C Cocoa projects.
 * [SnapKit](http://snapkit.io) - A library to create autolayout for iOS using simple syntax.
 * [KingFisher](https://github.com/onevcat/Kingfisher) - A lightweight, pure-Swift library for downloading and caching images from the web.
 * [Google Maps SDK for iOS](https://developers.google.com/maps/documentation/ios-sdk/intro) - A Google Library for including Google Maps and some of its functions in iOS.
 * [Google Sign-In for iOS](https://developers.google.com/identity/sign-in/ios/start-integrating) - A Google Library that enables Google Sign-ins from iOS. 

## External Documentation

* [Backend API Documentation](https://cuevents.docs.apiary.io/) - this is an external Apiary documenting the endpoints for our application.

## Screenshots

_Screenshots showing major parts of app_

<img src="https://raw.githubusercontent.com/cornell-dti/events-manager-ios/master/EventsManager/Resources/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20-%202018-09-22%20at%2017.19.20.png" width="250px" style="margin: 10px; border: 1px rgba(0,0,0,0.4) solid;">  <img src="https://github.com/cornell-dti/events-manager-ios/blob/master/EventsManager/Resources/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20-%202018-09-22%20at%2017.19.47.png" width="250px" style="margin: 10px; border: 1px rgba(0,0,0,0.4) solid;">  <img src="https://github.com/cornell-dti/events-manager-ios/blob/master/EventsManager/Resources/Simulator%20Screen%20Shot%20-%20iPhone%20XS%20-%202018-09-22%20at%2017.19.52.png" width="250px" style="margin: 10px; border: 1px rgba(0,0,0,0.4) solid;">

## Contributors

**2018**
 * **Ashrita Raman** -  **Front-end Developer** 
 * **[Qichen Hu](https://github.com/wsjnohyeah)** - **Front-end Developer**

**2017**
 * **[Amanda Ong](https://github.com/amandaong)** - **Front-end Developers**
 * **[David Chu](https://github.com/cornell-dti/events-site/commits?author=davidchuyayah)** - **Front-end Developer**
 * **[Jagger Brulato](https://github.com/JBoss925)** - **Front-end Developer**
 * **[Qichen Hu](https://github.com/wsjnohyeah)** - **Front-end Developer**

We are a team within **Cornell Design & Tech Initiative**. For more information, see our website [here](https://cornelldti.org/).
<img src="https://raw.githubusercontent.com/cornell-dti/design/master/Branding/Wordmark/Dark%20Text/Transparent/Wordmark-Dark%20Text-Transparent%403x.png">

