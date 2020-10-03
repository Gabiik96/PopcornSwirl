//
//  MoviePosterCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviePosterCarouselView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedMovies: FetchedResults<MovieEntity>
    
    let movies: [Movie]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 15) {
                ForEach(self.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                        MoviePosterCard(movie: movie)
                    }.buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
