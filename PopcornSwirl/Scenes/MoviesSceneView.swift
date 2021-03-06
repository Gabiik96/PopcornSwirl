//
//  MovieSceneView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI
import CoreData

struct MoviesSceneView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var orientationInfo: OrientationInfo
    @EnvironmentObject var genreListState: GenreListState
    
    @FetchRequest(sortDescriptors: [], animation: .default)
    private var fetchedMovies: FetchedResults<MovieEntity>
    
    @ObservedObject private var popularState = MovieListState()
    @ObservedObject private var topRatedState = MovieListState()
    @ObservedObject private var upcomingState = MovieListState()
    
    @State private var pickerSelected = 0
    
    private let navBarTitles = ["Popular","Top Rated", "Upcoming"]
    
    var body: some View {
        NavigationView {
            Group {
                //MARK: PORTRAIT MODE
                if orientationInfo.orientation == .portrait {
                    VStack {
                        header
                        if pickerSelected == 0 {
                            MovieGroupView(state: popularState, pickedCase: .popular)
                        } else if pickerSelected == 1 {
                            MovieGroupView(state: topRatedState, pickedCase: .topRated)
                        } else if pickerSelected == 2 {
                            MovieGroupView(state: upcomingState, pickedCase: .upcoming)
                        }
                    }
                    //MARK: LANDSCAPE MODE
                } else {
                    VStack {
                        HStack {
                           header
                        }
                        if pickerSelected == 0 {
                            MovieLandscapeGroupView(state: popularState, pickedCase: .popular)
                        } else if pickerSelected == 1 {
                            MovieLandscapeGroupView(state: topRatedState, pickedCase: .topRated)
                        } else if pickerSelected == 2 {
                            MovieLandscapeGroupView(state: upcomingState, pickedCase: .upcoming)
                        }
                    }
                }
                
            }.navigationBarTitle(navBarTitles[pickerSelected])
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            self.genreListState.loadGenres()
            self.popularState.loadMovies(with: .popular)
            self.topRatedState.loadMovies(with: .topRated)
            self.upcomingState.loadMovies(with: .upcoming)
        }
    }
    
    private var header: some View {
        Group {
            Banner()
            Picker(selection: $pickerSelected.animation(), label: Text("")) {
                Text("Popular").tag(0)
                Text("Top Rated").tag(1)
                Text("Upcoming").tag(2)
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
            .pickerStyle(SegmentedPickerStyle())
            Spacer()
        }
    }
    
}

struct MovieLandscapeGroupView: View {
    
    @ObservedObject var state: MovieListState
    
    var pickedCase: MovieListEndpoint
    
    var body: some View {
        VStack {
            if state.movies != nil {
                MoviePosterCarouselDetailView(movies: state.movies!)
                
            } else {
                LoadingView(isLoading: state.isLoading, error: state.error) {
                    self.state.loadMovies(with: self.pickedCase)
                }
            }
        }
        .transition(AnyTransition.slide.combined(with: .opacity))
    }
}

struct MovieGroupView: View {
    
    @ObservedObject var state: MovieListState
    
    var pickedCase: MovieListEndpoint
    
    var body: some View {
        Group {
            if state.movies != nil {
                MoviePosterView(movies: state.movies!)
                
            } else {
                LoadingView(isLoading: state.isLoading, error: state.error) {
                    self.state.loadMovies(with: self.pickedCase)
                }
            }
        }.transition(AnyTransition.slide.combined(with: .opacity))
    }
}

