/// Represents a point on a grid.
///
/// - Note: Instances of this type are not bound to any particular Grid and may be invalid depending on the size of the grid.
///
public struct GridCoordinate: Equatable, Hashable, Sendable, CustomStringConvertible {
    
    /// The origin point of the grid.
    public static let zero = GridCoordinate(x: 0, y: 0)
        
    /// The column (East/West) position of this coordinate.
    public let x: Int
    
    /// The row (North/South) position of this coordinate.
    public let y: Int
    
    /// Create a new instance of GridCoordinate.
    ///
    /// - Parameters:
    ///     - x: The horizontal component of the coordinate.
    ///     - y: The vertical component of the coordinate.
    ///
    public init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    /// Offsets the x and y components of the coordinate by the specified size vector.
    ///
    public func offset(by size: GridSize) -> GridCoordinate {
        GridCoordinate(x: x + size.width, y: y + size.height)
    }
        
    /// Scales the x and y components of the coordinate by the scale value.
    ///
    /// - Parameter scale: The multiplier applied to the x and y components.
    /// - Returns: A new `GridCoordinage` with the scaled components.
    ///
    public func scaled(by scale: Int) -> GridCoordinate {
        GridCoordinate(x: x * scale, y: y * scale)
    }
    
    /// Tests if two GridCoordinates are adjacent.
    ///
    /// - Parameters:
    ///     - other: The other GridCoordinate to test against.
    ///     - allowDiagonalAdjacency: When `true`, coordinates sharing a corner will be considered adjacent.
    ///                               When `false`, only coordinates sharing an edge will be considered adjacent.
    ///
    /// - Returns: `true` if the coordinates are adjacent, otherwise returns `false`.
    ///
    public func isAdjacentTo(_ other: GridCoordinate, allowDiagonalAdjacency: Bool = false) -> Bool {
        
        // A coordinate cannot be adjacent to itself.
        guard self != other else { return false }
        
        let dx = abs(x - other.x)
        let dy = abs(y - other.y)
        
        if allowDiagonalAdjacency {
            return dx <= 1 && dy <= 1
        } else {
            return dx <= 1 && dy == 0 || dx == 0 && dy <= 1
        }
    }
    
    /// Test if two coordinates are adjacent within the same grid row.
    ///
    /// - Parameter other: The other coordinate to test against.
    ///
    /// - Returns: `true` if the coordinates are adjacent, otherwise returns `false`.
    ///
    public func isHorizontallyAdjacentTo(_ other: GridCoordinate) -> Bool {
        // If they're not in the same row, return false.
        guard self.y == other.y else { return false }
        // If the x distance is 0, they're the same point. If it's greater than 1, they don't touch.
        return abs(self.x - other.x) == 1
    }
    
    /// Test if two coordinates are adjacent within the same grid column.
    ///
    /// - Parameter other: The other coordinate to test against.
    ///
    /// - Returns: `true` if the coordinates are adjacent, otherwise returns `false`.
    ///
    public func isVerticallyAdjacentTo(_ other: GridCoordinate) -> Bool {
        // If they're not in the same column, return false.
        guard self.x == other.x else { return false }
        // If the y distance is 0, they're the same point. If it's greater than 1, they don't touch.
        return abs(self.y - other.y) == 1
    }
    
    /// Get the direction from this coordinate to another.
    ///
    /// This will only return a value if:
    ///
    /// * The coordinates are not the same.
    /// * The coordinates are on a vertical, horizontal or 45° line.
    ///
    /// - Parameter other: The other coordinate to get the direction to.
    /// - Returns: A `GridDirection` if the conditions are met, otherwise returns `nil`.
    ///
    public func direction(to other: GridCoordinate) -> GridDirection? {
        let dx = other.x - x
        let dy = other.y - y
        
        if dx == 0 && dy == 0 { return nil }
        else if dx == 0 && dy < 0 { return .n }
        else if dx == 0 && dy > 0 { return .s }
        else if dx < 0 && dy == 0 { return .w }
        else if dx > 0 && dy == 0 { return .e }
        else if dx == dy && dx > 0 { return .se }
        else if dx == dy && dx < 0 { return .nw }
        else if dx == -dy && dx > 0 { return .ne }
        else if dx == -dy && dx < 0 { return .sw }
        return nil
    }

    public var description: String { "(\(x), \(y))" }
    
    // MARK: - Operators
    
    public static func + (lhs: GridCoordinate, rhs: GridCoordinate) -> GridCoordinate {
        GridCoordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    public static func - (lhs: GridCoordinate, rhs: GridCoordinate) -> GridCoordinate {
        GridCoordinate(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func += (lhs: inout GridCoordinate, rhs: GridCoordinate) {
        lhs = lhs + rhs
    }
    
    public static func -= (lhs: inout GridCoordinate, rhs: GridCoordinate) {
        lhs = lhs - rhs
    }
}

/// Designates a heading on the Grid using a compass analogy.
///
/// In this type, the `.n` (North) direction corresponds to up on the screen, or decreasing row indices. The `.e` direction
/// points to the right or increasing column indices. The `.s` direction points down, or increasing row indices. The `.w`
/// direction points to the left, or decreasing column indices. The rest of the cases are 45 degree diagonals between two
/// of the cardinal directions.
///
public enum GridDirection: String, CaseIterable, CustomStringConvertible, Comparable, Sendable {
    
    /// A set of only cardinal (no diagonal) directions.
    ///
    public static let cardinals: [GridDirection] = [.n, .e, .s, .w]
    
    case n, ne, e, se, s, sw, w, nw
    
    /// Get the coordinate offset that will translate into the specified direction.
    public var offset: GridCoordinate {
        switch self {
        case .n:  GridCoordinate(x:  0, y: -1)
        case .ne: GridCoordinate(x:  1, y: -1)
        case .e:  GridCoordinate(x:  1, y:  0)
        case .se: GridCoordinate(x:  1, y:  1)
        case .s:  GridCoordinate(x:  0, y:  1)
        case .sw: GridCoordinate(x: -1, y:  1)
        case .w:  GridCoordinate(x: -1, y:  0)
        case .nw: GridCoordinate(x: -1, y: -1)
        }
    }
    
    public var description: String { self.rawValue.uppercased() }
    
    public var sortOrder: Int {
        switch self {
        case .n: return 0
        case .ne: return 1
        case .e: return 6
        case .se: return 4
        case .s: return 3
        case .sw: return 5
        case .w: return 7
        case .nw: return 2
        }
    }
    
    public var opposite: GridDirection {
        switch self {
        case .n: return .s
        case .ne:return .sw
        case .e: return .w
        case .se: return .nw
        case .s: return .n
        case .sw: return .ne
        case .w: return .e
        case .nw: return .se
        }
    }
    
    public static func < (lhs: GridDirection, rhs: GridDirection) -> Bool {
        lhs.sortOrder < rhs.sortOrder
    }
}

/// Represents a continuous line of Coordinates.
///
/// Currently, this is restricted to lines that are horizontal, vertical, or at a 45 degree
/// diagonal; corresponding to the GridDirections enum. Lines are not tied to any particular
/// Grid and may contain points that are invalid for that grid.
///
public struct GridLine: CustomStringConvertible, Sendable {
    
    /// The starting coordinate of the GridLine.
    public let start: GridCoordinate
    
    /// The direction the line travels away from the start.
    public let direction: GridDirection
    
    /// The length of the line, in grid squares.
    public let length: Int
    
    /// The ending coordinate of the GridLine.
    public var end: GridCoordinate {
        start + direction.offset.scaled(by: length - 1)
    }
    
    /// Create a new instance of GridLine.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate of the GridLine.
    ///     - end: The ending coordinate of the GridLine.
    ///
    public init?(start: GridCoordinate, end: GridCoordinate) {
        guard let dir = start.direction(to: end) else { return nil }
        self.start = start
        self.direction = dir
        self.length = max(abs(end.x - start.x), abs(end.y - start.y)) + 1
    }
    
    /// Create a new instance of GridLine.
    ///
    /// This initializer calculates its end value using the given direction and length.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate for the line.
    ///     - direction: The direction the line travels away from the start.
    ///     - length: The length of the line.
    ///
    public init(start: GridCoordinate, direction: GridDirection, length: Int) {
        self.start = start
        self.direction = direction
        self.length = length
    }
    
    /// Get all coordinates within the line, ordered from `start` to `end`.
    ///
    public var allCoordinates: [GridCoordinate] {
        (0..<length).map { start + direction.offset.scaled(by: $0) }
    }
    
    /// Check if this line intersects another line.
    ///
    /// This check is based on sharing at least one coordinate, it is possible for two diagonal lines not to intersect if
    /// one line starts on an even x and the other starts on odd.
    ///
    /// - Parameter line: The other line to test interaction with.
    /// - Returns: Returns `true` if the lines share at least 1 coordinate, otherwise returns `false`.
    ///
    public func intersects(line: GridLine) -> Bool {
        let locs = Set(allCoordinates)
        let otherLocs = Set(line.allCoordinates)
        return !locs.isDisjoint(with: otherLocs)
    }
    
    public var description: String {
        "GridLine(\(start) -> \(end))"
    }
}

/// A the result of a neighbor search.
///
/// Its generic type will always be the same as the Grid which created it.
///
public struct GridNeighbor<T: Sendable>: CustomStringConvertible, Sendable {
    
    /// The value of the neighbor.
    public let value: T
    
    /// The coordinate of the neighbor within the Grid.
    public let coordinate: GridCoordinate
    
    /// The direction from the starting coordinate in which this neighbor lies.
    public let direction: GridDirection
    
    /// Create a new instance of `GridNeighbor`.
    ///
    /// - Parameters:
    ///     - value: The value of the neighbor coordinate.
    ///     - coordinate: The grid coordinate of the neighbor.
    ///     - direction: The direction this match lies from the starting coordinate.
    ///
    public init(value: T, coordinate: GridCoordinate, direction: GridDirection) {
        self.value = value
        self.coordinate = coordinate
        self.direction = direction
    }
    
    public var description: String { "Neighbor{value: \(value), pos: \(coordinate), dir: \(direction.rawValue)}" }
}

/// An object which represents size, measured in grid squares.
///
public struct GridSize: CustomStringConvertible, Sendable {
    
    /// A GridSize with zero width and height.
    public static let zero = GridSize(width: 0, height: 0)
    
    /// The width of the area, in grid squares.
    public let width: Int
    
    /// The height of the area, in grid squares.
    public let height: Int
    
    public var area: Int { abs(width * height) }
    
    /// Create a new instance of GridSize.
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public var description: String { "GridSize{w: \(width), h: \(height)}"}
}

/// An object which represents a rectangular area of the grid.
///
public struct GridRect: CustomStringConvertible, Sendable {
    /// The origin square of the rect.
    ///
    /// Generally, this would be throught of as the top-left corner. The exception is when
    /// the size contains a negative width or height.
    ///
    public let origin: GridCoordinate
    
    /// The size of the grid.
    public let size: GridSize
    
    public var description: String { "GridRect{x: \(origin.x), y: \(origin.y), w: \(size.width), h: \(size.height)}" }
    
    /// The width of the GridRect.
    public var width: Int { size.width }
    
    /// The height of the GridRect.
    public var height: Int { size.height }
    
    /// Create a new instance of GridRect
    public init(origin: GridCoordinate, size: GridSize) {
        self.origin = origin
        self.size = size
    }
    
    /// The area contained in the GridRect.
    public var area: Int { size.area }
    
    /// Returns a normaized GridRect, where both the width and height are non-negative.
    public var normalized: GridRect {
        let dx = width < 0 ? width : 0
        let dy = height < 0 ? height : 0
        return GridRect(origin: GridCoordinate(x: origin.x + dx, y: origin.y + dy), size: GridSize(width: abs(width), height: abs(height)))
    }
    
    /// Indicates whether or not this GridRect is degenerate because has a zero width or height.
    public var isDegenerate: Bool { width == 0 || height == 0 }
    
    /// Expand the GridRect by adding the specified number of complete rings around it.
    ///
    /// Each ring moves the origin by -1 in the x and y axes and adds 2 to the width and height.
    ///
    /// Will always return a normalized GridRect.
    ///
    public func expanded(by rings: Int) -> GridRect {
        let rect = self.normalized
        return GridRect(origin: GridCoordinate(x: rect.origin.x - rings, y: rect.origin.y - rings), size: GridSize(width: rect.width + 2 * rings, height: rect.height + 2 * rings))
    }
    
    /// Returns all of the coordinates on the outer ring (but still within) the GridRect.
    ///
    /// The returned array of coordinates does not guarantee any particular order.
    ///
    /// If you want the ring *outside* the GridRect, expand it by 1 ring and then get `outerRing`.
    ///
    public var outerRing: [GridCoordinate] {
        guard !isDegenerate else { return [] }
        
        let t = GridLine(start: origin, direction: .e, length: width - 1)
        let r = GridLine(start: t.end.offset(by: GridSize(width: 1, height: 0)), direction: .s, length: height - 1)
        let b = GridLine(start: r.end.offset(by: GridSize(width: 0, height: 1)), direction: .w, length: width - 1)
        let l = GridLine(start: b.end.offset(by: GridSize(width: -1, height: 0)), direction: .n, length: height - 1)
        return [t, r, b, l].flatMap { $0.allCoordinates }
    }
}

/// An object which simplifies interactions with 2D homogenous data arrays.
///
/// This type is designed for both convenience and safety: it provides numerous methods for searching the grid while preventing
/// Array out-of-bounds exceptions.
///
public struct Grid<T: Comparable & Sendable> {
    
    /// An axis to search along.
    public enum SearchType {
        
        /// Will search in a horizontal line (both directions) from the starting point.
        case horizontal
        
        /// Will search in a vertical line (both directions) from the starting point.
        case vertical
    }
    
    /// The underlying Grid data.
    public var data: [[T]]
    
    /// Get the width of the Grid.
    public var width: Int
    
    /// Get the height of the Grid.
    public var height: Int
    
    /// Create a new instance of Grid.
    ///
    /// - Parameter data: The data to base the grid on.
    ///
    /// - Warning: The data object must not be empty and all rows must be the same width.
    ///
    public init(data: [[T]]) {
        guard !data.isEmpty, !data[0].isEmpty else { fatalError("Cannot init with empty data.") }
        self.data = data
        width = data[0].count
        height = data.count
    }
    
    /// Returns the value at the specified coordinate if the coordinate is valid.
    ///
    /// This provides a crash-proof means of accessing values within the grid. It is not possible
    /// to get an out-of-bounds access execption because the validity of the coordinate is
    /// determined prior to array access.
    ///
    /// - Parameter coordinate: The position in the Grid to retrieve the value for.
    /// - Returns: The value at the specified position, or `nil` if the position is invalid.
    ///
    public func value(at coordinate: GridCoordinate) -> T? {
        return isValid(coordinate: coordinate) ? data[coordinate.y][coordinate.x] : nil
    }
    
    public func allCoordinates() -> [GridCoordinate] {
        data.enumerated().reduce(into: []) { partialResult, row in
            let y = row.offset
            let elements: [GridCoordinate] = row.element.enumerated().reduce(into: []) { partialResult, rowItem in
                let x = rowItem.offset
                partialResult.append(GridCoordinate(x: x, y: y))
            }
            partialResult.append(contentsOf: elements)
        }
    }
    
    /// Find all matches of a specific element within the Grid.
    ///
    /// - Parameter match: The element to match within the grid.
    /// - Returns: An array of zero or more coordinates of elements that matched the provided element.
    ///
    public func findAll(_ match: T) -> [GridCoordinate] {
        findAll(matching: { $0 == match })
    }
    
    /// Find all elements in the grid matching a predicate closure.
    ///
    /// - Parameter matching: The comparison closure to test whether the element should be included in results.
    /// - Returns: An array of zero or more coordinates of elements that matched the predicate.
    ///
    public func findAll(matching: (T) -> Bool) -> [GridCoordinate] {
        data.enumerated().reduce(into: []) { partialResult, row in
            let y = row.offset
            let elements: [GridCoordinate] = row.element.enumerated().reduce(into: []) { partialResult, rowItem in
                let x = rowItem.offset
                if matching(rowItem.element) {
                    partialResult.append(GridCoordinate(x: x, y: y))
                }
            }
            partialResult.append(contentsOf: elements)
        }
    }
    
    /// Return neighbors of the specified coordinate.
    ///
    /// This function will only return results from valid Grid coordinates. If the specified coordinate
    /// lies along an edge of the Grid, then neighors will not be returned for directions with coordinates
    /// that fall outside of the Grid.
    ///
    /// - Parameters:
    ///     - coordinate: The coordinate to return neighbors of.
    ///     - allowDiagonals: Whether or not to consider diagonally-adjacent coordinates as neighbors. Defaults to `true`.
    ///
    /// - Returns: An array of `GridNeighbor` objects.
    ///
    public func neighbors(of coordinate: GridCoordinate, allowDiagonals: Bool = true) -> [GridNeighbor<T>] {
        let dirs: [GridDirection] = allowDiagonals ? GridDirection.allCases : GridDirection.cardinals
        return dirs.compactMap { dir in
            let pos = coordinate + dir.offset
            guard let value = value(at: pos) else { return nil }
            return GridNeighbor(value: value, coordinate: pos, direction: dir)
        }
    }
    
    /// Indicates whether or not the coordinate lies within the boundaries of the Grid.
    ///
    /// - Parameter coordinate: The coordinate to test for validity.
    /// - Returns: A `Bool` value indicating the validity of the coordinate.
    ///
    public func isValid(coordinate: GridCoordinate) -> Bool {
        (0..<width).contains(coordinate.x) &&
        (0..<height).contains(coordinate.y)
    }
    
    public func isValid(line: GridLine) -> Bool {
        isValid(coordinate: line.start) && isValid(coordinate: line.end)
    }
    
    /// Returns all values along the line ordered from the start point to the end point.
    ///
    /// - Parameter line: The line to return values for.
    /// - Returns: An array containing zero or more values found along the line.
    ///
    /// - Note: Lines may contain points that fall outside the grid. Those invalid points will not return values.
    ///
    public func values(on line: GridLine) -> [T] {
        line.allCoordinates.compactMap { value(at: $0) }
    }
    
    /// Search along an axis from the starting coordinate, finding all contiguous elements that match the predicate.
    ///
    /// This will iteratively search in both directions along the indicated axis until either the predicate returns
    /// false or the edge of the Grid is reached. If the starting point is invalid (outside the Grid) or does not match
    /// the validation closure, then this method will return `nil`.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate of the search.
    ///     - searchType: The axis to search along.
    ///     - matching: The predicate closure that indicates whether elements are considered matches.
    ///
    /// - Returns: A GridLine encompasing the coordinates that matched elements or `nil` if the starting coordinate was invalid.
    ///
    public func linearSearch(start: GridCoordinate, searchType: SearchType, matching: @escaping (T) -> Bool) -> GridLine?  {
        let searchDirections: [GridDirection] = (searchType == .horizontal) ? [.w, .e] : [.n, .s]
        guard
            let min = raySearch(from: start, direction: searchDirections[0], matching: matching),
            let max = raySearch(from: start, direction: searchDirections[1], matching: matching)
        else { return nil }
        return GridLine(start: min, end: max)
    }
    
    /// Searches in the specified direction from the starting point, finding all contiguous elements that match the predicate.
    ///
    /// This will iteratively search in the indicated direction until either the predicate returns false or the edge of the Grid is reached.
    /// If the starting position is invalid (outside the Grid) or does not match the validation closure, then this method will return `nil`.
    ///
    /// - Parameters:
    ///     - start: The starting coordinate of the search.
    ///     - direction: The direction to search in.
    ///     - matching: The predicate closure that indicates whether elements are considered matches.
    ///
    /// - Returns: A GridCoordinate indicating the furthest contiguous element matching the predicate or nil if the starting
    ///            coordinate is invalid.
    ///
    public func raySearch(from start: GridCoordinate, direction: GridDirection, matching: (T) -> Bool) -> GridCoordinate? {
        guard let startVal = value(at: start), matching(startVal) else { return nil }
        var count = 0
        while let val = value(at: start + direction.offset.scaled(by: count)), matching(val) {
            count += 1
        }
        return start + direction.offset.scaled(by: count - 1)
    }
    
    /// Find all contiguous coordinates matching the supplied predicate.
    public func floodSearch(from start: GridCoordinate, allowDiagonalMatches: Bool = false, matching: (GridCoordinate) -> Bool) -> Set<GridCoordinate> {
        var matches = Set<GridCoordinate>(minimumCapacity: width * height)
        var visited: [[Bool]] = Array<[Bool]>(repeating: Array<Bool>(repeating: false, count: width), count: height)
        
        func test(coord: GridCoordinate, visited: inout [[Bool]], matches: inout Set<GridCoordinate>, allowDiagonalMatches: Bool, matching: (GridCoordinate) -> Bool) {
            let x = coord.x
            let y = coord.y
            guard !visited[y][x] else { return }
            visited[y][x] = true
            guard let value = self[coord], matching(coord) else {
                /// This is either already visited, off the grid, or does not match.
                return
            }
            matches.insert(coord)
            
            neighbors(of: coord, allowDiagonals: allowDiagonalMatches).forEach { neighbor in
                test(coord: neighbor.coordinate, visited: &visited, matches: &matches, allowDiagonalMatches: allowDiagonalMatches, matching: matching)
            }
        }
        
        test(coord: start, visited: &visited, matches: &matches, allowDiagonalMatches: allowDiagonalMatches, matching: matching)
        return matches
    }
    
    /// Returns a grid coordinate that is the result of moving from the start coordinate in
    /// the provided direction.
    ///
    /// If the new coordinate falls outside the grid, `nil` is returned.
    ///
    /// - Parameters:
    ///     - direction: The direction to move away from start.
    ///     - start: The starting coordinate.
    ///
    /// - Returns: A `GridCoordinate` for the new location, if it is valid. Otherwise returns `nil`.
    ///
    public func moving(direction: GridDirection, from start: GridCoordinate, distance: Int = 1) -> GridCoordinate? {
        let new = start + (direction.offset.scaled(by: distance))
        return isValid(coordinate: new) ? new : nil
    }
    
    /// Access a value in the grid by coordinate.
    ///
    /// Returns the value at the specified coordinate if it is valid. Otherwise, returns `nil`.
    ///
    public subscript (_ sub: GridCoordinate) -> T? {
        value(at: sub)
    }
    
    /// Applies a transformation to every data point in the grid and returns the resulting data.
    ///
    /// This does not modify the data in the Grid, which is immutable.
    ///
    /// - Parameter transformer: The closure that will use the a coordinate in the grid and the value at that coordinate
    ///                          to compute a new value for that coordinate.
    ///
    /// - Returns: A new data set with the transformation applied.
    ///
    public func transformedData<U>(with transformer: (GridCoordinate, T) -> U) -> [[U]] {
        let h = data.count
        let w = data[0].count
        return (0..<h).map { y in
            (0..<w).map { x in
                let coord = GridCoordinate(x: x, y: y)
                return transformer(coord, value(at: coord)!)
            }
        }
    }
    
    /// Expand the Grid by adding a new perimeter with a fixed value around the existing data.
    ///
    /// - Parameter value: The value to fill the new perimeter with.
    /// - Returns: A new array of type `[[T]]`.
    ///
    public func outsetData(fillingWith value: T) -> [[T]] {
        let w = width + 2
        let h = height + 2
        var newData = [[T]](repeating:[T](repeating: value, count: w), count: h)
        (0..<height).forEach { y in
            (0..<width).forEach { x in
                newData[y+1][x+1] = data[y][x]
            }
        }
        return newData
    }
    
    /// All coordinates on the edge of the grid.
    ///
    /// Points will start at `(0, 0)` and proceed clockwise around the perimeter.
    ///
    public var perimeter: [GridCoordinate] {
        var result: [GridCoordinate] = []
        result.append(contentsOf: (0..<(width - 1)).map { GridCoordinate(x: $0, y: 0) })
        result.append(contentsOf: (0..<(height - 1)).map { GridCoordinate(x: width - 1, y: $0) })
        result.append(contentsOf: (1..<width).reversed().map { GridCoordinate(x: $0, y: height - 1) })
        result.append(contentsOf: (1..<height).reversed().map { GridCoordinate(x: 0, y: $0) })
        return result
    }
    
    /// Create a line from the specified coordinate to the edge of the grid in the specified direction.
    ///
    /// This method enables ray-casting by quickly providing access to all coordinates along the ray's path.
    ///
    /// - Parameters:
    ///     - start: The coordinate to start the line creation at.
    ///     - direciton: The direction to search until an edge is detected.
    ///
    /// - Returns: A `GridLine` from `start` to the edge of the grid in the specified direction.
    ///
    public func lineToEdge(from start: GridCoordinate, direction: GridDirection) -> GridLine {
        let offset = direction.offset
        var length = 0
        while self.isValid(coordinate: start + offset.scaled(by: length)) { length += 1 }
        return GridLine(start: start, direction: direction, length: length)
    }
    
    /// Count the number of coordinates matching the provided predicate along a line to the edge of the grid.
    ///
    /// This is a simple ray-casting algorithm. It is up to the developer to determine what constitutes a match.
    ///
    /// - Parameters:
    ///     - start: The coordinate to start the search at.
    ///     - direction: The direction to search in.
    ///     - matching: The predicate that determines whether or not each coordinate along the ray matches.
    ///
    /// - Returns: An `Int` that is the count of coordinates that matched the predicate along the ray.
    ///
    public func count(from start: GridCoordinate, direction: GridDirection, matching: (T) -> Bool) -> Int {
        let line = lineToEdge(from: start, direction: direction)
        return values(on: line)
            .filter(matching)
            .count
    }
    
    /// Get the values along a line from the specified coordinate over a specified distance.
    ///
    /// - Parameters:
    ///    - start: The coordinate to start the search at.
    ///    - direction: The direction to search in.
    ///    - count: The number of values to return.
    ///
    /// - Returns: An array of values along the line, starting at `start` and proceeding in the specified direction.
    ///
    public func raySample(from start: GridCoordinate, direction: GridDirection, count: Int) -> [T] {
        let line = GridLine(start: start, direction: direction, length: count)
        guard isValid(line: line) else { return [] }
        return line.allCoordinates.compactMap { value(at: $0) }
    }
}
