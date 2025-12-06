import Foundation

public struct Solver {
    public static func solve2(data: [String]) -> Int {
        var output: Int = 0
        var columns: [String] = []
        var problems: [[Int]] = []
        var operations: [String] = []
        for (iter, line) in data.enumerated() {
            let row = Array(line.split(separator: "").reversed())
            if iter == 0 {
                for _ in 0..<row.count {
                    columns.append("")
                }
            }
            if iter == data.count - 1 {
                operations = Array((line.split(separator: " ").map(String.init)).filter { $0.trimmingCharacters(in: .whitespaces).isEmpty == false }.reversed())
            } else {
                for (index, char) in row.enumerated() {
                    columns[index] += char
                }
            }
        }
        
        var set: [Int] = []
        for (index, column) in columns.enumerated() {
            if column.trimmingCharacters(in: .whitespaces).isEmpty{
                problems.append(set)
                set = []
            } else {
                set.append(Int(column.trimmingCharacters(in: .whitespaces))!)
            }
        }
        problems.append(set)
        for (index, operation) in operations.enumerated() {
            print(problems[index], operation)
            switch operation {
                case "+":
                    let result = problems[index].reduce(0, +)
                    output += result
                case "*":
                    let result = problems[index].reduce(1, *)
                    output += result
                default:
                    print("Unknown Operation Found: \(operation)")
                    exit(1)
            }
        }
        
        return output
    }
    
    public static func solve(data: [String], second: Bool = false) -> Int {
        if (second) {
            return solve2(data: data)
        }
        
        var output: Int = 0
        var problems: [[Int]] = []
        var operations: [String] = []
        for (iter, line) in data.enumerated() {
            let row = line.split(separator: " ").map(String.init).filter { $0.isEmpty == false }
            for _ in 0..<row.count {
                problems.append([])
            }
            if iter == data.count - 1 {
                operations = row
            } else {
                for (index, number) in row.enumerated() {
                    problems[index].append(Int(number)!)
                }
            }
        }
        
        for (index, operation) in operations.enumerated() {
            switch operation {
                case "+":
                    let result = problems[index].reduce(0, +)
                    output += result
                case "*":
                    let result = problems[index].reduce(1, *)
                    output += result
                default:
                    continue
            }
        }
        
        return output
    }
    
}
