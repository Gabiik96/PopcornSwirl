//
//  MoviePosterView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviePosterView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(sortDescriptors: [], animation: .default) private var fetchedMovies: FetchedResults<MovieEntity>

    let movies: [Movie]

    var body: some View {
        ScrollView() {
            ForEach(self.movies) { movie in
                NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                    HStack {
                    MoviePosterCard(movie: movie)
                    }
                }.buttonStyle(PlainButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 0, trailing: 20))
    }
}
