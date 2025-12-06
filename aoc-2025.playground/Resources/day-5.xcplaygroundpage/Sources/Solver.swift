import Foundation

public struct Solver {
    // Implement your solving algoritm here. I reocmmend accepting data as an input to the function so you can
    // run the examples as well as the real challenge.
    
    // public static func solve(data: [[Int]]) -> Int
    
    public static func solve(data: [String], second: Bool = false) -> Int {
        var fresh: [[Int]] = [];
        var counter: Int = 0;
        for line in data {
            if line.contains("-") {
                let range = line.split(separator: "-")
                let start = Int(range[0])!
                let end = Int(range[1])!
                fresh.append([start, end])
            } else if !second {
                for range in fresh {
                    if Int(line)! >= range[0] && Int(line)! <= range[1] {
                        counter += 1
                        break
                    }
                }
            }
        }
        
        if second {
            var deduplicated: [[Int]] = [];
            for range in fresh.sorted(by: { $0[0] < $1[0] }) {
                if deduplicated.isEmpty || range[0] > deduplicated.last![1] + 1 {
                    deduplicated.append(range)
                } else {
                    let lastRange = deduplicated.removeLast()
                    let newUpperBound = max(lastRange[1], range[1])
                    let deduplicate = [lastRange[0], newUpperBound]
                    deduplicated.append(deduplicate)
                }
            }
            for range in deduplicated {
                counter += (range[1] - range[0]) + 1
            }
        }
        
        return counter
    }
}
