import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var string: [String] = []
    var banks: [[Int]] = []

    func parse() {
        string = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        string = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
        
        banks = string.map({ $0.map({ Int(String($0)) ?? 0 }) })
    }
    
    func findMaxSum(array: [Int], count: Int) -> Int {
        var lastIndexFound = -1
        var sum = 0
        
        for iteration in 0..<count {
            let maxIndex = array.count - count + iteration
            let index = findMaxIndex(array: array, searchRange: lastIndexFound + 1...maxIndex)
            
            let powerOfTen = Int(pow(Double(10), Double(count - iteration - 1)))
            sum += array[index] * powerOfTen
            lastIndexFound = index
        }
        
        return sum
    }
    
    func findMaxIndex(array: [Int], searchRange: ClosedRange<Int>) -> Int {
        var maxIndex = 0
        var max = 0
        for i in searchRange {
            if array[i] > max {
                max = array[i]
                maxIndex = i
            }
        }
        return maxIndex
    }

    func part1() {
        let result = banks.reduce(0, { $0 + findMaxSum(array: $1, count: 2) })
        print(result)
    }

    func part2() {
        let result = banks.reduce(0, { $0 + findMaxSum(array: $1, count: 12) })
        print(result)
    }
}
