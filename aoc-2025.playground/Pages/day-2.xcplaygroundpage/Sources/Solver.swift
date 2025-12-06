import Foundation

public struct Solver {
    public static func repeatingSequence(_ num: Int) -> Bool {
        let s = String(abs(num))
        let patternLength = s.count / 2
        if patternLength == 0 || s.count == 0 {
            return false
        }
        if s.count % 2 == 0 {
            let patternStartIndex = s.startIndex
            let patternEndIndex = s.index(patternStartIndex, offsetBy: patternLength)
            let pattern = String(s[patternStartIndex..<patternEndIndex])
            let repeatedString = String(repeating: pattern, count: s.count / patternLength)
            if repeatedString == s {
                return true
            }
        }
        return false
    }
    
    public static func repeatingSequence2(_ num: Int) -> Bool {
        let s = String(abs(num))
        guard (s.count / 2) > 0 else { return false }
        for patternLength in 1...(s.count / 2) {
            if s.count % patternLength == 0 {
                let patternStartIndex = s.startIndex
                let patternEndIndex = s.index(patternStartIndex, offsetBy: patternLength)
                let pattern = String(s[patternStartIndex..<patternEndIndex])
                let repeatedString = String(repeating: pattern, count: s.count / patternLength)
                if repeatedString == s {
                    return true
                }
            }
        }
        return false
    }
    
    public static func solve(data: [String], second: Bool = false) -> Int {
        var passes: [Int] = []
        var sum: Int = 0
        for line in data {
            guard line.contains("-") else { continue; }
            let lineSplit = line.split(separator: "-").map(String.init)
            let start = Int(lineSplit[0])!
            let end = Int(lineSplit[1])!
            guard start < end else { continue }
            for num in start...end {
                if second && repeatingSequence2(num) {
                        passes.append(num);
                        sum += num
                } else if repeatingSequence(num) {
                    passes.append(num);
                    sum += num
                }
            }
        }
        
        return sum
    }
}
