//
//  DividerGradient.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 27/09/2020.
//  Copyright © 2020 Gabriel Balta. All rights reserved.
//

import SwiftUI

struct DividerGradient: View {
    let color: LinearGradient = LinearGradient(gradient: Gradient(colors: [.black, .steam_gold, .steam_gold, .steam_gold, .black]), startPoint: .leading, endPoint: .trailing)
    let width: CGFloat = 2
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
