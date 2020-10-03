//
//  GenreCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviesByGenreListView: View {
    
    @EnvironmentObject var state: GenreListState
    
    var body: some View {
        VStack {
            ScrollView() {
                if state.genres != nil {
                    ForEach(self.state.genres!) { genre in
                        MovieDropDownView(genre: genre)
                    }.padding()
                    
                } else {
                    LoadingView(isLoading: state.isLoading, error: state.error) {
                        self.state.loadGenres()
                    }
                }
            }
        }
    }
}

