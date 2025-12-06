//: # Advent of Code 202X
//: ### Day 1: TBD
//: [Next](@next)

import Foundation

//: Typically, you'd start by parsing the input into a Swift data structure using the DataParser:
// let input = try DataParser<Int>().parseLines(fileName: "input")

//: Then pass the data to the solver, along with any parameterization:
// let result = Solver.solve(input: input, using: 2)


let sampleInput = try DataParser<String>().parseLines(fileName: "sample")

print("Sample: ", Solver.solve(data: sampleInput))

let input = try DataParser<String>().parseLines(fileName: "input")

print("1st star:", Solver.solve(data: input, second: false))
print("2nd star:", Solver.solve(data: input, second: true))


