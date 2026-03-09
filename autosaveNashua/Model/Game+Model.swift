//
//  Game+Model.swift
//  AutoSaveMock
//
//  Created by Asia Serrano on 1/26/26.
//

import Foundation
import SwiftData
import Combine
import SwiftUI
import Core

public protocol PersistentSnapshotIdentifiable: TypeMetadataProviding, AutonomicIdentifiable, ObservableObject {
    associatedtype Model: PersistentIdentifiable
}

public protocol GameIdentityProviding {
    var title: String { get }
    var release: Date { get }
}

@Model
public final class Game: PersistentIdentifiable, GameIdentityProviding {
    
    @Attribute(.unique)
    public private(set) var globalID: UUID
    public private(set) var strictHashID: UUID
    public private(set) var fuzzyHashID: UUID
    
    public private(set) var title: String
    public private(set) var release: Date
    public private(set) var status_bool: Bool
    public private(set) var boxart: Data?
    public private(set) var added: Date
    
//    @Relationship(inverse: \Property.games)
//    public var properties: [Property] = [] // Initialize array to prevent potential bugs
//    @Relationship(inverse: \Platform.games)
//    public var platforms: [Platform] = [] // Initialize array to prevent potential bugs
    
//    private init(autonomic: AutonomicID) {
//        self.globalID = autonomic.globalID
//        self.strictHashID = autonomic.strictHashID
//        self.fuzzyHashID = autonomic.fuzzyHashID
//        self.title = .defaultValue
//        self.release = .now
//        self.status_bool = .defaultValue
//        self.boxart = nil
//        self.added = .now
//    }
    
    private init(uuid: UUID) {
        self.globalID = uuid
        self.strictHashID = uuid
        self.fuzzyHashID = uuid
        self.title = .defaultValue
        self.release = .now
        self.status_bool = .defaultValue
        self.boxart = nil
        self.added = .now
    }
    
    @discardableResult
    public func update(snapshot: Snapshot) -> Self {
        self.globalID = snapshot.globalID
        self.strictHashID = snapshot.strictHashID
        self.fuzzyHashID = snapshot.fuzzyHashID
        self.title = snapshot.title.trimmed
        self.release = snapshot.release
        self.status_bool = snapshot.status.bool
        self.boxart = snapshot.boxart
        self.added = snapshot.added
        return self
    }
        
}

extension Game {
    
    public enum Status: Enumerable {
        case library, wishlist
        
        public init(_ bool: Bool) {
            switch bool {
            case true: self = .library
            case false: self = .wishlist
            }
        }
        
        public var bool: Bool {
            switch self {
            case .library: return true
            case .wishlist: return false
            }
        }
        
        public var icon: Icon.Enum {
            switch self {
            case .wishlist: return .list_star
            case .library: return .gamecontroller
            }
        }
        
    }
    
    public class Snapshot: GameIdentityProviding, PersistentSnapshotIdentifiable {
        
        public typealias Model = Game
        
        @Published public var title: String
        @Published public var release: Date
        @Published public var status: Game.Status
        @Published public var boxart: Data?
        
        public let uuid: UUID
        public let added: Date
        
        private init(uuid: UUID) {
            self.title = .defaultValue
            self.release = .now
            self.status = .defaultValue
            self.boxart = nil
            self.added = .now
            self.uuid = uuid
        }
        
        public var strictTitle: String { self.title.trimmed }
         
        private var autonomic: AutonomicID {
            let strict = uuid(self.strictTitle)
            let fuzzy = uuid(self.title.canonicalized)
            let multiHashID: MultiHashID = .init(strictHashID: strict, fuzzyHashID: fuzzy)
            let globalID = GlobalID(stableID: self.uuid)
            return .init(multiHashID, globalID)
        }
        
        public var globalID: UUID { self.autonomic.globalID }
        public var strictHashID: UUID { self.autonomic.strictHashID }
        public var fuzzyHashID: UUID { self.autonomic.fuzzyHashID }
        
        private func uuid(_ string: String) -> UUID {
            namespace.uuid(mask: self.release.mask, string, self.release.compact)
        }
        
        public func build(_ model: Model? = nil) -> Model {
            let model: Model = model ?? .init(uuid: self.uuid)
            return model.update(snapshot: self)
        }
        
    }
    
}

//extension Game.Snapshot: Defaultable {
//    
//}
//
//extension Game.Snapshot: Randomizable {
//    
//}
