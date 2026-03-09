//
//  ContentView.swift
//  autosaveNashua
//
//  Created by Admin on 3/7/26.
//

import SwiftUI
import SwiftData
import Core

//public protocol SelfTypefReferencing {
//    typealias Protocol = SelfTypefReferencing
//}
//
//extension SelfTypefReferencing {
//    
//    static var myTypeSelf: String { String(reflecting: Reference.Type.self) }
//    static var mySelf: String { String(reflecting: Reference.self) }
//    
//}
//
//public struct MyStruct: MyProtocol { }

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    
    @Query private var items: [Item]
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("Constants") {
                    SpacedLabel("Contract", Constants.contract.string)
                    SpacedLabel("NS", Constants.namespace.string)
                }
                
                Section("Game") {
                    SpacedLabel("Contract", Game.contract.string)
                    SpacedLabel("NS", Game.namespace.string)
                }


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
