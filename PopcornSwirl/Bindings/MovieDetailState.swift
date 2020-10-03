//
//  MovieDetailState.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import Foundation

class MovieDetailState: ObservableObject {
    
    private let movieService: NetworkingService
    @Published var movie: Movie?
    @Published var movies = [Movie]()
    @Published var isLoading = false
    @Published var error: NSError?
    
    init(movieService: NetworkingService = NetworkingApi.shared) {
        self.movieService = movieService
    }
    
    func loadMovie(id: Int) {
        self.movie = nil
        self.isLoading = true
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
    
    func appendMovie(id: Int) {
        self.isLoading = false
        self.movieService.fetchMovie(id: id) {[weak self] (result) in
            guard let self = self else { return }
            
            self.isLoading = false
            switch result {
            case .success(let movie):
                self.movies.append(movie)
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
