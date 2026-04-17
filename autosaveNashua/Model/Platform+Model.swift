////
////  Platform+Model.swift
////  AutoSaveMock
////
////  Created by Asia Serrano on 2/1/26.
////
//
//import Foundation
//import SwiftData
//import autosaveNashuaPackage
//
//@Model
//public final class Platform: Attribute.Model.Interface {
//    
//    @Relationship(inverse: \Property.platforms)
//    public var properties: [Property] = [] // Initialize array to prevent potential bugs
//    public private(set) var games: [Game] = []
//    public private(set) var uuid: UUID
//    public private(set) var compound_key: String
//    
//    // MARK: value_id from a Property is what should be used to create instance of System or Format Enum Builder.
//
//    public init(system: Property, format: Property, _ builder: Builder) {
//        self.uuid = .init()
//        self.properties = [system, format]
//        self.games = .defaultValue
//        self.compound_key = builder.compound_key
//    }
//    
//    private func get<T: Enumerable.Interface>(_ typeEnum: Property.Builder.Enum.Enum) -> T {
//        if let property = self.properties.first(where: { $0.typeEnum == typeEnum }) {
//            return .init(property.value_id)
//        } else {
//            fatalError("Unable to find \(typeEnum.rawValue) property in platform")
//        }
//    }
//    
//    public var system: System.Builder {
//        self.get(.system)
//    }
//    
//    public var format: Format.Builder {
//        self.get(.format)
//    }
//
//    public var builder: Builder {
//        .init(system: self.system, format: self.format)
//    }
//    
//    public var rawValue: String {
//        "\(self.system.rawValue) | \(self.format.rawValue)"
//    }
//    
//    public var debug: Builder.Debug {
//        .init(storage: [
//            "uuid": self.uuid.uuidString,
//            "compound_key": self.compound_key,
//            "system id": self.system.id,
//            "system value": self.system.rawValue,
//            "format id": self.format.id,
//            "format value": self.format.rawValue,
//            "# of properties": self.properties.count.description
//        ])
//    }
//    
//    public var attribute: Attribute.Builder {
//        .platform(self.builder)
//    }
//    
//    public var persistent: Persistent.Model { .platform(self) }
//    
////    private func get(_ typeEnum: Property.Builder.Enum.Enum) -> Property.Builder? {
////        self.properties.first(where: { $0.typeEnum == typeEnum })?.builder
////    }
////    
////    public var system: System.Builder {
////        if let system = self.get(.system)?.instance as? System.Builder {
////            return system
////        } else {
////            fatalError("Unable to create system builder from properties")
////        }
////    }
////    
////    public var format: Format.Builder {
////        if let format = self.get(.format)?.instance as? Format.Builder {
////            return format
////        } else {
////            fatalError("Unable to create format builder from properties")
////        }
////    }
//        
////
////    public struct Builder {
////        public let system: System.Builder
////        public let format: Format.Builder
////    }
//
//    
////    private init(uuid: UUID?, properties: PropertyArray = .defaultValue, key: String = .defaultValue) {
////        self.uuid = uuid ?? .init()
////        self.properties = properties
////        self.compound_key = key
////    }
////    
////    public convenience init(builder: Builder, map: [Property.Builder: Property], _ uuid: UUID? = nil) {
////        if let primary = map[.system(builder.system)], let secondary = map[.format(builder.format)] {
////            let properties = [primary, secondary]
////            let key = builder.compoundKey.yoke
////            self.init(uuid: uuid, properties: properties, key: key)
////        } else {
////            self.init(uuid: uuid)
////        }
////    }
////    
////    public convenience init(_ primary: Property?, _ secondary: Property?, _ uuid: UUID? = nil) {
////        if let p = primary, let s = secondary, let system = p.builder.asEnumerable(SystemBuilder.self), let format = s.builder.asEnumerable(FormatBuilder.self) {
////            let builder: Builder = .init(system: system, format: format)
////            let map: [Property.Builder: Property] = [p.builder: p, s.builder: s]
////            self.init(builder: builder, map: map)
////        } else {
////            self.init(uuid: uuid)
////        }
////    }
////    
////    public convenience init(builder: Builder) {
////        self.init(uuid: nil)
////    }
//
////    public var system: Property? { self.get(.system) }
////    public var format: Property? { self.get(.format) }
////    public var systemBuilder: SystemBuilder { self.builder.system }
////    public var formatBuilder: FormatBuilder { self.builder.format }
////    
////    private func get(_ key: Property.Key) -> Property? {
////        self.properties.first(where: { $0.key == key })
////    }
////    
//////    public var attribute: Generic.Attribute.Model { .platform(self) }
////    
////    public var model: Generic.Model { .platform(self) }
//
//    
//}
