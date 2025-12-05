import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    
    var ranges: [ClosedRange<Int>] = []
    var ids: [Int] = []

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
        
        for string in strings {
            if string.contains("-") {
                let parts = Array(string.split(separator: "-"))
                let lowerBound = Int(parts[0]) ?? 0
                let upperBound = Int(parts[1]) ?? 0
                ranges.append(lowerBound...upperBound)
            } else {
                ids.append(Int(string) ?? 0)
            }
        }
        
        ranges.sort(by: { $0.lowerBound < $1.lowerBound })
    }
    
    func findFreshIds(ids: [Int]) -> Int {
        return ids.reduce(0) { partialResult, id in
            partialResult + (ranges.contains(where: { $0.contains(id) }) ? 1 : 0)
        }
    }
    
    func findAllFreshIds(ranges: [ClosedRange<Int>]) -> Int {
        var ranges = ranges
        var index = 0
        
        while index < ranges.count - 1 {
            if ranges[index].overlaps(ranges[index + 1]) {
                let newLowerBound = min(ranges[index].lowerBound, ranges[index + 1].lowerBound)
                let newUpperBound = max(ranges[index].upperBound, ranges[index + 1].upperBound)
                ranges[index] = newLowerBound...newUpperBound
                ranges.remove(at: index + 1)
            } else {
                index += 1
            }
        }
        
        return ranges.reduce(0, { $0 + $1.count })
    }

    func part1() {
        print(findFreshIds(ids: ids))
    }

    func part2() {
        print(findAllFreshIds(ranges: ranges))
    }
}
