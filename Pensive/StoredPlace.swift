//
//  placeCoreDataStruct.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 26/12/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//


import UIKit
import Foundation
import CoreData

class StoredPlace: NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var address: String?
    @NSManaged var placeID: String?
    @NSManaged public var latitude: Double
    @NSManaged public var lonitude: Double
}
