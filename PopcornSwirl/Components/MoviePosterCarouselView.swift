//
//  MoviePosterCarouselView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviePosterCarouselDetailView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedMovies: FetchedResults<MovieEntity>
    
    let movies: [Movie]
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 15) {
                ForEach(self.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                        HStack(alignment: .top) {
                            MoviePosterCard(movie: movie)
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(Font.FjallaOne(size: 25))
                                    .foregroundColor(.popcorn_gold)
                                HStack(alignment: .center, spacing: 10) {
                                    PopularityBadge(score: Int(movie.voteAverage * 10))
                                    Text(movie.yearText)
                                        .bold()
                                }
                                Text(movie.overview)
                                    .font(.footnote)
                            }.frame(minWidth: 100, maxWidth: 200)
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                }
            }
        }
    }
}
