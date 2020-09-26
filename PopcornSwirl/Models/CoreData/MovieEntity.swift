//
//  MovieEntity.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 19/09/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import Foundation
import CoreData

class MovieEntity: NSManagedObject, Identifiable {
    
    override public func willChangeValue(forKey key: String) {
        super.willChangeValue(forKey: key)
        self.objectWillChange.send()
    }
    
    // Properties
    @NSManaged var movieID: Int64
    @NSManaged var note: String?
    @NSManaged var watched: Bool
    @NSManaged var wishlisted: Bool
}

extension MovieEntity {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }
}
