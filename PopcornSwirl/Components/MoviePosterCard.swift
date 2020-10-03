//
//  MoviePosterCard.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct MoviePosterCard: View {
    
    let movie: Movie
    @ObservedObject var imageLoader = ImageLoader()
    
    var body: some View {

            ZStack {
                if self.imageLoader.image != nil {
                    Image(uiImage: self.imageLoader.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(8)
                    
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                        .onAppear {
                            self.imageLoader.loadImage(with: self.movie.posterURL)
                        }
                    Text(movie.title)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(minWidth: 100, maxWidth: 500, minHeight: 150, maxHeight: 750, alignment: .center)
    }
}
