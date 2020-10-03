//
//  DividerGradient.swift
//  PopcornSwirl
//
//  Created by Gabriel Balta on 03/10/2020.
//

import SwiftUI

struct DividerGradient: View {
    let color: LinearGradient = LinearGradient(gradient: Gradient(colors: [.black, .popcorn_gold, .popcorn_gold, .popcorn_gold, .black]), startPoint: .leading, endPoint: .trailing)
    let width: CGFloat = 2
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
