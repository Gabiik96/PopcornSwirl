//
//  MoviePosterView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviePosterView: View {
    
    @State var showingDetail = false
    
    let movies: [Movie]
    
    var body: some View {
        
        ScrollView() {
            ForEach(self.movies) { movie in
                Button(action: {
                    self.showingDetail.toggle()
                }) {
                    MoviePosterCard(movie: movie)
                }.sheet(isPresented: $showingDetail, content: {
                    MovieDetailView(movieId: movie.id)
                })
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }.padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
    }
}
