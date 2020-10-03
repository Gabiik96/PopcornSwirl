//
//  GenreCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct GenreCarouselView: View {
    
    @EnvironmentObject var state: GenreListState
    
    var body: some View {
        VStack {
            ScrollView() {
                if state.genres != nil {
                    ForEach(self.state.genres!) { genre in
                        MovieDropDownView(genre: genre)
//                            .frame(height : 200)
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



struct MovieGridView: View {
    
    @State var showingDetail = false
    @State var movies: [Movie] = [Movie]()
    
    let layout = [GridItem(.adaptive(minimum: 150))]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(movies) { movie in
                    Button(action: {
                        self.showingDetail.toggle()
                    }) {
                        MoviePosterCard(movie: movie)
                    }.sheet(isPresented: $showingDetail, content: {
                        MovieDetailView(movieId: movie.id)
                    })
                }
            }.padding()
        }
    }
}
