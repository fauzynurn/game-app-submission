//
//  AboutView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 08/06/24.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 8) {
            Image("profile_pic", bundle: nil)
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .clipShape(.circle)
            Text("Fauzi Nur Noviansyah")
            Text("- iOS Fundamental Dicoding Submission -")
        }
    }
}

#Preview {
    AboutView()
}
