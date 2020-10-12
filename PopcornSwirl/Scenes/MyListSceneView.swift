//
//  MyListSceneView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI
import CoreData


struct MyListSceneView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var orientationInfo: OrientationInfo
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MovieEntity.id, ascending: true)],
                  predicate: NSPredicate(format: "wishlisted = %@", NSNumber(value: true)),
                  animation: .default)
    var wishlistedData: FetchedResults<MovieEntity>
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \MovieEntity.id, ascending: true)],
                  predicate: NSPredicate(format: "watched = %@", NSNumber(value: true)),
                  animation: .default)
    var watchedData: FetchedResults<MovieEntity>
    
    @ObservedObject var wishlistedState = MovieDetailState()
    @ObservedObject var watchedState = MovieDetailState()
    
    @State private var pickerSelected = true
    
    private let layout = [GridItem(.adaptive(minimum: 150))]
    private let navBarTitles = ["Wishlisted", "Watched"]
    
    var body: some View {
        NavigationView {
            VStack {
                
                //MARK: PORTRAIT MODE
                if orientationInfo.orientation == .portrait {
                    VStack {
                        header
                    }
                    //MARK: LANDSCAPE MODE
                } else {
                    HStack {
                        header
                    }
                }
                //MARK: GENERAL
                if pickerSelected == true && wishlistedState.movies.count != 0 {
                    bodyContent
                } else if pickerSelected == false && watchedState.movies.count != 0 {
                    bodyContent
                } else {
                    Spacer()
                    Text("You currently don't have \(navBarTitles[pickerSelected ? 0 : 1]) movies")
                    Spacer()
                    
                }
            }
            .onAppear { self.configure() }
            .navigationBarTitle(navBarTitles[pickerSelected ? 0 : 1])
        }.navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func configure() {
        wishlistedState.movies.removeAll()
        watchedState.movies.removeAll()
        
        if wishlistedData.count != 0 {
            for data in wishlistedData {
                self.wishlistedState.appendMovie(id: Int(data.id))
            }
        }
        
        if watchedData.count != 0 {
            for data in watchedData {
                self.watchedState.appendMovie(id: Int(data.id))
            }
        }
    }
    
    private var header: some View {
        Group {
            Banner()
            Picker(selection: $pickerSelected.animation(), label: Text("")) {
                Text("Wishlisted").tag(true)
                Text("Watched").tag(false)
            }
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
            .pickerStyle(SegmentedPickerStyle())
        }
    }
    
    private var bodyContent: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(self.pickerSelected ? wishlistedState.movies : watchedState.movies, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailView(movieId: movie.id)) {
                        MoviePosterCard(movie: movie)
                    }.buttonStyle(PlainButtonStyle())
                }
            }.padding()
        }
    }
    
}
