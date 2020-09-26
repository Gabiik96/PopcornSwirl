//
//  MovieDetailView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI
import CoreData


struct MovieDetailView: View {
    
    @ObservedObject private var movieDetailState = MovieDetailState()
    
    let movieId: Int
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId)
            }
            
            if movieDetailState.movie != nil {
                MovieDetailListView(movie: self.movieDetailState.movie!)
                
            }
        }
        .navigationBarTitle(movieDetailState.movie?.title ?? "")
        .onAppear {
            self.movieDetailState.loadMovie(id: self.movieId)
        }
    }
}

struct MovieDetailListView: View {
    
    @Environment(\.managedObjectContext) var moc: NSManagedObjectContext
    @FetchRequest var currentFetch: FetchedResults<MovieEntity>
    
    @State private var selectedTrailer: MovieVideo?
    
    let coreDataController = CoreDataController()
    let imageLoader = ImageLoader()
    
    let movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
        
        // Fetch movie from CoreData by Predicate with movie ID
        var predicate: NSPredicate?
        predicate = NSPredicate(format: "movieID = %@",String(movie.id))
        
        self._currentFetch = FetchRequest(entity: MovieEntity.entity(), sortDescriptors: [], predicate: predicate)
        
    }
    
    var body: some View {
        List {
            MovieDetailImage(imageLoader: imageLoader, imageURL: self.movie.backdropURL)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            
            HStack {
                Text(movie.genreText)
                Text("·")
                Text(movie.yearText)
                Text(movie.durationText)
            }
            
            Text(movie.overview)
            HStack {
                if !movie.ratingText.isEmpty {
                    Text(movie.ratingText).foregroundColor(.yellow)
                        + Text(movie.restOfRating).foregroundColor(.gray)
                }
                Text(movie.scoreText)
                
            }
            
            HStack {
                VStack {
                    Button(action: {
                        if currentFetch.count != 0  {
                            coreDataController.updateMovie(
                                moc: self.moc, movie: currentFetch.first!,
                                wishlisted: currentFetch.first!.wishlisted ? false : true)
                        } else {
                            coreDataController.saveMovie(moc: self.moc, movieID: self.movie.id, wishlisted: true)
                            
                        }
                    }) {
                        ButtonText(text: "Add to wishlist", color: .red)
                    }.buttonStyle(BorderlessButtonStyle())
                   
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
               
                
                VStack {
                    Button(action: {
                        print("Hello button tapped!")
                    }) {
                        ButtonText(text: "Mark as watched", color: .green)
                    }.buttonStyle(BorderlessButtonStyle())
                    
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
            }
            
            HStack(alignment: .top, spacing: 4) {
                if movie.cast != nil && movie.cast!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Starring").font(.headline)
                        ForEach(self.movie.cast!.prefix(9)) { cast in
                            Text(cast.name)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    Spacer()
                    
                }
                
                if movie.crew != nil && movie.crew!.count > 0 {
                    VStack(alignment: .leading, spacing: 4) {
                        if movie.directors != nil && movie.directors!.count > 0 {
                            Text("Director(s)").font(.headline)
                            ForEach(self.movie.directors!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        
                        if movie.producers != nil && movie.producers!.count > 0 {
                            Text("Producer(s)").font(.headline)
                                .padding(.top)
                            ForEach(self.movie.producers!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                        
                        if movie.screenWriters != nil && movie.screenWriters!.count > 0 {
                            Text("Screenwriter(s)").font(.headline)
                                .padding(.top)
                            ForEach(self.movie.screenWriters!.prefix(2)) { crew in
                                Text(crew.name)
                            }
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                }
            }.onAppear() { print(currentFetch.count)}
            
            Divider()
            
            if movie.youtubeTrailers != nil && movie.youtubeTrailers!.count > 0 {
                Text("Trailers").font(.headline)
                
                ForEach(movie.youtubeTrailers!) { trailer in
                    Button(action: {
                        self.selectedTrailer = trailer
                    }) {
                        HStack {
                            Text(trailer.name)
                            Spacer()
                            Image(systemName: "play.circle.fill")
                                .foregroundColor(Color(UIColor.systemBlue))
                        }
                    }
                }
            }
        }
        .sheet(item: self.$selectedTrailer) { trailer in
            SafariView(url: trailer.youtubeURL!)
        }
    }
}

struct MovieDetailImage: View {
    
    @ObservedObject var imageLoader: ImageLoader
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct ButtonText: View {
    
    var text: String
    var color: Color
    
    var body: some View {
        Text(self.text)
            .padding(12)
            .foregroundColor(self.color)
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(self.color, lineWidth: 0.7)
            )
    }
}

