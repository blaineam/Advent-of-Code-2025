import Foundation

public struct Solver {
    public static func operateShift(map: [[String]], modMap: inout [[String]]) -> Int {
        let grid = Grid(data: map)
        var upgrid = Grid(data: grid.data)
        let output = grid.allCoordinates().filter {
            let result = grid.neighbors(of: $0).filter { $0.value == "@"}.count < 4 && grid.data[$0.y][$0.x] == "@"
            if result {
                upgrid.data[$0.y][$0.x] = "X"
            }
            return result
        }.count
        
        print(upgrid.data.map { $0.joined() }.joined(separator: "\n"))
        modMap = upgrid.data
        return output
    }
    
    public static func solve(data: [String], second: Bool = false) -> Int {
        let map: [[String]] = data.map { $0.split(separator: "").map { String($0) as String } }
        var modMap: [[String]] = data.map { $0.split(separator: "").map { String($0) as String } }
        var removals: Int = 0
        while true {
            let removed = operateShift(map: modMap, modMap: &modMap)
            guard removed > 0 else { break }
            removals += removed
        }
        
        return removals
    }
}
