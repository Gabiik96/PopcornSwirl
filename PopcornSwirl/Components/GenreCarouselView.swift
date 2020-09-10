//
//  GenreCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 10/09/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct GenreCarouselView: View {
    
    @ObservedObject var state: GenreListState
    
    var body: some View {
        VStack {
            if state.genres != nil {
                List {
                    ForEach(self.state.genres!) { genre in
                        GenreTitleSectionView(genre: genre)
                    }
                }
            } else {
                LoadingView(isLoading: state.isLoading, error: state.error) {
                    self.state.loadGenres()
                }
            }
        }
    }
}

struct GenreTitleSectionView: View {
    
    @ObservedObject private var moviesByGenreListState = MoviesByGenreListState()
    
    let genre: Genres
    
    var body: some View {
        VStack {
            NavigationLink(destination: GenreAllMoviesView()) {
                Text(self.genre.name)
                    .font(Font.custom("FjallaOne-Regular", size: 25))
                    .foregroundColor(Color.steam_white)
            }
            GenreMoviesView(state: moviesByGenreListState, genreId: genre.id)
        }.onAppear() {
            self.moviesByGenreListState.searchMoviesByGenre(genreId: self.genre.id)
        }
    }
}

struct GenreMoviesView: View {
    
    @ObservedObject var state: MoviesByGenreListState
    
    let genreId: Int
    
    var body: some View {
        Group {
            if state.movies != nil {
                MoviePosterCarouselView(movies: state.movies!)
            } else {
                LoadingView(isLoading: state.isLoading, error: state.error) {
                    self.state.searchMoviesByGenre(genreId: self.genreId)
                }
            }
        }
    }
}


struct GenreAllMoviesView: View {
    
    
    
    var body: some View {
        Text("ss")
    }
}
