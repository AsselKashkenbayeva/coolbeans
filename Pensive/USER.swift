//
//  USER.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 22/03/2017.
//  Copyright © 2017 Assel Kashkenbayeva. All rights reserved.
//

import UIKit

class USER: NSObject {

    var DOB: String?
    var Email: String?
    var Gender: String?
    var Password: String?
    var Username: String?
    var ProfilePicURL: String?
    var StoredPlacesOfUser = [String:AnyObject]()
    var StoredFoldersOfUser = [String:AnyObject]()
}
