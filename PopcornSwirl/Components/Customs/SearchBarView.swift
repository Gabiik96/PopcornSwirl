//
//  SearchBarView.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 30/08/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct SearchBarView: View {

    @Binding var text: String

    let placeholder: String

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.steam_back)
                .frame(height: 30)
            .padding(EdgeInsets(top: 10, leading: 15, bottom: 0, trailing: 15))
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(placeholder, text: $text)
            }
            .padding(EdgeInsets(top: 10, leading: 25, bottom: 0, trailing: 20))
        }
    }

}
