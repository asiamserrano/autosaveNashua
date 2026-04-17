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
import autosaveNashuaPackage

@Model
public final class Game: PersistentIdentifiable {

    public private(set) var constantID: UUID
    public private(set) var compositeID: UUID // if there are any changes to any of the relevant content
    public private(set) var trackingID: UUID // if the unique composite key for the object has changed
    
    public private(set) var title_string: String
    public private(set) var release_date: Date
    public private(set) var status_bool: Bool
    public private(set) var boxart_data: Data?
    public private(set) var add_date: Date
    
    public init(snapshot: Snapshot) {
        self.constantID = .init()
        self.compositeID = .init()
        self.trackingID = .init()
        self.title_string = .defaultValue
        self.release_date = .now
        self.status_bool = .defaultValue
        self.boxart_data = nil
        self.add_date = .now
        self.update(snapshot: snapshot)
    }
    
    @discardableResult
    public func update(snapshot: Snapshot) -> Self {
        self.constantID = snapshot.constantID
        self.compositeID = snapshot.compositeID
        self.trackingID = snapshot.trackingID
        self.title_string = snapshot.title.trimmed
        self.release_date = snapshot.release
        self.status_bool = snapshot.status.bool
        self.boxart_data = snapshot.boxart?.pngData()
        self.add_date = snapshot.added
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
    
    public final class Snapshot: PersistentSnapshot {
        
        @Published public var title: String
        @Published public var release: Date
        @Published public var status: Game.Status
        @Published public var boxart: UIImage?
        
        public let constantID: UUID
        public let added: Date
        
        public init(status: Game.Status) {
            let date: Date = .now
            self.title = .defaultValue
            self.release = date
            self.status = status
            self.boxart = nil
            self.added = date
            self.constantID = date.uuid(Self.namespace)
        }
        
        public init(model: Model) {
            self.title = model.title_string
            self.release = model.release_date
            self.status = .init(model.status_bool)
            self.boxart = .init(model.boxart_data)
            self.added = model.add_date
            self.constantID = model.constantID
        }
        
    }
    
}

extension Game.Snapshot {
    
    public typealias Model = Game
            
    public var trackingID: UUID {
        let data = self.boxart?.pngData()
        let mask = data?.toUInt8 ?? .defaultValue
        let encoded = data?.base64EncodedString() ?? .defaultValue
        return namespace.uuid(self.title.trimmed, self.release.compact, self.status.rawValue, encoded, mask: mask)
    }
    
    public var compositeID: UUID {
        let mask = self.release.toUInt8
        return namespace.uuid(self.title.canonicalized, self.release.compact, mask: mask)
    }
    
    public func build(_ model: Model? = nil) -> Model {
        model?.update(snapshot: self) ?? .init(snapshot: self)
    }
    
}

extension Game.Snapshot: Defaultable {
    
    public static func defaultValue(_ status: Game.Status) -> Self {
        .init(status: status)
    }
    
    public static var defaultValue: Self {
        .defaultValue(.defaultValue)
    }
    
}

extension Game.Snapshot: Randomizable {
    
    public static func random(_ status: Game.Status) -> Self {
        let snapshot: Self = .init(status: status)
        snapshot.title = .randomName
        snapshot.release = .random
        return snapshot
    }
    
    public static var random: Self {
        .random(.random)
    }
    
}
