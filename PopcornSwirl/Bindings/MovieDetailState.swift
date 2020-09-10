//
//  MovieDetailState.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

class MovieDetailState: ObservableObject {
    
    private let movieService: NetworkingService
    @Published var movie: Movie?
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: NetworkingService = NetworkingApi.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) {
        self.movie = nil
        self.isLoading = false
        self.movieService.fetchMovie(id: id) {[weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movie = movie
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
