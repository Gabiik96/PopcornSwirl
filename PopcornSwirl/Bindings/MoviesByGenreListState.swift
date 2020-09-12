//
//  MoviesByGenreListState.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 10/09/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import Foundation
import SwiftUI

class MoviesByGenreListState: ObservableObject {
    
    @Published var movies: [Movie]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    
    private let genreService: NetworkingService
    
    init(genreService: NetworkingService = NetworkingApi.shared) {
        self.genreService = genreService
    }
    
    
    func searchMoviesByGenre(genreId: Int) {
        self.movies = nil
        self.isLoading = true
        self.genreService.getMovieByGenre(withGenre: genreId) { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.movies = response.results
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}

//private extension Array where Element == MoviePage {
//    var movies: [Movie] { flatMap { $0.results } }
//}
