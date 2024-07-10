//
//  BindingExtensions.swift
//  BracketBuddy
//
//  Created by Santiago on 1/23/24.
//
import SwiftUI

extension Binding where Value == Bool {
    /// A computed property to negate the boolean value.
    var not: Binding<Bool> {
        Binding<Bool>(
            get: { !self.wrappedValue },
            set: { self.wrappedValue = !$0 }
        )
    }
}

