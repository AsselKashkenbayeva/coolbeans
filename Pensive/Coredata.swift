//
//  Coredata.swift
//  Pensive
//
//  Created by Assel Kashkenbayeva on 30/12/2016.
//  Copyright © 2016 Assel Kashkenbayeva. All rights reserved.
//
/*
import UIKit
import Foundation
import CoreData

func insert(latitude: Double, longitude: Double) {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let managedObjectContext = appDelegate.managedObjectContext
    
    let entity =  NSEntityDescription.entity(forEntityName: "StoredPlace", in:managedObjectContext)
    let newItem = StoredPlace(entity: entity!, insertInto: managedObjectContext)
    
    newItem.newPlaceLatitude = latitude
    newItem.newPlaceLongitude = longitude
    
    do {
        try managedObjectContext.save()
    } catch {
        print(error)
    }
}
}
 */
