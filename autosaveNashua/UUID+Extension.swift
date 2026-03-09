//
//  UUID+Extension.swift
//  autosaveNashua
//
//  Created by Admin on 3/8/26.
//

import Foundation
import CryptoKit
import Core

extension UUID {
    
    private static let defaultValueUUIDString = "00000000-0000-0000-0000-000000000000"
    private static let classNameUUIDString = "91B2D41E-8990-427D-9E55-6310918C9D39"

    private struct UUIDStrings {
        
        fileprivate static let defaultValue = UUIDStrings(rawValue: defaultValueUUIDString)
        fileprivate static let className = UUIDStrings(rawValue: classNameUUIDString)
        
        public let rawValue: String
        
    }
            
    public struct Namespace: UUIDNamespacing {
  
        fileprivate static let defaultValue = Namespace(.defaultValue)
        fileprivate static let className = Namespace(.className)
        
        fileprivate let uuidTuple: UUID.Tuple
        public let uuidString: String
        
        public init<T: TypeMetadataProviding>(className t: T.Type) {
            self.init(.className, t)
        }
        
        private init<T: TypeMetadataProviding>(_ ns: Self, _ t: T.Type) {
            let uuid: UUID = .init(namespace: ns, name: t.absoluteName.asArray)
            self.init(uuid: uuid)
        }

        private init(uuid: UUID) {
            self.uuidTuple = uuid.uuid
            self.uuidString = uuid.uuidString
        }
        
        private init(_ uuidString: UUIDStrings) {
            if let uuid: UUID = .init(uuidString: uuidString.rawValue) {
                self.init(uuid: uuid)
            } else {
                let error = "Error casting uuidString '\(uuidString)' to UUID Namespace"
                print(error)
                fatalError(error)
            }
        }
        
        public func uuid(mask: UInt8, _ strings: String...) -> UUID {
            .init(namespace: self, name: strings, version: mask)
        }
                
    }
    
    private init(namespace: Namespace, name: any Collection<String>, version: UInt8? = nil) {
        // 1) Get namespace bytes in network byte order (big-endian)
        var ns = namespace.uuidTuple
        var dataBytes = withUnsafeBytes(of: &ns) { Data($0) }
        
        // 2) Append name bytes
        dataBytes.append(name.data)
        
        // 1) Hash the UTF-8 bytes of the string
        let digest = Insecure.MD5.hash(data: dataBytes)
        var bytes = Data(digest) // 16 bytes
        
        // 3) Use functional version/variant bits (RFC 4122)
        let version = version ?? .defaultValue
        bytes[6] = (bytes[6] & 0x0F) | version  // version
        bytes[8] = (bytes[8] & 0x3F) | 0x80  // variant = 10xx xxxx
        
        // 4) Build UUID from the 16 bytes
        let uuidTuple = bytes.withUnsafeBytes { rawPtr -> uuid_t in
            let p = rawPtr.bindMemory(to: UInt8.self).baseAddress!
            return (p[0], p[1], p[2], p[3], p[4], p[5], p[6], p[7],
                    p[8], p[9], p[10], p[11], p[12], p[13], p[14], p[15])
        }
        
        self.init(uuid: uuidTuple)
    }

}

//extension UUID.Namespace {
//    
//
//
//}
