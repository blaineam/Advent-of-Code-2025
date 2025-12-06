import Foundation

/// A type that can be initialized from a string value.
///
public protocol StringInitable {
    /// Initialize the object with a string.
    ///
    /// - Note: This operation can fail if the string is not valid for this object type.
    ///
    init?(_ string: String)
}

extension Int: StringInitable {}

extension String: StringInitable {}

/// A helper object that can parse raw string data into structured values.
///
public struct DataParser<T: StringInitable> {

    /// Parsing-specific errors.
    public enum Error: Swift.Error {

        /// Unable to load or parse the input.
        case unableToReadInput
    }

    public init() {}

    /// Parse where input values are separated by newlines.
    ///
    public func parseLines(fileName: String) throws -> [T] {
        try loadDataString(from: fileName)
            .parseCharacterSeparatedValues(separator: "\n")
    }
    
    /// Parse where input values are separated by commas.
    ///
    public func parseCSV(fileName: String) throws -> [T] {
        try loadDataString(from: fileName)
            .parseCharacterSeparatedValues(separator: ",")
    }
    
    /// Parse where input is multiple lines containing values separated by a character.
    /// - Parameters:
    ///   - fileName: The name of the file to parse.
    ///   - separator: The character that separates values.
    /// - Returns: An array of arrays of values.
    ///
    public func parseCharacterSeparatedValueLines(fileName: String, separator: Character) throws -> [[T]] {
        try loadDataString(from: fileName)
            .splitLines()
            .map { $0.parseCharacterSeparatedValues(separator: separator) }
    }
    
    /// Parse where input is multiple lines where values are separated by spaces.
    ///
    public func parseSpaceSeparatedValueLines(fileName: String) throws -> [[T]] {
        return try parseCharacterSeparatedValueLines(fileName: fileName, separator: " ")
    }

    /// Parse where there are multiple lines and each contains comma-separated values.
    ///
    public func parseCSVLines(fileName: String) throws -> [[T]] {
        return try parseCharacterSeparatedValueLines(fileName: fileName, separator: ",")
    }

    /// Breaks up the data on double-newlines. Single newlines are converted to spaces.
    ///
    public func parseDoubleNewlineWithSpaces(fileName: String) throws -> [T] {
        let dataString = try loadDataString(from: fileName)
        let encodedString = dataString
            .replacingOccurrences(of: "\n\n", with: "❤️")
            .replacingOccurrences(of: "\n", with: " ")
        return encodedString.splitLines(separator: "❤️")
            .compactMap { T(String($0)) }
        
    }

    /// Parse where input is multiple groups of lines separated by double newlines.
    ///
    public func parseDoubleNewlineGroupsOfLines(fileName: String) throws -> [[T]] {
        try loadDataString(from: fileName)
            .replacingOccurrences(of: "\n\n", with: "❤️")
            .splitLines(separator: "❤️")
            .map { $0.parseCharacterSeparatedValues(separator: "\n") }
    }
    
    /// Parse where input is multiple lines containing values which are read per-character.
    ///
    public func parseLinesOfCharacters(fileName: String) throws -> [[T]] {
        try loadDataString(from: fileName)
            .splitLines()
            .map { $0.compactMap { T(String($0)) } }
    }

    /// Attempt to load the input file from the Resources folder.
    ///
    public func loadDataString(from fileName: String) throws -> String {
        guard
            let dataURL = Bundle.main.url(forResource: fileName, withExtension: nil),
            let data = try? Data(contentsOf: dataURL),
            let str = String(data: data, encoding: .utf8)
        else { throw Error.unableToReadInput }
        
        return str
    }
    
    public func parseCSVWithNil(fileName: String) throws -> [T?] {
        try loadDataString(from: fileName)
            .parseCharacterSeparatedValuesWithNil(separator: ",")
    }
}

private extension StringProtocol {
    
    /// Split a string into lines.
    /// - Parameter separator: The character to split on.
    /// - Returns: An array of substrings.
    /// - Note: This function trims whitespace and newlines from the ends of the substrings.
    ///
    func splitLines(separator: Character = "\n") -> [Substring] {
        self
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .split(separator: separator)
    }
    
    /// Parse a string into an array of values.
    /// - Parameter separator: The character to split on.
    /// - Returns: An array of values.
    /// - Note: If a value is not valid for the type, it is not included in the result.
    ///
    func parseCharacterSeparatedValues<T:StringInitable>(separator: Character) -> [T] {
        self
            .split(separator: separator)
            .map { $0.trimmingCharacters(in: .newlines) }
            .compactMap { T($0) }
    }
    
    /// Parse a string into an array of values.
    /// - Parameter separator: The character to split on.
    /// - Returns: An array of values.
    /// - Note: If a value is not valid for the type, it is represented as `nil`.
    func parseCharacterSeparatedValuesWithNil<T:StringInitable>(separator: Character) -> [T?] {
        self
            .split(separator: separator)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .map { T($0) }
    }
}

