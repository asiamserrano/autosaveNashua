////
////  Property+Model.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 1/30/26.
////
//
//import Foundation
//import SwiftData
//import Core
//
//@Model
//public final class Property: Attribute.Model.Interface {
//    
//    public private(set) var uuid: UUID
//    public private(set) var compound_key: String
//    public private(set) var type_id: String
//    public private(set) var value_id: String
//    public private(set) var value_rawValue:  String
//    
//    public init() {
//        self.uuid = .init()
//        self.type_id = .defaultValue
//        self.value_id = .defaultValue
//        self.value_rawValue =  .defaultValue
//        self.compound_key = .defaultValue
//    }
//    
//    public private(set) var games: [Game] = []
//    public private(set) var platforms: [Platform] = []
//    
//    public init(builder: Builder) {
//        self.uuid = .init()
//        self.type_id = builder.type.id
//        self.value_id = builder.value.id
//        self.value_rawValue = builder.value.rawValue
//        self.compound_key = builder.compound_key
//    }
//    
//    public var builder: Builder {
//        switch self.type {
//        case .input(let i): return .input(.init(i, self.value_rawValue))
//        case .mode: return .mode(.init(self.value_id))
//        case .system: return .system(.init(self.value_id))
//        case .format: return .format(.init(self.value_id))
//        }
//    }
//    
//    public var type: Builder.Enum {
//        .init(self.type_id)
//    }
//    
//    public var typeEnum: Builder.Enum.Enum {
//        self.type.type
//    }
//    
//    public var rawValue: String {
//        "(\(self.type.rawValue)) \(self.value_rawValue)"
//    }
//    
//    public var debug: Builder.Debug {
//        .init(storage: [
//            "uuid": self.uuid.uuidString,
//            "compound_key": self.compound_key,
//            "type_id": self.type_id,
//            "value_id": self.value_id,
//            "value_rawValue": self.value_rawValue,
//            "# of platforms": self.platforms.count.description
//        ])
//    }
//    
//    public var attribute: Attribute.Builder? {
//        self.builder.attribute
//    }
//    
//    public var persistent: Persistent.Model { .property(self) }
//
////    public init(uuid: UUID, builder: Builder) {
////        self.uuid = uuid
////        self.type_id = builder.compoundKey.id
////        self.value_id = builder.valueCompound.id
////        self.value_rawValue =  builder.valueCompound.rawValue
////        self.compound_key = builder.compoundKey.yoke
////    }
//    
////    public convenience init(builder: Builder) {
////        self.init(uuid: .init(), builder: builder)
////    }
//    
////    public var key: Key { self.builder.key }
////    
////    public var keyBuilder: Key.Builder { self.builder.keyBuilder }
////    
////    public var valueCompound: Compound.Str { self.builder.valueCompound }
////    
//////    public var attribute: Generic.Attribute.Model { .property(self) }
////
////    public var model: Generic.Model { .property(self) }
//
//            
//}
//
//
////extension Property {
////        
////    public static func getByKeyBuilder(_ keyBuilder: Property.Key.Builder) -> FetchDescriptor<Property> {
////        let id: String = keyBuilder.id
////        return .init(predicate: #Predicate {
////            $0.type_id == id
////        })
////    }
////    
////    public static func getByKey(_ key: Property.Key) -> FetchDescriptor<Property> {
////        let ids: [String] = key.builderCases.map(\.id)
////        return .init(predicate: #Predicate {
////            ids.contains($0.type_id)
////        })
////    }
////    
////    public static func getByUUID(_ uuid: UUID) -> FetchDescriptor<Property> {
////        let id = uuid
////        return .init(predicate: #Predicate<Property> { $0.uuid == id })
////    }
////    
////    public var debugMap: [String: String] {
////        [
////            "uuid": self.uuid.uuidString,
////            "compound_key": self.compound_key,
////            "type_id": self.type_id,
////            "value_id": self.value_id,
////            "value_rawValue": self.value_rawValue
////        ]
////    }
////        
////}
//
////extension Property.Builder {
////    
////    public var debugMap: [String: String] {
////        [
////            "id": self.id,
////            "modelType": self.modelType.rawValue,
////            "key": self.key.rawValue,
////            "keyBuilder": self.keyBuilder.rawValue,
////            "valueCompound_id": self.valueCompound.id,
////            "valueCompound_rawValue": self.valueCompound.rawValue,
////            "valueCompound_yoke": self.valueCompound.yoke,
////            "compoundKey": self.compoundKey.id,
////            "compoundKey_rawValue": self.compoundKey.rawValue,
////            "compoundKey_yoke": self.compoundKey.yoke,
////            "rawValue": self.rawValue
////        ]
////    }
////    
////}
////
////extension Generic.Collection<Property.Builder> {
////    
//////    public typealias Element = Property.Builder
////    
////    public typealias E = Property.Key.Builder
////    
////    public static func random(_ size: Int) -> Self {
////        return .init(collection: E.cases.flatMap { Self.random($0, size) })
////    }
////    
////    public static func random(_ key: E, _ size: Int) -> Self {
////        switch key {
////        case .input(let i): return .init(collection: Set<String>.init(size).map { .input(.init(i, $0))})
////        case .mode: return .init(collection: ModeEnum.cases.subset(size).map { .mode($0) })
////        case .format: return .init(collection: FormatBuilder.cases.subset(size).map { .format($0) })
////        case .system: return .init(collection: SystemBuilder.cases.subset(size).map { .system($0) })
////        }
////    }
////    
////}
