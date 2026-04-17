////
////  PersistentHashID.swift
////  autosaveBeta
////
////  Created by Asia Serrano on 3/4/26.
////
//

import Foundation
import autosaveNashuaPackage

//public struct MultiHashID: MultiHashIdentifiable {
//    
//    public let strictHashID: UUID
//    public let fuzzyHashID: UUID
//    
//    init(strictHashID: UUID, fuzzyHashID: UUID) {
//        self.strictHashID = strictHashID
//        self.fuzzyHashID = fuzzyHashID
//    }
//    
//}

//public struct GlobalID: GlobalIdentifiable {
//    
//    public let globalID: UUID
//    
//    init() {
//        self.init(stableID: .init())
//    }
//    
//    init(stableID: UUID) {
//        self.globalID = stableID
//    }
//    
//}

//public struct AutonomicID: AutonomicIdentifiable {
//    
//    public enum Keys {
//        case global, fuzzy, strict
//    }
//    
//    private let multiHash: MultiHashID
//    public let globalID: UUID
//    
//    public init(globalID global: UUID, _ multiHash: MultiHashID) {
//        self.multiHash = multiHash
//        self.globalID = global
//    }
//    
//    public init<T: GlobalIdentifiable>(_ t: T, _ multiHash: MultiHashID) {
//        self.multiHash = multiHash
//        self.globalID = t.globalID
//    }
//    
//    public var strictHashID: UUID {
//        self.multiHash.strictHashID
//    }
//    
//    public var fuzzyHashID: UUID {
//        self.multiHash.fuzzyHashID
//    }
//    
//    public func uuid(_ key: Keys) -> UUID {
//        switch key {
//        case .global:
//            self.globalID
//        case .fuzzy:
//            self.fuzzyHashID
//        case .strict:
//            self.strictHashID
//        }
//    }
//    
//}
