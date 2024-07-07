//
//  LazyView.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 29/06/24.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let build: () -> Content
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    var body: Content {
        build()
    }
}
