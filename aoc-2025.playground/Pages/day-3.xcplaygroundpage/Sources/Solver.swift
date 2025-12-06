import Foundation

public struct Solver {    
    private static func maxJoltage(bank: [Int], battery: Int, joltage: Int = 0) -> Int {
        if battery == 0 { return joltage }
        let rating = bank[0...(bank.count - (battery))].max()
        let start = bank.firstIndex(of: rating!)! + 1
        return maxJoltage(bank: Array(bank[start...]), battery: battery - 1, joltage: joltage * 10 + rating!);
    };
    
    public static func solve(data: [String], second: Bool = false) -> Int {
        var batteries: [Int] = []
        for line in data {
            guard line.count > 1 else { continue }
            var structured: [[Int]] = []
            var index = 0
            for c in line.split(separator: "") {
                structured.append([index, Int(c)!])
                index += 1
            }
            
            let maxJolts = maxJoltage(bank: structured.map { $0[1]}, battery: (second ? 12 : 2), joltage: 0);
            batteries.append(maxJolts)
        }
        
        return batteries.reduce(0, +)
    }
}
