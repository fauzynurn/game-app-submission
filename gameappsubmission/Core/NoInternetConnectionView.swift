//
//  NoInternetConnectionView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 19/06/24.
//

import SwiftUI

struct NoInternetConnectionView: View {
    let onTapRetryButton: () -> Void
    
    var body: some View {
        VStack {
            Image(systemName: "wifi.slash")
                .resizable()
                .frame(width: 50, height: 50)
                .padding(.bottom, 16)
            Text("No internet connection.")
                .multilineTextAlignment(.center)
                .padding(.bottom, 2)
            Button(action: onTapRetryButton, label: {
                Text("Retry")
            })
        }
    }
}

#Preview {
    NoInternetConnectionView(onTapRetryButton: {})
}
