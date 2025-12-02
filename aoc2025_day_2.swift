import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var string: String = ""
    var ranges: [ClosedRange<Int>] = []

    func parse() {
        string = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        string = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }.first ?? ""

        ranges = parseRanges()
    }

    func parseRanges() -> [ClosedRange<Int>] {
        let parsedRanges = string.split(separator: ",").map { String($0) }
        return parsedRanges.map { string in
            let parts = string.split(separator: "-").map { String($0) }
            let lowerBound = Int(parts[0]) ?? 0
            let upperBound = Int(parts[1]) ?? 0

            return lowerBound...upperBound
        }
    }

    func findInvalidIds(range: ClosedRange<Int>, isInvalid: (String) -> Bool) -> Int {
        range.reduce(0) { partialResult, number in
            partialResult + (isInvalid(String(number)) ? number : 0)
        }
    }

    func isInvalidPart1(string: String) -> Bool {
        return string.count % 2 == 0 &&
        (string.prefix(string.count / 2)) == (string.suffix(string.count / 2))
    }

    func isInvalidPart2(string: String) -> Bool {
        for length in 1...5 {
            guard string.count >= length * 2 else { continue }

            let prefix = string.prefix(length)
            let positions = string.ranges(of: prefix)
            guard positions.count > 1 else { continue }

            if positions.count * prefix.count == string.count {
                return true
            }
        }
        return false
    }

    func part1() {
        let result = ranges.reduce(0) { partialResult, range in
            partialResult + findInvalidIds(range: range, isInvalid: isInvalidPart1)
        }
        print(result)
    }

    func part2() {
        let result = ranges.reduce(0) { partialResult, range in
            partialResult + findInvalidIds(range: range, isInvalid: isInvalidPart2)
        }
        print(result)
    }
}
