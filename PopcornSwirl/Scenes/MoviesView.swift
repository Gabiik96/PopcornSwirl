//
//  DiscoverView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct MoviesScene: View {
    
    @ObservedObject private var popularState = MovieListState()
    @ObservedObject private var topRatedState = MovieListState()
    @ObservedObject private var upcomingState = MovieListState()
    
    @ObservedObject var movieSearchState = MovieSearchState()
    
    @State private var pickerSelected = 0
    
    private let navBarTitles = ["Popular","Top Rated", "Upcoming"]
    
    
    var body: some View {
        NavigationView {
            VStack {
                SearchBarView()
                
                Picker(selection: $pickerSelected.animation(), label: Text("")) {
                    Text("Popular").tag(0)
                    Text("Top Rated").tag(1)
                    Text("Upcoming").tag(2)
                }
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                .pickerStyle(SegmentedPickerStyle())
                
                
                if pickerSelected == 0 {
                    MovieGroupView(state: popularState, pickedCase: .popular)
                } else if pickerSelected == 1 {
                    MovieGroupView(state: topRatedState, pickedCase: .topRated)
                } else if pickerSelected == 2 {
                    MovieGroupView(state: upcomingState, pickedCase: .upcoming)
                }
            }
            .navigationBarTitle(navBarTitles[pickerSelected])
        }
        .onAppear {
            self.popularState.loadMovies(with: .popular)
            self.topRatedState.loadMovies(with: .topRated)
            self.upcomingState.loadMovies(with: .upcoming)
        }
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
        }
        .transition(AnyTransition.slide.combined(with: .opacity))
    }
}


struct SearchBarView: UIViewRepresentable {

    let placeholder: String
    @Binding var text: String
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = text
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.placeholder = placeholder
        searchBar.searchBarStyle = .minimal
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(text: self.$text)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.text = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }

}
