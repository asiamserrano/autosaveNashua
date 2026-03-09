////
////  PersistentHashID.swift
////  autosaveBeta
////
////  Created by Asia Serrano on 3/4/26.
////
//

import Foundation
import Core

public struct MultiHashID: MultiHashIdentifiable {
    
    public let strictHashID: UUID
    public let fuzzyHashID: UUID
    
    init(strictHashID: UUID, fuzzyHashID: UUID) {
        self.strictHashID = strictHashID
        self.fuzzyHashID = fuzzyHashID
    }
    
}

public struct GlobalID: GlobalIdentifiable {
    
    public let globalID: UUID
    
    init() {
        self.init(stableID: .init())
    }
    
    init(stableID: UUID) {
        self.globalID = stableID
    }
    
}

public struct AutonomicID: AutonomicIdentifiable {
    
    private let multiHash: MultiHashID
    private let global: GlobalID
    
    public init(_ multiHash: MultiHashID, _ global: GlobalID) {
        self.multiHash = multiHash
        self.global = global
    }
    
    public var strictHashID: UUID {
        self.multiHash.strictHashID
    }
    
    public var fuzzyHashID: UUID {
        self.multiHash.fuzzyHashID
    }
    
    public var globalID: UUID {
        self.global.globalID
    }
    
}
