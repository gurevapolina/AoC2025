import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    123 328  51 64
     45 64  387 23
      6 98  215 314
    *   +   *   +
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    
    var operands: [[Int]] = []
    var operations: [String] = []

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
    }
    
    private func findSum(_ operands: [Int], _ operation: String) -> Int {
        if operation == "+" {
            operands.reduce(0, { $0 + $1 })
        } else if operation == "*" {
            operands.reduce(1, { $0 * $1 })
        } else {
            0
        }
    }
    
    private func findGrandSum(_ operands: [[Int]], _ operations: [String]) -> Int {
        zip(operands, operations).reduce(0, { $0 + findSum($1.0, $1.1) })
    }
    
    private func parsePart1(_ strings: [String], _ operands: inout [[Int]], _ operations: inout [String]) {
        let arrays = strings.prefix(strings.count - 1).map({
            $0.split(separator: " ", omittingEmptySubsequences: true)
              .map({ Int(String($0)) ?? 0 })
        })
        operands = (0..<arrays[0].count).map({ index in arrays.map({ $0[index] }) })

        operations = strings.last?
            .split(separator: " ", omittingEmptySubsequences: true)
            .map({ String($0) }) ?? []
    }
    
    private func parsePart2(_ strings: [String], _ operands: inout [[Int]], _ operations: inout [String]) {
        let strings = transformMatrix(strings: strings)
        
        operands = strings.split(separator: "").map({ Array($0).map({ Int($0) ?? 0 }) })
        operations = operations.reversed()
    }
    
    private func transformMatrix(strings: [String]) -> [String] {
        let maxLength = strings.max(by: { $0.count < $1.count })?.count ?? 0
    
        var strings = strings
        for index in 0..<strings.count {
            if strings[index].count < maxLength {
                strings[index] += (Array(repeating: " ", count: maxLength - strings[index].count)).joined()
            }
        }
        
        var result: [String] = []
        
        while !strings[0].isEmpty {
            var newString = ""
            for index in 0..<(strings.count - 1) {
                newString.append(String(strings[index].popLast() ?? Character(" ")))
            }
            newString.removeAll(where: { $0.isWhitespace })
            result.append(newString)
        }
    
        return result
    }

    func part1() {
        parsePart1(strings, &operands, &operations)
        print(findGrandSum(operands, operations))
    }

    func part2() {
        parsePart2(strings, &operands, &operations)
        print(findGrandSum(operands, operations))
    }
}
