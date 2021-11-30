//
//  ContentView.swift
//  Assignment-4-HAIRER
//
//  Created by Ryan Haire on 2021-11-26.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView {
            NavigationLink(
                destination: GameView(),
                label: {
                    Text("Play")
                })
        }
    }
}

