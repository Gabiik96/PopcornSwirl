//
//  MovieDropDownView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MovieDropDownView: View {
    
    @ObservedObject private var moviesByGenreListState = MoviesByGenreListState()
    
    @State var expand = false
    
    let genre: Genres
    var title: String?
    
    var body: some View {
        VStack() {
            HStack {
                if self.title != nil {
                    Text(self.title!)
                        .fontWeight(.bold)
                } else {
                    Text(self.genre.name)
                        .font(Font.custom("FjallaOne-Regular", size: 25))
                        .foregroundColor(Color.popcorn_white)
                        .padding(.leading)
                }
                Spacer()
                Image(systemName: expand ? "chevron.up" : "chevron.down")
                    .padding(.trailing)
            }.onTapGesture {
                self.expand.toggle()
            }
            
            if expand {
                VStack {
                    if moviesByGenreListState.movies != nil {
                        MoviePosterCarouselView(movies: moviesByGenreListState.movies!)
                            .frame(height: 200)
                        
                    } else {
                        LoadingView(isLoading: moviesByGenreListState.isLoading, error: moviesByGenreListState.error) {
                            self.moviesByGenreListState.searchMoviesByGenre(genreId: self.genre.id)
                        }
                    }
                }
                .animation(.easeInOut)
                .onAppear() {
                    self.moviesByGenreListState.searchMoviesByGenre(genreId: self.genre.id)
                }
            }
        }
    }
    
}