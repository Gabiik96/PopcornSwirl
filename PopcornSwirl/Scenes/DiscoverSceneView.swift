//
//  DiscoverSceneView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct DiscoverSceneView: View {
    
    @ObservedObject var genreListState = GenreListState()
    @ObservedObject var movieSearchState = MovieSearchState()
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView(text: self.$movieSearchState.query, placeholder: "Search any movie or person")
                GenreCarouselView(state: self.genreListState)
                
            }.navigationBarTitle("Discover")
        }.onAppear() {
            self.genreListState.loadGenres()
        }
    }
}
