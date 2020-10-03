//
//  GenreListState.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import Foundation

class GenreListState: ObservableObject {
    
    @Published var genres: [Genres]?
    @Published var isLoading: Bool = false
    @Published var error: NSError?
    
    private let genreService: NetworkingService
    
    init(genreService: NetworkingService = NetworkingApi.shared) {
        self.genreService = genreService
    }
    
    func loadGenres() {
        self.genres = nil
        self.isLoading = true
        self.genreService.getGenreList { [weak self] (result) in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let response):
                self.genres = response.genres
            case .failure(let error):
                self.error = error as NSError
            }
        }
    }
}
