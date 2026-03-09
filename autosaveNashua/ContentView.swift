//
//  ContentView.swift
//  autosaveNashua
//
//  Created by Admin on 3/7/26.
//

import SwiftUI
import SwiftData
import Core

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
    let date: Date = .now

    var body: some View {
        NavigationStack {
            Form {
                
                SpacedLabel("long", date.long)
                SpacedLabel("dashes", date.dashed)
                SpacedLabel("sinceReference", date.sinceReference)
                SpacedLabel("since1970", date.since1970)
                
//                SpacedLabel("APP_NAME", APP_NAME)
//                SpacedLabel("APP_DIRECTORY", APP_DIRECTORY)
//                
//                SpacedLabel("random", .random)
//                SpacedLabel("name", .randomName)
//                SpacedLabel("random 2", .random(2))

//                SpacedLabel("STRINGS_FILE_PATH", STRINGS_FILE_PATH)
                
            }
            .toolbar {
               
            }
        }
    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
