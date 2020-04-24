//
//  Film.swift
//  FilmNotes
//
//  Created by Alexander Giagoulas on 23.04.20.
//  Copyright © 2020 Alexander Giagoulas. All rights reserved.
//

import UIKit
import os.log

class Film: NSObject, NSCoding {
    
    // MARK: Properties
    // Define variables of Film object
    var name: String
    var photo: UIImage?
    var event: String
    var camera: String
    var iso: String
    var location: String
    var date: String
    var notes: String
    
    // MARK: Archiving Path
    // Set ArchivingPath for persistant storing of Film object
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("films")
    
    // MARK: Types
    // Create strukture to store key strings of Film object
    struct PropertyKey {
        static let name = "name";
        static let photo = "photo";
        static let event = "event";
        static let camera = "camera";
        static let iso = "iso";
        static let location = "location";
        static let date = "date";
        static let notes = "notes";
    }
    
    // MARK: Initialization
    // Initialize Film object - check if event is empty
    init?(name: String, photo: UIImage?, event: String, camera: String, iso: String, location: String, date: String, notes: String) {
        guard !event.isEmpty else {
            return nil
        }
        self.name = name
        self.photo = photo
        self.event = event
        self.camera = camera
        self.iso = iso
        self.location = location
        self.date = date
        self.notes = notes
    }
    
    // MARK: NSCoding
    // Perpare data to be initialized with NSCoder
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(event, forKey: PropertyKey.event)
        aCoder.encode(camera, forKey: PropertyKey.camera)
        aCoder.encode(iso, forKey: PropertyKey.iso)
        aCoder.encode(location, forKey: PropertyKey.location)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(notes, forKey: PropertyKey.notes)
    }
    
    // Initializer for Film object
    required convenience init?(coder aDecoder: NSCoder){
        // Event is required - if empty, initializer fails
        guard let event = aDecoder.decodeObject(forKey: PropertyKey.event) as? String else {
            os_log("Unable to decode the event for a Film object.", log: OSLog.default, type: .debug)
            return nil
        }
       
        // Conditional casts for optional variables
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String ?? ""
        let camera = aDecoder.decodeObject(forKey: PropertyKey.camera) as? String ?? ""
        let iso = aDecoder.decodeObject(forKey: PropertyKey.iso) as? String ?? ""
        let location = aDecoder.decodeObject(forKey: PropertyKey.location) as? String ?? ""
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String ?? ""
        let notes = aDecoder.decodeObject(forKey: PropertyKey.notes) as? String ?? ""
        
                      
        // call designated initializer
        self.init(name: name, photo: photo, event: event, camera: camera, iso: iso, location: location, date: date, notes: notes)
    }
    
}
