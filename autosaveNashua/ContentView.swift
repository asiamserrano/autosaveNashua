//
//  ContentView.swift
//  autosaveNashua
//
//  Created by Admin on 3/7/26.
//

import SwiftUI
import SwiftData
import autosaveNashuaPackage

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            Form {
                Text(String.random)
//                TestView(Game.self)
//                TestView(Constants.self)
            }
            .toolbar {
               
            }
        }
    }
    
    @ViewBuilder
    private func TestView<T: UUIDNamespaceProviding>(_ t: T.Type, _ name: String) -> some View {
        SpacedLabel(name, t.namespace.namespaceString)
    }
    
    @ViewBuilder
    private func TestView<T: TypeMetadataProviding>(_ t: T.Type) -> some View {
        TestView(t, t.relativeName)
    }
    
    
//    private func getString(_ int: Int) -> String {
//        let uuid = UUID().uuidString
//        
////
//        return uuid
//    }

}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
