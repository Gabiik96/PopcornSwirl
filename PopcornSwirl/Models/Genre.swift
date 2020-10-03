//
//  Genre.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import Foundation

struct GenreResult: Codable {
    let genres: [Genres]
}


struct Genres: Codable, Identifiable {
    let id: Int
    let name: String
}
