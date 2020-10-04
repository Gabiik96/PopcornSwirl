//
//  ContentView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI
import CoreData
import AppTrackingTransparency
import AdSupport


struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [],
        animation: .default)
    private var fetchedMovies: FetchedResults<MovieEntity>

    var body: some View {
        TabView {
            MoviesSceneView()
                .tabItem {
                    self.tabBarItem(text: "Movies", image: "square.stack")
                }
                .onAppear() { requestIDFA() }
            DiscoverSceneView()
                .tabItem {
                    self.tabBarItem(text: "Discover", image: "film")
                }
            MyListSceneView()
                .tabItem {
                    self.tabBarItem(text: "My List", image: "heart.circle")
                }
        }
        .onAppear() { setupApperance() }
        .accentColor(Color.popcorn_gold)
    }
    
    //MARK: - Functions
    func tabBarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    func requestIDFA() {
      ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
      })
    }
    
    private func setupApperance() {
        
        
        //NavBar appearance setup
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "popcorn_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 40)!]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "popcorn_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 18)!]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(named: "popcorn_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 16)!],
                                                            for: .normal)
        
        UIWindow.appearance().tintColor = UIColor(named: "popcorn_gold")
    }

}

