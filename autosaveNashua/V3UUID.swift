////
////  FunctionalUUID.swift
////  autosaveBeta
////
////  Created by Asia Serrano on 2/25/26.
////
//
//import Foundation
//import CryptoKit
//import autosaveNashuaPackage
//
//public typealias FunctionalUUIDNamespace = FunctionalUUID.Namespace
////public typealias UUIDNamespace = FunctionalUUIDNamespace
//
//
//
//public struct FunctionalUUID {
//    
//    private static let defaultValueUUIDString = "00000000-0000-0000-0000-000000000000"
//    private static let classNameUUIDString = "91B2D41E-8990-427D-9E55-6310918C9D39"
//
////    private static let enumerableUUIDString = "AEA10A85-56DA-44BE-A0C5-67BC55E59776"
////    private static let persistentUUIDString = "A058A51B-F362-42BE-92AA-988C8ED395F3"
//    
//    private struct UUIDStrings {
//        
//        fileprivate static let defaultValue = UUIDStrings(rawValue: defaultValueUUIDString)
//        fileprivate static let className = UUIDStrings(rawValue: classNameUUIDString)
//        
//        public let rawValue: String
//        
//    }
//            
//    public struct Namespace: UUIDNamespacing {
//        
//        private struct UUIDString {
//            
//            fileprivate static let defaultValue = UUIDString(rawValue: defaultValueUUIDString)
//            fileprivate static let className = UUIDString(rawValue: classNameUUIDString)
//
//            
////            public static let enumerable = UUIDString(rawValue: enumerableUUIDString)
////            public static let persistent = UUIDString(rawValue: persistentUUIDString)
//            
//            public let rawValue: String
//            
//        }
//        
//        fileprivate static let defaultValue = Namespace(.defaultValue)
//        fileprivate static let className = Namespace(.className)
////        private static let enumerable = Namespace(.enumerable)
////        private static let persistent = Namespace(.persistent)
////        private static let snapshot = Namespace(.snapshot)
//        
//        fileprivate let uuidTuple: UUID.Tuple
//        public let uuidString: String
//        
//        public init<T: TypeMetadataProviding>(className t: T.Type) {
//            self.init(.className, t)
//        }
//        
////        public init<T: Enumerable>(enumerable t: T.Type) {
////            self.init(.enumerable, t)
////        }
////        
////        public init<T: PersistentIdentifiable>(persistent t: T.Type) {
////            self.init(.persistent, t)
////        }
//        
////        public init<T: PersistentSnapshotIdentifiable>(snapshot t: T.Type) {
////            let names = [ t.className, t.Model.className ]
////            let functional: FunctionalUUID = .init(namespace: .persistent, name: names)
////            self.init(functional: functional)
////        }
//        
//        public func uuid(mask: UInt8, _ strings: String...) -> UUID {
//            FunctionalUUID(namespace: self, name: strings, version: mask).uuid
//        }
//        
////        public func uuid(title: String, release: Date) -> UUID {
////            let strings = [ title.canonicalized ]
////            let mask = release.uInt8
////            print("Mask: \(mask) | strings: \(strings)")
////            return uuid(strings, mask)
////        }
//        
////        public func uuid<T:Enumerable>(enumerable t: T, _ strings: String...) -> UUID {
//////            print("strings before: \(strings.description)")
////            let mask = t.index.uInt8
////            let strings = strings.ordered.withHead(t.id)
//////            print("strings after: \(strings.description)")
////            return uuid(strings, mask)
////        }
//        
////        private func uuid(_ strings: [String], _ mask: UInt8) -> UUID {
////            FunctionalUUID(namespace: self, name: strings, version: mask).uuid
////        }
//                
//    }
//    
//    fileprivate let uuid: UUID
//    
//    private init(namespace: Namespace, name: any Collection<String>, version: UInt8? = nil) {
//        // 1) Get namespace bytes in network byte order (big-endian)
//        var ns = namespace.uuidTuple
//        var dataBytes = withUnsafeBytes(of: &ns) { Data($0) }
//        
//        // 2) Append name bytes
//        dataBytes.append(name.data)
//        
//        // 1) Hash the UTF-8 bytes of the string
//        let digest = Insecure.MD5.hash(data: dataBytes)
//        var bytes = Data(digest) // 16 bytes
//        
//        // 3) Use functional version/variant bits (RFC 4122)
//        let version = version ?? .defaultValue
//        bytes[6] = (bytes[6] & 0x0F) | version  // version
//        bytes[8] = (bytes[8] & 0x3F) | 0x80  // variant = 10xx xxxx
//        
//        // 4) Build UUID from the 16 bytes
//        let uuidTuple = bytes.withUnsafeBytes { rawPtr -> uuid_t in
//            let p = rawPtr.bindMemory(to: UInt8.self).baseAddress!
//            return (p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7],
//                    p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15])
//        }
//        
//        self.uuid = .init(uuid: uuidTuple)
//    }
//
//}
//
//extension FunctionalUUID.Namespace {
//    
//    private init<T: TypeMetadataProviding>(_ ns: Self, _ t: T.Type) {
//        let functional: FunctionalUUID = .init(namespace: ns, name: t.absoluteName.asArray)
//        self.init(functional: functional)
//    }
//        
//    private init(functional: FunctionalUUID) {
//        self.init(uuid: functional.uuid)
//    }
//    
//    private init(uuid: UUID) {
//        self.uuidTuple = uuid.uuid
//        self.uuidString = uuid.uuidString
//    }
//    
//    private init(_ uuidString: UUIDString) {
//        if let uuid: UUID = .init(uuidString: uuidString.rawValue) {
//            self.init(uuid: uuid)
//        } else {
//            let error = "Error casting uuidString '\(uuidString)' to UUID Namespace"
//            print(error)
//            fatalError(error)
//        }
//    }
//    
////    private struct Element: Hashable {
////        let className: String
////        
////        init<T: TypeMetadataProviding>(_ t: T.Type) {
////            self.className = t.className
////        }
////    }
//
//}
//
////extension TypeMetadataProviding {
////    
////    public static var namespace: FunctionalUUIDNamespace {
////        .init(className: Self.self)
////    }
////    
////    public var namespace: FunctionalUUIDNamespace {
////        Self.namespace
////    }
////    
////}
//
////extension FunctionalUUIDNamespaceProviding {
////    
////    public typealias Namespace = FunctionalUUIDNamespace
////    
////    public static var namespace: Namespace {
////        .getNamespaceForProvider(provider: Self.self)
////    }
////    
////    public var namespace: Namespace {
////        Self.namespace
////    }
////    
////}
