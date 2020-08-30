//
//  MoviePosterView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct MoviePosterView: View {
    
    let movies: [Movie]
    
    var body: some View {
        
        List {
            ForEach(self.movies) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                    MoviePosterCard(movie: movie)
                }.buttonStyle(PlainButtonStyle())
            }
        }.padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
    
}



