//
//  MyListSceneView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI
import CoreData

struct MyListSceneView: View {
    
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    @FetchRequest(entity: MovieEntity.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "wishlisted = %@", NSNumber(value: true))
    ) var wishlistedData: FetchedResults<MovieEntity>
    
    @FetchRequest(entity: MovieEntity.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "watched = %@", NSNumber(value: true))
    ) var watchedData: FetchedResults<MovieEntity>
    
    @ObservedObject var wishlistedState = MovieDetailState()
    @ObservedObject var watchedState = MovieDetailState()
    
    @State private var pickerSelected = 0
    
    private let layout = [GridItem(.adaptive(minimum: 150))]
    private let navBarTitles = ["Wishlisted", "Watched"]
    
    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $pickerSelected.animation(), label: Text("")) {
                    Text("Wishlisted").tag(0)
                    Text("Watched").tag(1)
                }
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
                .pickerStyle(SegmentedPickerStyle())
                
                if pickerSelected == 0 && wishlistedState.movies.count != 0 {
                    ScrollView {
                        LazyVGrid(columns: layout) {
                            ForEach(wishlistedState.movies) { movie in
                                NavigationLink(destination:
                                                MovieDetailView(movieId: movie.id)
                                                .transition(.opacity)
                                                .onDisappear() { self.configure() }
                                ) {
                                    MoviePosterCard(movie: movie)
                                }.buttonStyle(PlainButtonStyle())
                            }
                        }.padding()
                    }
                } else if pickerSelected == 1 && watchedState.movies.count != 0 {
                    ScrollView {
                        LazyVGrid(columns: layout) {
                            ForEach(watchedState.movies, id: \.id) { movie in
                                NavigationLink(destination:
                                                MovieDetailView(movieId: movie.id)
                                                .onDisappear() { self.configure() }
                                ) {
                                    MoviePosterCard(movie: movie)
                                }.buttonStyle(PlainButtonStyle())
                                .transition(.asymmetric(insertion: .scale, removal: .slide))
                            }
                        }.padding()
                    }
                } else {
                    Spacer()
                    Text("You currently don't have \(navBarTitles[pickerSelected]) movies")
                    Spacer()
                    
                }
            }.navigationBarTitle(navBarTitles[pickerSelected])
        }.onAppear {
            self.configure()
        }
    }
    
    func configure() {
        wishlistedState.movies.removeAll()
        watchedState.movies.removeAll()
        
        if wishlistedData.count != 0 {
            for data in wishlistedData {
                self.wishlistedState.appendMovie(id: Int(data.movieID))
                
            }
        }
        
        if watchedData.count != 0 {
            for data in watchedData {
                self.watchedState.appendMovie(id: Int(data.movieID))
            }
        }
    }
    
    func checkWish() {
        if wishlistedData.count != 0 {
            var moviesData = [Int]()
            for data in wishlistedData {
                moviesData.append(Int(data.movieID))
            }
            
            wishlistedState.movies = wishlistedState.movies.filter {
                moviesData.contains($0.id)
            }
        }
        
//        wishlistedState.
    }
}

