//
//  Navigation+Ext.swift
//  gameappsubmission
//
//  Created by Fauzi Nur Noviansyah on 25/06/24.
//

import Foundation
import SwiftUI

extension View {
    public func navigate<Content: View>(
        to destination: Content
    ) -> some View {
        NavigationLink(destination: destination) {
            self
        }
    }
}
