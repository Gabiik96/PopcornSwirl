//
//  ContentView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 23/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        setupApperance()
        
        
    }
    
    var body: some View {
        TabView {
            MoviesSceneView()
                .tabItem {
                    self.tabBarItem(text: "Movies", image: "square.stack")
            }
            DiscoverSceneView()
                .tabItem {
                    self.tabBarItem(text: "Discover", image: "film")
            }
            Text("My List")
                .tabItem {
                    self.tabBarItem(text: "My List", image: "heart.circle")
            }
        }.accentColor(Color.steam_gold)
        
    }
    
    //MARK: - Functions
    func tabBarItem(text: String, image: String) -> some View {
        VStack {
            Image(systemName: image)
                .imageScale(.large)
            Text(text)
        }
    }
    
    private func setupApperance() {
        
        UITableView.appearance().separatorStyle = .none
        
        //NavBar appearance setup
        UINavigationBar.appearance().largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 40)!]
        
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 18)!]
        
        UIBarButtonItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor(named: "steam_gold")!,
            NSAttributedString.Key.font: UIFont(name: "FjallaOne-Regular", size: 16)!],
                                                            for: .normal)
        
        UIWindow.appearance().tintColor = UIColor(named: "steam_gold")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
