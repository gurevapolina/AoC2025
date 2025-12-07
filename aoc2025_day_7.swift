import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    .......S.......
    ...............
    .......^.......
    ...............
    ......^.^......
    ...............
    .....^.^.^.....
    ...............
    ....^.^...^....
    ...............
    ...^.^...^.^...
    ...............
    ..^...^.....^..
    ...............
    .^.^.^.^.^...^.
    ...............
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    var map: [[String]] = []

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
        
        map = strings.map({ $0.map({ String($0)}) })
    }
    
    func handleMap(map: [[String]]) -> (Int, Int) {
        var numberOfSplits = 0
        var ways = Array(repeating: Array(repeating: 0, count: map[0].count),
                         count: map.count)
        
        for (i, line) in map.enumerated() {
            for (j, element) in line.enumerated() {
                if element == "S" {
                    ways[i][j] = 1
                    continue
                }
                guard i > 0 && ways[i - 1][j] > 0 else { continue }

                if element == "." {
                    ways[i][j] += ways[i - 1][j]
                }
                if element == "^" {
                    numberOfSplits += 1
                    
                    if j - 1 >= 0 {
                        ways[i][j - 1] += ways[i - 1][j]
                    }
                    if j + 1 < line.count {
                        ways[i][j + 1] += ways[i - 1][j]
                    }
                }
            }
        }
        
        let numberOfWays = ways[map.count - 1].reduce(0, { $0 + $1 })
        return (numberOfSplits, numberOfWays)
    }
    
    lazy var result = handleMap(map: map)

    func part1() {
        print(result.0)
    }

    func part2() {
        print(result.1)
    }
}
