//
//  CoreDataController.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 19/09/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI
import CoreData

class CoreDataController {
    
    
    //MARK:- Add data
    
    
    func saveMovie(moc: NSManagedObjectContext, movieID: Int, note: String? = nil, wishlisted: Bool? = nil, watched: Bool? = nil) {
        let movie = MovieEntity(context: moc)
                    
        movie.movieID = Int32(movieID)
        if note != nil { movie.note = note! }
        if wishlisted != nil { movie.wishlisted = wishlisted! }
        if watched != nil { movie.watched = watched! }
        
        saveMoc(moc: moc)
    }
    
    //MARK: - Update data
    
    func updateMovie (moc: NSManagedObjectContext, movie: MovieEntity, note: String? = nil, wishlisted: Bool? = nil, watched: Bool? = nil) {
        
        if note != nil { movie.note = note! }
        if wishlisted != nil { movie.wishlisted = wishlisted! }
        if watched != nil { movie.watched = watched! }
        
        saveMoc(moc: moc)
    }
    

    
    func saveMoc(moc: NSManagedObjectContext) {
        do {
            try moc.save()
        } catch {
            print("Failed to save MOC. \(error)")
            moc.rollback()
        }
    }

}

