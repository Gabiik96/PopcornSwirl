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
            ScrollView {
                if state.genres != nil {
                    ForEach(self.state.genres!) { genre in
                        GenreTitleSectionView(genre: genre)
                            .frame(height : 200)
                    }
                    
                } else {
                    LoadingView(isLoading: state.isLoading, error: state.error) {
                        self.state.loadGenres()
                    }
                }
            }
        }
    }
}

struct GenreTitleSectionView: View {
    
    @ObservedObject private var moviesByGenreListState = MoviesByGenreListState()
    
    let genre: Genres
    
    var body: some View {
        VStack() {
            NavigationLink(destination: MovieGridView(movies: moviesByGenreListState.movies ?? [Movie]())) {
                HStack {
                    Text(self.genre.name)
                        .font(Font.custom("FjallaOne-Regular", size: 25))
                        .foregroundColor(Color.steam_white)
                        .padding(.leading)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .padding(.trailing)
                }
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
        VStack {
            if state.movies != nil {
                MoviePosterCarouselView(movies: state.movies!)
            } else {
                LoadingView(isLoading: state.isLoading, error: state.error) {
                    self.state.searchMoviesByGenre(genreId: self.genreId)
                }
            }
        }.onAppear() {
            self.state.searchMoviesByGenre(genreId: self.genreId)
        }
    }
}

struct MovieGridView: View {
    
    var movies: [Movie] = [Movie]()
    
    let layout = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(movies) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                        MoviePosterCard(movie: movie)
                    }.buttonStyle(PlainButtonStyle())
                }
            }.padding()
        }
    }
}
