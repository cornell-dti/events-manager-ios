//
//  GenericLoadingHelper.swift
//  EventsManager
//
//  Created by Ethan Hu on 4/28/19.
//  Copyright © 2019 Jagger Brulato. All rights reserved.
//

import Foundation
import UIKit

class GenericLoadingHelper {
    static func startLoadding(from targetViewController: UIViewController, loadingVC: LoadingViewController) -> () -> Void {
        return {
            targetViewController.present(loadingVC, animated: true, completion: nil)
        }
    }
    
    static func endLoading(loadingVC: LoadingViewController) -> () -> Void {
        return {
            loadingVC.dismiss(animated: true, completion:  nil)
            
        }
    }
    
    static func noConnection(from targetViewController: UIViewController) -> () -> Void {
        return {
            Alert.informative(with: "No Internet Connection", with: "Alert", from: targetViewController)
        }
    }
}
