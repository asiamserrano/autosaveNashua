//
//  SchoolModelContainerLoader.swift
//  autosaveBeta
//
//  Created by Asia Serrano on 3/7/26.
//

import Foundation
import Core
import SwiftData
import SwiftUI

public class RandomizedArray<T> {
    
    private let array: [T]
    private var tracker: [Int: Bool]
        
    public init(_ array: [T]) {
        self.array = array
        self.tracker = .init(uniqueKeysWithValues: array.indices.map { ($0, true) })
    }
    
    public func get() -> T {
        let index = Int.random(in: 0..<count)
        if let available = tracker[index], available {
            let t = array[index]
            self.tracker[index] = false
            return t
        } else { return get() }
    }
    
    public var count: Int { self.array.count }
    public var isNotEmpty: Bool { self.count > 0 }
    
}

public class FinalPersonGroup<T: FinalPersonProtocol> {
    
    var set: Set<T>
    
    init() {
        self.set = .defaultValue
    }
    
    init(_ array: [T]) {
        self.set = .init(array)
    }
    
    func add(_ t: T) -> FinalPersonGroup {
        self.insert(t)
        return self
    }
    
    func insert(_ t: T?) -> Void {
        if let t = t {
            self.set.insert(t)
        }
    }
    
    func insert(_ s: FinalPersonGroup) -> Void {
        s.set.forEach {
            self.insert($0)
        }
    }
    
    func random() -> T? {
        if count > 0, let element = set.randomElement() {
            return element
        } else { return nil }
    }
    
    func forEach(_ action: @escaping (T) -> Void) -> Void {
        self.set.forEach(action)
    }
    
    var count: Int { self.set.count }
    var array: [T] { .init(set) }
    
    func matrix(_ sizes: [Int]) -> [[T]] {
        var subs: [[T]] = .defaultValue
        var prev: Int = 0
        var curr: Int
        for index in 0..<sizes.count {
            let size = sizes[index]
            curr = prev+size
            let result: [T] = array[prev..<curr].toArray
            prev = curr
            subs.append(result)
        }
        return subs
    }
    
    var names: [String] {
        array.map { $0.fullName }.sorted()
    }
    
}

public class SchoolModelContainerLoader {
    
    private static let BUS_SIZE: Int = 48
            
    private typealias Students = FinalPersonGroup<Student>
    private typealias Teachers = FinalPersonGroup<Teacher>
    private typealias Drivers = FinalPersonGroup<BusDriver>
    
    public static func load(_ container: ModelContainer) -> ModelContainer {
        let names: RandomizedArray = .init(String.random_names)
        
        let maxBusSize = 48;
        let minBusSize = 20;
        let numOfGrades = Grades.cases.count;
        
        var studentGrades: [Grades: Students] = [:]
        
        Neighborhood.cases.forEach { neighborhood in
            
            let numOfBuses = Int.random(in: 1..<5)// Number of elements
            let minNumOfStudents = numOfBuses * minBusSize;
            let maxNumOfStudents = (numOfBuses * maxBusSize) + 1;
            let numOfStudents = Int.random(in: minNumOfStudents..<maxNumOfStudents); // Target sum
            
//            let busDist = generateRandomNumbers(numOfStudents, numOfBuses, minBusSize, maxBusSize, "buses");
//            let gradeDist = generateRandomNumbers(numOfStudents, numOfGrades, 1, numOfStudents - 2, "students");
            
            let busDist = generateRandomNumbers(targetSum: numOfStudents, count: numOfBuses, minExclusive: minBusSize, maxExclusive: maxBusSize, "buses")
            let gradeDist = generateRandomNumbers(targetSum: numOfStudents, count: numOfGrades, minExclusive: 1, maxExclusive: numOfStudents - 2, "students")

            
//            print("Students on each bus: \(busDist)");
//            print("Students in each grade: \(gradeDist)");
     
            let students: Students = .init()
            for index in 0..<gradeDist.count {
                let grade = Grades.cases[index]
                let count = gradeDist[index]
                count.forEach {
                    let info = Info(name: names.get())
                    let student = Student(info: info, grade: grade, neighborhood: neighborhood)
//                    print("inserting student")
                    container.insert(student)
                    students.insert(student)
                    
                    let value = studentGrades[grade] ?? .init()
                    studentGrades[grade] = value.add(student)
                    
                }
            }
            
//            print("students count: \(students.count)")
//            print("students: [\(studentsString)]")
            
            
//            studentGrades.forEach { grade, s in
//                let studentsString = s.set.map { $0.fullName }.joined(separator: ", ")
//                print("\(grade.rawValue) Grade:\n[\(studentsString)]")
//            }
            

            let studentMatrix = students.matrix(busDist)
            
//            studentMatrix.indices.forEach { index in
//                let studentsString = studentMatrix[index].map { $0.fullName }.joined(separator: ", ")
//                print("Bus \(index+1):\n[\(studentsString)]")
//            }
            
            let drivers: Drivers = .init()
            studentMatrix.forEach { array in
                let info = Info(name: names.get())
                let driver = BusDriver(info: info, neighborhood: neighborhood)
                container.insert(driver)
                drivers.insert(driver)
                array.forEach { $0.setBusDriver(driver) }
            }
            
        }
        
        let minClassSize = 12
        let maxClassSize = 36
        let teachers: Teachers = .init()
        
        studentGrades.forEach { grade, students in
            let numOfStudents = students.count
            let minNumOfTeachers =  (numOfStudents / maxClassSize) + 1
            let maxNumOfTeachers = minNumOfTeachers + 4
            
            Subjects.cases.forEach { subject in
                let numOfTeachers = Int.random(in: minNumOfTeachers...maxNumOfTeachers)
                let teachersDist = generateRandomNumbers(targetSum: numOfStudents, count: numOfTeachers, minExclusive: minClassSize, maxExclusive: maxClassSize, "teachers")

//                let teachersDist = generateRandomNumbers(numOfStudents, numOfTeachers, minClassSize, maxClassSize, "classes")
                let studentMatrix = students.matrix(teachersDist)
                studentMatrix.forEach { array in
                    let info = Info(name: names.get())
                    let teacher = Teacher(info: info, subject: subject, grade: grade)
                    container.insert(teacher)
                    teachers.insert(teacher)
                    array.forEach { $0.addTeacher(teacher) }
                }
            }
        }
        
        container.save()
        return container
    }
    
    private static func generateRandomNumbers(
        targetSum: Int,
        count: Int,
        minExclusive: Int,
        maxExclusive: Int,
        _ seed: String
    ) -> [Int] {
        // 1. Validation: Check if a solution is mathematically possible
        let minVal = minExclusive + 1
        let maxVal = maxExclusive - 1
        
        let absoluteMinSum = minVal * count
        let absoluteMaxSum = maxVal * count
        
        guard targetSum >= absoluteMinSum && targetSum <= absoluteMaxSum else {
            print("Error: Target sum is unreachable with the given count and bounds for seed: \(seed)")
            return .defaultValue
        }

        // 2. Initialize array with minimum values
        var result = Array(repeating: minVal, count: count)
        var remainingToDistribute = targetSum - absoluteMinSum
        
        // 3. Distribute the remainder randomly
        while remainingToDistribute > 0 {
            let randomIndex = Int.random(in: 0..<count)
            
            // Calculate how much more this specific index can hold
            let currentVal = result[randomIndex]
            let spaceLeft = maxVal - currentVal
            
            if spaceLeft > 0 {
                // Pick a random chunk to add (at least 1, at most spaceLeft or remaining)
                let addition = Int.random(in: 1...min(spaceLeft, remainingToDistribute))
                result[randomIndex] += addition
                remainingToDistribute -= addition
            }
        }
        
        return result.shuffled() // Shuffle to remove any distribution bias
    }

//    private static func generateRandomNumbers(_ n: Int, _ count: Int, _ m: Int, _ k: Int, _ seed: String) -> [Int] {
//
//          let min = count * m;
//          let max = count * k;
//
//          let nTooSmall = n < min;
//          let nTooBig = n > max;
//
//          // Check if the target sum is feasible
//          if (nTooSmall || nTooBig) {
//              print("    seed: \(seed)")
//              print("    minAllowed: \(m)")
//              print("    maxAllowed: \(k)")
//              var s: String;
//              if (nTooSmall) { s = "       min sum '\(min)' is bigger than '\(n)'" }
//              else  { s = "       max sum '\(max)' is smaller than '\(n)'" }
//              print("\(s) for \(seed)");
//              return .defaultValue;
//          }
//
//        var numbers: [Int] = .defaultValue
//          var remainingSum = n;
//          var remainingCount = count;
//        
//        (count - 1).forEach {
//            // Calculate the minimum and maximum possible values for the current number
//            let currentMin: Int = Swift.max(m, remainingSum - (remainingCount - 1) * k);
//            let currentMax = Swift.min(k, remainingSum - (remainingCount - 1) * m);
//
//            // Generate a random number within the adjusted range [currentMin, currentMax]
//            // Formula: rand.nextInt(max - min + 1) + min
//            let randomNum = Int.random(in: 0..<currentMax - currentMin + 1) + currentMin
//
//            numbers.append(randomNum)
//            remainingSum = remainingSum - randomNum
//            remainingCount = remainingCount - 1
//        }
//        
//          // The last number is determined by the remaining sum to ensure the total sum is n
//          numbers.append(remainingSum);
//
//          return numbers;
//      }
    
//    private static func getNumbersForNeighborhood(_ n: Neighborhood) -> [Int] {
//        
//        let neighborhood = n.rawValue
//        print("neighborhood: \(neighborhood)");
//        let maxBusSize = 48;
//        let minBusSize = 20;
//        let numOfGrades = Grades.cases.count;
//        
//        let numOfBuses = Int.random(in: 1..<5)// Number of elements
//        print("# of buses for neighborhood: \(numOfBuses)");
//        let minNumOfStudents = numOfBuses * minBusSize;
//        print("min # of students: \(minNumOfStudents)");
//        let maxNumOfStudents = (numOfBuses * maxBusSize) + 1;
//        print("max # of students: \(maxNumOfStudents)");
//        let numOfStudents = Int.random(in: minNumOfStudents..<maxNumOfStudents); // Target sum
//        print("total # of students in neighborhood: \(numOfStudents)");
//        
//        
//        let busDist = generateRandomNumbers(targetSum: numOfStudents, count: numOfBuses, minExclusive: minBusSize, maxExclusive: maxBusSize)
//        let gradeDist = generateRandomNumbers(targetSum: numOfStudents, count: numOfGrades, minExclusive: 1, maxExclusive: numOfStudents - 2)
//
////        let busDist = generateRandomNumbers(numOfStudents, numOfBuses, minBusSize, maxBusSize, "buses");
////        let gradeDist = generateRandomNumbers(numOfStudents, numOfGrades, 1, numOfStudents - 2, "students");
//        
//        print("Students on each bus: \(busDist)");
//        print("Students in each grade: \(gradeDist)");
//        
//        return gradeDist
//    }
    
//    public static func getNumbersForNeighborhoods() -> [String] {
//        
//        let minClassSize = 12
//        let maxClassSize = 36
//        
//        var grades: [Grades: Int] = [:]
//        
//        let result: [String] = Neighborhood.cases.map { neighborhood in
//            let gradesCount = getNumbersForNeighborhood(neighborhood)
//            for index in 0..<Grades.cases.count {
//                let grade = Grades.cases[index]
//                let count = gradesCount[index]
//                let value = grades[grade] ?? .zero
//                grades[grade] = value + count
//            }
//            return neighborhood.rawValue
//        }
//        
//        print("\n_______________________________\n");
//        Subjects.cases.forEach { subject in
////            print("subject: \(subject.rawValue)");
//            grades.forEach { grade, numOfStudents in
//                
//                let minNumOfTeachers =  (numOfStudents / maxClassSize) + 1
//                let maxNumOfTeachers = minNumOfTeachers + 4
//                let numOfTeachers = Int.random(in: minNumOfTeachers...maxNumOfTeachers)
//                let result = generateRandomNumbers(numOfStudents, numOfTeachers, minClassSize, maxClassSize, "classes");
//                print("# of \(grade.rawValue) grade \(subject.rawValue) Teachers: \(numOfTeachers) -> \(result) (\(numOfStudents))");
//            }
//        }
//        print("\n_______________________________\n");
//        
//        return result
//    }
    
}

extension ArraySlice {
    
    var toArray: Array<Element> {
        .init(self)
    }
    
}

struct SchoolModelContainerLoaderView: View {
    
    @Environment(\.modelContext) public var modelContext

    @Query var students: [Student]
    @Query var teachers: [Teacher]
    @Query var drivers: [BusDriver]
    
    enum Options: Enumerable {
        case students, teachers, drivers
    }
    
    @State var option: Options = .defaultValue
    @State var grade: Grades = .defaultValue
    @State var neighborhood: Neighborhood = .defaultValue

    
    private var optionBinding: Binding<Options> {
        .init(get: {
            self.option
        }, set: { newValue in
            self.option = newValue
            self.grade = .defaultValue
            self.neighborhood = .defaultValue
        })
    }
    
    
    var body: some View {
        NavigationStack {
            Form {
                EnumerablePicker(optionBinding)
                switch option {
                case .students:
                    EnumerablePicker($grade)
                    NeighborhoodPicker()
                    FullNamesView(filterNeighborhood(filterGrade(students)))
                case .teachers:
                    EnumerablePicker($grade)
                    FullNamesView(filterGrade(teachers))
                case .drivers:
                    NeighborhoodPicker()
                    FullNamesView(filterNeighborhood(drivers))
                }
            }
        }
    }
    
    @ViewBuilder
    private func FullNamesView<T: FinalPersonProtocol>(_ t: [T]) -> some View {
        Section {
            ForEach(t.map { $0.fullName }.sorted(), id:\.self) {
                Text($0)
            }
        }
    }
    
    @ViewBuilder
    private func NeighborhoodPicker() -> some View {
        Picker("Neighborhood", selection: $neighborhood, content: {
            ForEach(Neighborhood.cases) { item in
                Text(item.rawValue).tag(item)
            }
        })
        .pickerStyle(.automatic)
    }
    
    @ViewBuilder
    private func EnumerablePicker<T: Enumerable>(_ binding: Binding<T>) -> some View {
        Section(T.classNameShort) {
            Picker("Picker", selection: binding, content: {
                ForEach(T.cases) { item in
                    Text(item.rawValue).tag(item)
                }
            })
            .pickerStyle(.segmented)
//            .conditionalPickerStyle(style)
        }
    }
    
    private func filterGrade<T: GradeProtocol>(_ t: [T]) -> [T] {
        t.filter { $0.filter(grade) }
    }
    
    private func filterNeighborhood<T: NeighborhoodProtocol>(_ t: [T]) -> [T] {
        t.filter { $0.filter(neighborhood) }
    }
    
}

//enum PickerStyle {
//    case segmented, automatic
//}
//
//extension Picker {
//    
//    @ViewBuilder
//    func conditionalPickerStyle( _ style: PickerStyle) -> some View {
//        switch style {
//        case .segmented:
//            self.pickerStyle(.segmented)
//        case .automatic:
//            self.pickerStyle(.automatic)
//        }
//    }
//    
//}

#Preview {
    
    SchoolModelContainerLoaderView()
        .modelContainer(.school)
    
}
