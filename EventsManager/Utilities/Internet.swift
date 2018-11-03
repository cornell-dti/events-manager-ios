//
//  Internet.swift
//  EventsManager
//
//  Created by Ethan Hu on 5/18/18.
//
//

import Foundation
import Alamofire
import SwiftyJSON

class Internet {
    private static let serverTokenAdress = "http://cuevents-app.herokuapp.com/app/generate_token/"

    static func getServerAuthToken(for googleToken: String, _ completion: @escaping (String?) -> Void) {
        Alamofire.request("\(serverTokenAdress)\(googleToken)").validate().responseJSON { response in
            switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    completion(json["token"].string)
                case .failure(let error):
                    print(error)
                    completion(nil)
            }
        }
    }

}
