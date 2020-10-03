//
//  MoviePosterCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviePosterCarouselView: View {

    @State var showingDetail = false
    
    let movies: [Movie]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(self.movies) { movie in
                        Button(action: {
                            self.showingDetail.toggle()
                        }) {
                            MoviePosterCard(movie: movie)
                        }.sheet(isPresented: $showingDetail, content: {
                            MovieDetailView(movieId: movie.id)
                        })
                    }
                }
            }
        }
        
    }
}
