//
//  MoviePosterCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviePosterCarouselView: View {

    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(self.movies) { movie in
                        NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                            MoviePosterCard(movie: movie)
                        }.buttonStyle(PlainButtonStyle())
                            .padding(.leading, movie.id == self.movies.first!.id ? 15 : 0)
                            .padding(.trailing, movie.id == self.movies.last!.id ? 15 : 0)
                    }
                }
            }
        }
        
    }
}
