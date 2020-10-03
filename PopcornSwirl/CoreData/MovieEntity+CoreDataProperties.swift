//
//  MovieEntity+CoreDataProperties.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//
//

import Foundation
import CoreData


extension MovieEntity: Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var note: String
    @NSManaged public var wishlisted: Bool
    @NSManaged public var watched: Bool

}
