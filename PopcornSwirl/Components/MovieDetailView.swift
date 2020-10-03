//
//  MovieDetailView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI
import CoreData

struct MovieDetailView: View {
    
    @EnvironmentObject var state: GenreListState
    
    @ObservedObject private var movieDetailState = MovieDetailState()
    
    let movieId: Int
    
    var body: some View {
        ZStack {
            LoadingView(isLoading: self.movieDetailState.isLoading, error: self.movieDetailState.error) {
                self.movieDetailState.loadMovie(id: self.movieId)
            }
            LoadingView(isLoading: self.state.isLoading, error: self.state.error) {
                self.state.loadGenres()
            }
            if movieDetailState.movie != nil && state.genres != nil {
                MovieDetailListView(movie: self.movieDetailState.movie!, genres: state.genres!)
            }
        }
        .navigationBarTitle(movieDetailState.movie?.title ?? "")
        .onAppear {
            self.movieDetailState.loadMovie(id: self.movieId)
            self.state.loadGenres()
        }
    }
    
}

struct MovieDetailListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(sortDescriptors: [], animation: .default) private var fetchedMovies: FetchedResults<MovieEntity>
    
    @State var movieEntity = MovieEntity()
    let allGenres: [Genres]
    var genre: Genres?
    
    @State private var selectedTrailer: MovieVideo?
    @State private var wish = false
    @State private var watch = false
    @State private var note = " "
    
    let imageLoader = ImageLoader()
    
    let movie: Movie
    
    init(movie: Movie, genres: [Genres]) {
        self.movie = movie
        self.allGenres = genres
        
        // Fetch movie from CoreData by Predicate with movie ID
        var predicate: NSPredicate?
        predicate = NSPredicate(format: "id = %@",String(movie.id))
        
        self._fetchedMovies = FetchRequest(entity: MovieEntity.entity(), sortDescriptors: [], predicate: predicate)
        
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
                        self.wish.toggle()
                        if self.watch == true {
                            self.watch.toggle()
                        }
                        updateCoreData()
                    })
                    {
                        ButtonText(
                            text: self.wish ? "Wishlisted" : "Add to wishlist",
                            foregroundColor: self.wish ? .black : .popcorn_red,
                            fillColor: self.wish ? .popcorn_red : .popcorn_gray
                        )
                    }.buttonStyle(BorderlessButtonStyle())
                }.frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                
                VStack {
                    Button(action: {
                        self.watch.toggle()
                        if self.wish == true {
                            self.wish.toggle()
                        }
                        updateCoreData()
                    }) {
                        ButtonText(
                            text: self.watch ? "Watched" : "Mark as watched",
                            foregroundColor: self.watch ? .black : .popcorn_green,
                            fillColor: self.watch ? .popcorn_green : .popcorn_gray
                        )
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
            }
            
            VStack {
                Text("Notes")
                    .foregroundColor(.popcorn_gold)
                    .padding(.bottom, 1)
                ZStack {
                    // invisible Text to secure TextEditor height size
                    Text(note)
                        .opacity(0)
                    
                    TextEditor(text: $note)
                        .frame(minHeight: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.popcorn_gold, lineWidth: 1)
                        )
                }.onDisappear() { updateCoreData() }
            }
            
            if self.movie.genres?.first?.name != nil {
                MovieDropDownView(genre: allGenres.filter{$0.name == self.movie.genres!.first!.name}.first!, title: "Similar movies")
            }
            
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
        .onAppear() {
            configure()
        }
        
    }
    
    //MARK: - Functions
    
    func configure() {
        if fetchedMovies.first != nil {
            self.movieEntity = fetchedMovies.first!
        } else {
            self.movieEntity = MovieEntity(context: self.viewContext)
            self.movieEntity.id = Int64(self.movie.id)
        }
        self.wish = self.movieEntity.wishlisted
        self.watch = self.movieEntity.watched
        self.note = self.movieEntity.note
    }
    
    func updateCoreData() {
        movieEntity.wishlisted = self.wish
        movieEntity.watched = self.watch
        movieEntity.note = self.note
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}

struct MovieDetailImage: View {
    
    @ObservedObject var imageLoader: ImageLoader
    let imageURL: URL
    
    var body: some View {
        ZStack {
            if self.imageLoader.image == nil {
                Rectangle().fill(Color.gray.opacity(0.3))
                    .onAppear() {
                        self.imageLoader.loadImage(with: self.imageURL)
                    }
            } else if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
    }
}

struct ButtonText: View {
    
    var text: String
    var foregroundColor: Color
    var fillColor: Color = .black
    
    var body: some View {
        
        RoundedRectangle(cornerRadius: 30)
            .strokeBorder(self.foregroundColor, lineWidth: 0.9)
            .background(RoundedRectangle(cornerRadius: 30).fill(self.fillColor))
            .overlay(
                Text(self.text).fontWeight(.semibold)
                    .padding(12)
                    .foregroundColor(self.foregroundColor)
            )
        
    }
}

