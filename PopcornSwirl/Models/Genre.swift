//
//  Genre.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 10/09/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import Foundation

struct GenreResult: Codable {
    let genres: [Genres]
}


struct Genres: Codable, Identifiable {
    let id: Int
    let name: String
}
