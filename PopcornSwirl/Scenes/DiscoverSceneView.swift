//
//  DiscoverySceneView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI
import CoreData

struct DiscoverSceneView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var genreListState: GenreListState
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedMovies: FetchedResults<MovieEntity>
    
    @ObservedObject var movieSearchState = MovieSearchState()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                SearchBarView(text: self.$movieSearchState.query)
                DividerGradient()
                Spacer()
                if movieSearchState.query.count > 0 {
                    if movieSearchState.movies != nil {
                        MoviePosterView(movies: movieSearchState.movies!)
                    }
                } else {
                    GenreCarouselView()
                }
            }.navigationBarTitle("Discover")
        }.onAppear() {
            self.genreListState.loadGenres()
            self.movieSearchState.startObserve()
        }
    }
}
