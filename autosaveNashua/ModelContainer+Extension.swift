////
////  ModelContainer+Extension.swift
////  autosaveBeta
////
////  Created by Asia Serrano on 3/3/26.
////
//
//import Foundation
//import Core
//import SwiftData
//
//extension ModelContainer {
//    
////    private static let STORE_PATH = "/Users/asiaserrano/xcode/autosaveBeta/PreviewStores"
//    
//    private static let PREVIEW_STORES_DIR_PATH = "\(APP_DIRECTORY)/PreviewStores"
//    
//    private static func createStoreURL(_ name: String) -> URL {
//        let storeName = "\(name)PreviewStore"
//        let filePath = "\(PREVIEW_STORES_DIR_PATH)/\(storeName).sqlite"
//
//        if FileManager.default.fileExists(atPath: filePath) {
//            print("File at: '\(filePath)' already exists. Skipping creation.")
//        } else {
//            let success = FileManager.default.createFile(atPath: filePath, contents: nil)
//            if success {
//                print("File created successfully at: \(filePath)")
//            } else {
//                print("Failed to create file at: \(filePath)")
//            }
//        }
//        
//        return URL(fileURLWithPath: filePath)
//    }
//    
//    public static func forType(_ name: String, types: [any PersistentModel.Type]) -> ModelContainer {
//        do {
//            let url = createStoreURL(name)
//            let schema: Schema = .init(types)
//            let config = ModelConfiguration(url: url)
//            let container: ModelContainer = try .init(for: schema, configurations: config)
//            container.mainContext.autosaveEnabled = false
//            container.mainContext.undoManager = .init()
//            return container
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }
//    
//    public static func forType<T: PersistentModel>(_ type: T.Type) -> ModelContainer {
//        let storeName = String(describing: type)
//        return forType(storeName, types: [type])
//    }
//    
//    public static var preview: ModelContainer {
//        let container: ModelContainer = .init(memory: true, models: [
////            Record.self, Foo.self, SuperClass.self, MyClass.self,
//            Person.self, Staff.self, Teacher.self, BusDriver.self, Student.self
//        ])
//        
//        container.mainContext.autosaveEnabled = false
//        container.mainContext.undoManager = .init()
//        
//        return container
//    }
//    
//    public static var school: ModelContainer {
//        let container: ModelContainer = .init(memory: true, models: [
//            Person.self, Staff.self, Teacher.self, BusDriver.self, Student.self
//        ])
//        
//        container.mainContext.autosaveEnabled = false
//        container.mainContext.undoManager = .init()
//        
//        return SchoolModelContainerLoader.load(container)
//    }
//    
//}
//
//extension ModelContainer {
//    
//    public func save() -> Void {
//        try? self.mainContext.save()
//    }
//   
//    public func insert<T: PersistentModel>(_ model: T?) {
//        if let model = model {
//            self.mainContext.insert(model)
//            self.save()
//        }
//    }
//    
////    private func build<T: FinalPersonProtocol>(_ people: People, _ info: Info) -> T? {
////        let model: T? = {
////            switch people {
////            case .student:
////                return Student.random(info: info) as? T
////            case .teacher:
////                return Teacher.random(info: info) as? T
////            case .driver:
////                return BusDriver.random(info: info) as? T
////            }
////        }()
////        
////        insert(model)
////        return model
////    }
////    
////    private func build<T: FinalPersonProtocol>(_ people: People, _ names: RandomizedArray<String>) -> FinalPersonGroup<T> {
////        var group: FinalPersonGroup<T> = .init()
////        while group.count < people.count {
////            let info = Info(name: names.get())
////            let model: T? = build(people, info)
////            group.insert(model)
////        }
////        return group
////    }
//// 
//        
//}
