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
    @EnvironmentObject var orientationInfo: OrientationInfo
    @EnvironmentObject var genreListState: GenreListState
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedMovies: FetchedResults<MovieEntity>
    
    @ObservedObject var movieSearchState = MovieSearchState()
    
    var body: some View {
        
        NavigationView {
            VStack {
                //MARK: PORTRAIT MODE
                if orientationInfo.orientation == .portrait {
                    header
                    DividerGradient()
                    Spacer()
                    
                    if movieSearchState.movies != nil {
                        MoviePosterView(movies: movieSearchState.movies!)
                        
                    } else {
                        MoviesByGenreListView()
                    }
                    //MARK: LANDSCAPE MODE
                } else {
                    HStack {
                        header
                    }
                    DividerGradient()
                    Spacer()
                    
                    if movieSearchState.query.count > 0 {
                        if movieSearchState.movies != nil {
                            MoviePosterCarouselDetailView(movies: movieSearchState.movies!)
                        }
                    } else {
                        MoviesByGenreListView()
                    }
                }
                
            }.navigationBarTitle("Discover")
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear() {
            self.genreListState.loadGenres()
            self.movieSearchState.startObserve()
        }
    }
    
    private var header: some View {
        Group {
            Banner()
            SearchBarView(text: self.$movieSearchState.query)
            Spacer()
        }
    }
    
}

