import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    
    var grid: [[String]] = []
    var copyGrid: [[String]] = []
    var height: Int { grid.count }
    var width: Int { grid[0].count }

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
        
        grid = strings.map({ $0.map({ String ($0 )}) })
    }
    
    func isOnMap(i: Int, j: Int) -> Bool {
        return i >= 0 && i < height && j >= 0 && j < width
    }
    
    func countAdjacentRolls(grid: [[String]], i: Int, j: Int) -> Int {
        let positions = [(i - 1, j - 1),
                         (i - 1, j),
                         (i - 1, j + 1),
                         (i, j + 1),
                         (i + 1, j + 1),
                         (i + 1, j),
                         (i + 1, j - 1),
                         (i, j - 1)]
        
        return positions.reduce(0) { partialResult, position in
            let isRoll = isOnMap(i: position.0, j: position.1) && grid[position.0][position.1] == "@"
            return partialResult + (isRoll ? 1 : 0)
        }
    }
    
    func removeRolls(grid: [[String]], copyGrid: inout [[String]]) -> Int {
        var result = 0
        for i in 0..<height {
            for j in 0..<width {
                if grid[i][j] != "@" { continue }
                if countAdjacentRolls(grid: grid, i: i, j: j) < 4 {
                    copyGrid[i][j] = "."
                    result += 1
                }
            }
        }
        return result
    }

    func part1() {
        copyGrid = grid
        var result = removeRolls(grid: grid, copyGrid: &copyGrid)
        print(result)
    }

    func part2() {
        copyGrid = grid
        var result = 0
        
        while true {
            let removedRolls = removeRolls(grid: grid, copyGrid: &copyGrid)
            if removedRolls == 0 { break }
            
            result += removedRolls
            grid = copyGrid
        }
        print(result)
    }
}
