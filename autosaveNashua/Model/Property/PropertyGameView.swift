////
////  GameView.swift
////  autosaveNashua
////
////  Created by Asia Serrano on 3/9/26.
////
//
//import SwiftUI
//import SwiftData
//import autosaveNashuaPackage
//
//struct GameView: View {
//    
//    @Environment(\.modelContext) private var modelContext
//    
//    @Query var games: [Game]
//    
//    var body: some View {
//        NavigationStack {
//            Form {
//                ForEach(games) { game in
//                    Section {
//                        SpacedLabel("title", game.title_string)
//                        SpacedLabel("release", game.release_date.long)
//                        SpacedLabel("status", Game.Status(game.status_bool).rawValue)
////                        SpacedLabel("boxart", (game.boxart.isNotEmpty).description)
//                        
//                        SpacedLabel("globalID", game.globalID.uuidString)
//                        SpacedLabel("added", game.add_date.long)
//                        
////                        SpacedLabel("strictHashID", game.strictHashID.uuidString)
////                        SpacedLabel("fuzzyHashID", game.fuzzyHashID.uuidString)
//                    }
//                }
//            }
//            .navigationTitle("Games")
//        }
//    }
//}
//
//#Preview {
//    
//    let previewModelContainer: ModelContainer = {
//
//        let container: ModelContainer = .persisted(Game.self)
//        
////        5.forEach {
////            let snapshot: Game.Snapshot = .random
////            let game: Game = .init(snapshot: snapshot)
////            container.insert(game)
////        }
//        
//        return container
//    }()
//
//    GameView()
//        .modelContainer(previewModelContainer)
//}
