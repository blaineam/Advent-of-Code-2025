import Foundation

public struct Solver {
    public static func solve(data: [String], second: Bool = false) -> Int {
        var position = 50
        var zeros: Int = 0;
        var index = 0;
        for line in data {
            let newPosition = rotate(position, line: String(line), zeros: &zeros, second: second)
            position = newPosition
            index += 1
        }
        return zeros
    }
    
    static func rotate(_ position: Int, line: String, zeros: inout Int, second: Bool) -> Int {
        let operation = line.prefix(1) == "R" ? 1 : -1
        var steps = Int(String(line.dropFirst()))!
        var zeroIncrements = 0;
        if operation == -1 {
            while position + steps * operation < 0 {
                steps += 100 * operation
                if (second) {
                    zeroIncrements += 1
                }
            }
        } else {
            while position + steps * operation > 99 {
                steps -= 100 * operation
                if (second) {
                    zeroIncrements += 1
                }
            }
        }
        
        if (position + steps * operation) == 0 {
            zeroIncrements += 1
        }
        
        
        if (second) {
            if position == 0 && zeroIncrements > 0 && operation == -1 {
                zeroIncrements -= 1
            }
            
            if position + steps * operation == 0 && zeroIncrements > 0 && operation == 1 {
                zeroIncrements -= 1
            }
        }
        
        
        zeros += zeroIncrements
        
        return position + steps * operation
    }
}
