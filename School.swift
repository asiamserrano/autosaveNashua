//
//  School.swift
//  autosaveBeta
//
//  Created by Asia Serrano on 3/4/26.
//

import Foundation
import Core
import SwiftData
import SwiftUI


public protocol PersonProtocol: PersistentModel, ClassNameProviding {
    associatedtype T: View
    var MyView: T { get }
    var fullName: String { get }
}

public protocol FinalPersonProtocol: PersonProtocol {
    static func random(info: Info) -> Self
}

public enum People: Enumerable {
    case student, teacher, driver
    
    func random(_ info: Info) -> any FinalPersonProtocol {
        switch self {
        case .student:
            Student.random(info: info)
        case .teacher:
            Teacher.random(info: info)
        case .driver:
            BusDriver.random(info: info)
        }
    }
    
    var count: Int {
        switch self {
        case .student:
            50
        case .teacher:
            8
        case .driver:
            6
        }
    }
    
}

public enum Neighborhood: Enumerable {
    case cumberland, newfolk, brooks, shire, applegate, pinecrest, edmonton
}

//public enum Shifts: Enumerable {
//    case morning, afternoon
//}

public enum Subjects: Enumerable {
    case history, math, reading, biology
}

public enum Grades: Enumerable {
    case ninth, tenth, eleventh, twelfth
    
    var number: Int {
        self.index + 9
    }
    
    public var rawValue: String {
        "\(self.number)th"
    }
    
}

public struct Info: Defaultable, Hashable {
    
    public static var defaultValue: Info { .init() }
    
    let first: String
    let last: String
    let num: Int
    
    private init() {
        self.first = .defaultValue
        self.last = .defaultValue
        self.num = .zero
    }
    
    init(name: String) {
        let parts = name.split(separator: " ")
        self.first = String(parts[0]).trimmed
        self.last = String(parts[1]).trimmed
        self.num = Int.random(in: 100...999)
    }
    
    var id: String {
        let f = first.canonicalized.prefix(1)
        let l = last.canonicalized.prefix(4)
        return "\(f)\(l)\(num)".lowercased()
    }
    
}

@Model @available(iOS 26.0, *)
public class Person: PersonProtocol {
    
    public private(set) var firstName: String = String.defaultValue
    public private(set) var lastName: String = String.defaultValue
    
    init(info: Info) {
        self.firstName = info.first
        self.lastName = info.last
    }
    
    public var fullName: String { "\(firstName) \(lastName)" }
    
    @ViewBuilder
    public var MyView: some View {
        if let student = self as? Student {
            Section(fullName) {
                SpacedLabel("StudentId", student.studentId)
                SpacedLabel("Grade", student.grade)
            }
        } else if let driver = self as? BusDriver {
            Section(fullName) {
                SpacedLabel("StaffId", driver.staffId)
                SpacedLabel("Bus", driver.bus.description)
            }
        } else if let teacher = self as? Teacher {
            Section(fullName) {
                SpacedLabel("StaffId", teacher.staffId)
                SpacedLabel("Grade", teacher.grade)
                SpacedLabel("Subject", teacher.subject)
            }
        }
        else {
            Text(self.fullName)
        }
    }
    
}

@Model @available(iOS 26.0, *)
public class Staff: Person {
        
    public private(set) var staffId: String = String.defaultValue
    
    override init(info: Info) {
        self.staffId = info.id
        super.init(info: info)
    }

}

public protocol NeighborhoodProtocol: FinalPersonProtocol {
    var neighborhood: String { get }
}

extension NeighborhoodProtocol {
    
    public func filter(_ n: Neighborhood) -> Bool {
        self.neighborhood == n.rawValue
    }
    
}

public protocol GradeProtocol: FinalPersonProtocol {
    var grade: String { get }
}

extension GradeProtocol {
    
    public func filter(_ g: Grades) -> Bool {
        self.grade == g.rawValue
    }
    
}

public protocol StudentContaining: FinalPersonProtocol {
    var students: [Student] { get }
}

@Model @available(iOS 26.0, *)
public final class Teacher: Staff, GradeProtocol, StudentContaining {
    
    public static func random(info: Info) -> Self {
        .init(info: info, subject: .random, grade: .random)
    }
    
    public private(set) var students: [Student] = []
    
    var subject: String = String.defaultValue
    public var grade: String = String.defaultValue
    
    public init(info: Info, subject: Subjects, grade: Grades) {
        self.subject = subject.rawValue
        self.grade = grade.rawValue
        super.init(info: info)
    }
    
    func addStudent(_ student: Student) -> Void {
        self.students.insert(student)
    }
    
}

@Model @available(iOS 26.0, *)
public final class BusDriver: Staff, NeighborhoodProtocol, StudentContaining {
    
    public static func random(info: Info) -> Self {
        .init(info: info, neighborhood: .random)
    }
    
    public private(set) var students: [Student] = []
    
    var bus: Int = Int.zero
    public var neighborhood: String = String.defaultValue
    
    init(info: Info, neighborhood: Neighborhood) {
        self.bus = Int.random(in: 1000...9999)
        self.neighborhood = neighborhood.rawValue
        super.init(info: info)
    }
    
    func addStudent(_ student: Student) -> Void {
        self.students.insert(student)
    }
    
}

@Model @available(iOS 26.0, *)
public final class Student: Person, NeighborhoodProtocol, GradeProtocol {
    
    public static func random(info: Info) -> Self {
        .init(info: info, grade: .random, neighborhood: .random)
    }
    
    public private(set) var studentId: String = String.defaultValue
    public private(set) var grade: String = String.defaultValue
    public private(set) var neighborhood: String = String.defaultValue
    
    @Relationship(inverse: \Teacher.students)
    public private(set) var teachers: [Teacher] = []

    @Relationship(inverse: \BusDriver.students)
    public private(set) var busDriver: BusDriver? = nil
    
    public init(info: Info, grade: Grades, neighborhood: Neighborhood) {
        self.grade = grade.rawValue
        self.studentId = info.id
        self.neighborhood = neighborhood.rawValue
        super.init(info: info)
    }
    
    public func addTeacher(_ teacher: Teacher?) -> Void {
        if let teacher = teacher { self.teachers.insert(teacher) }
    }
    
    public func setBusDriver(_ driver: BusDriver?) -> Void {
        if let driver = driver { self.busDriver = driver }
    }

}

public struct School: View {
    
    @Environment(\.modelContext) public var modelContext
    
    @State public var grade: Grades = .defaultValue
   
    public var body: some View {
        NavigationStack {
            Form {
               Picker("Picker", selection: $grade, content: {
                   ForEach(Grades.cases) { grade in
                       Text(grade.rawValue).tag(grade)
                   }
               }).pickerStyle(.segmented)
                StudentsView(grade)
            }
        }
    }
    
    private struct StudentsView: View {
        
        @Query var students: [Student]
        
        let section: String
        
        init(_ grade: Grades) {
            let raw = grade.rawValue
            let predicate = #Predicate<Student> { $0.grade == raw }
            let fetch = FetchDescriptor(predicate: predicate)
            self._students = .init(fetch)
            self.section = "\(raw) Grade Students"
        }
        
        var body: some View {
            Section(section) {
                ForEach(students) {
                    Text($0.fullName)
                }
            }
        }
    }
    
    private struct SchoolView: View {
        
        @Environment(\.modelContext) public var modelContext

        @Query var students: [Student]
        @Query var teachers: [Teacher]
        @Query var drivers: [BusDriver]
        
        @State public var people: People = .defaultValue
       
        var body: some View {
            NavigationStack {
                Form {
                    Picker("Picker", selection: $people, content: {
                        ForEach(People.cases) { Text($0.rawValue).tag($0) }
                    }).pickerStyle(.segmented)
                    
                    switch people {
                    case .student:
                        PeopleView(students)
                    case .teacher:
                        PeopleView(teachers)
                    case .driver:
                        PeopleView(drivers)
                    }
                }
            }
        }
        
    }
    
}

public extension View {
    
    @ViewBuilder
    func PeopleView<T: FinalPersonProtocol>(_ t: [T]) -> some View {
        ForEach(t, content: \.MyView)
    }
    
}

#Preview {
    
    School()
//        .modelContainer(.school)
    
//    func buildInstances<T: FinalPersonProtocol>(_ num: Int) -> [T] {
//        
//    }
//    
//    let previewModelContainer: ModelContainer = {
//        let container: ModelContainer = .preview
//        let list = RandomizedArray<String>(loadFileAsStrings(filePath: NAMES_FILE_PATH))
//        if list.isNotEmpty {
//            
//            People.cases.forEach { people in
//                people.count.forEach(action: {
////                    let index = getRandomIndex(map, count)
//                    let name = list.get()
//                    let info = Info(name: name)
//                    let person = people.random(info)
//                    container.mainContext.save(person)
////                    map[index] = true
//                })
//            }
////            
////            10.forEach {
////                let index = getRandomIndex(map, count)
////                let info = Info(name: list[index])
////                let student = Student(info: info, grade: .random)
////                container.mainContext.save(student)
////                map[index] = true
////            }
//        }
//        
//        return container
//    }()
//
//    return School()
//        .modelContainer(previewModelContainer)
    
}

public extension ModelContext {
    
    func save<T: PersistentModel>(_ t: T) -> Void {
        self.insert(t)
        try? self.save()
    }
    
}
