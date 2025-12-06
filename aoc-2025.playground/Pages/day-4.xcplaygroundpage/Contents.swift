//: # Advent of Code 202X
//: ### Day 4: TBD
//: [Prev](@prev) <---> [Next](@next)

import Foundation

//: Typically, you'd start by parsing the input into a Swift data structure using the DataParser:
// let input = try DataParser<Int>().parseLines(fileName: "input")

//: Then pass the data to the solver, along with any parameterization:
// let result = Solver.solve(input: input, using: 2)
let sampleInput = try DataParser<String>().parseLines(fileName: "sample")

print("Sample: ", Solver.solve(data: sampleInput, second: true))

let input = try DataParser<String>().parseLines(fileName: "input")


print("star 1: ", Solver.solve(data: input, second: false))
print("star 2: ", Solver.solve(data: input, second: true))
