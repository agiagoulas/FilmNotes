//
//  Film.swift
//  FilmNotes
//
//  Created by Alexander Giagoulas on 23.04.20.
//  Copyright © 2020 Alexander Giagoulas. All rights reserved.
//

import UIKit

class Film {
    
    // MARK: Properties
    var name: String
    var photo: UIImage?
    
    // MARK: Initialization
    init?(name: String, photo: UIImage?) {
        
        guard !name.isEmpty else {
            return nil
        }
        
        self.name = name
        self.photo = photo
        
    }
    
}
