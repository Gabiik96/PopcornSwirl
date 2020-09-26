//
//  DiscoverSceneView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct DiscoverSceneView: View {
    
    @EnvironmentObject var genreListState: GenreListState
    
    @ObservedObject var movieSearchState = MovieSearchState()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBarView(text: self.$movieSearchState.query, placeholder: "Search any movie")
                Spacer()
                if movieSearchState.query.count > 0 {
                    if movieSearchState.movies != nil {
                        MoviePosterView(movies: movieSearchState.movies!)
                    }
                } else {
                    GenreCarouselView()
                }
            }.navigationBarTitle("Discover")
        }.onAppear() {
            self.genreListState.loadGenres()
            self.movieSearchState.startObserve()
        }
    }
}
