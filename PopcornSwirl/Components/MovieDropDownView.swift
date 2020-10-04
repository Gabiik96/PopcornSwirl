//
//  MovieDropDownView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MovieDropDownView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], animation: .default) private var fetchedMovies: FetchedResults<MovieEntity>
    
    @ObservedObject private var moviesByGenreListState = MoviesByGenreListState()
    
    @State var expand = false
    
    let genre: Genres
    var title: String?
    
    var body: some View {
        VStack {
            
            HStack {
                if self.title != nil {
                    Text(self.title!)
                        .fontWeight(.bold)
                } else {
                    Text(self.genre.name)
                        .font(Font.FjallaOne(size: 25))
                        .foregroundColor(Color.popcorn_gold)
                }
                Spacer()
                Image(systemName: expand ? "chevron.up" : "chevron.down")
            }.onTapGesture {
                self.expand.toggle()
            }
            
            // Attached Views which will be showns when row will be tapped to be expanded
            if expand {
                VStack {
                    if moviesByGenreListState.movies != nil {
                        MoviePosterCarouselDetailView(movies: moviesByGenreListState.movies!)
                            .frame(height: 200)
                            .edgesIgnoringSafeArea(.all)
                        
                    } else {
                        LoadingView(isLoading: moviesByGenreListState.isLoading, error: moviesByGenreListState.error) {
                            self.moviesByGenreListState.searchMoviesByGenre(genreId: self.genre.id)
                        }
                    }
                }
                .animation(.easeInOut)
            }
            
        }.onAppear() {
            self.moviesByGenreListState.searchMoviesByGenre(genreId: self.genre.id)
        }
    }
}
