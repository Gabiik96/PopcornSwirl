//
//  GenreCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 10/09/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct GenreCarouselView: View {
    
    @EnvironmentObject var state: GenreListState
    
    var body: some View {
        VStack {
            ScrollView {
                if state.genres != nil {
                    ForEach(self.state.genres!) { genre in
                        GenreSectionView(genre: genre)
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

struct GenreSectionView: View {
    
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
            VStack {
                if moviesByGenreListState.movies != nil {
                    MoviePosterCarouselView(movies: moviesByGenreListState.movies!)
                } else {
                    LoadingView(isLoading: moviesByGenreListState.isLoading, error: moviesByGenreListState.error) {
                        self.moviesByGenreListState.searchMoviesByGenre(genreId: self.genre.id)
                    }
                }
            }.onAppear() {
                self.moviesByGenreListState.searchMoviesByGenre(genreId: self.genre.id)
            }
        }
    }
}

struct MovieGridView: View {
    
    @State var movies: [Movie] = [Movie]()
    
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
