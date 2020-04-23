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
    var name: String
    var photo: UIImage?
    
    // MARK: Archiving Path
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("films")
    
    // MARK: Types
    struct PropertyKey {
        static let name = "name";
        static let photo = "photo";
    }
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?) {
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.photo = photo
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
    }
    
    required convenience init?(coder aDecoder: NSCoder){
           // The name is required. If we cannot decode a name string, the initializer should fail.
           guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
               os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
               return nil
           }
           
           // Because photo is an optional property of Meal, just use conditional cast.
           let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
                      
           // Must call designated initializer.
           self.init(name: name, photo: photo)
       }
    
}
