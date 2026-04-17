//
//  Game+Snapshot.swift
//  autosaveNashua
//
//  Created by Asia Serrano on 3/9/26.
//

import Foundation
import SwiftData
import Combine
import SwiftUI
import autosaveNashuaPackage

struct GameSnapshotView: View {
    
    @StateObject var random: Game.Snapshot = .random
    
    var body: some View {
        NavigationStack {
            Form {
                
                Section("IDs") {
                    SpacedLabel("constantID", random.constantID)
                    SpacedLabel("compositeID", random.compositeID)
                    SpacedLabel("trackingID", random.trackingID)
                }
                
                Section {
                    
//                    GameImageView(uiimage: $random.boxart)
                    
                    TextField("Title", text: $random.title)
                    
                    DatePicker("Release", selection: $random.release, displayedComponents: .date)
                    
//                    Picker("Status", selection: $random.status, content: {
//                        ForEach(Game.Status.cases) { status in
//                            Text(status.rawValue).tag(status)
//                        }
//                    })
//                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Game Snapshot")
        }
    }
    
    
}

#Preview {
    GameSnapshotView()
}
