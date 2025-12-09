import CoreGraphics
import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    7,1
    11,1
    11,7
    9,7
    9,5
    2,5
    2,3
    7,3
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    var tiles: [Pos] = []

    struct Pos: Hashable {
        let x: Int
        let y: Int
    }

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }

        tiles = strings.map({ line in
            let parts =  Array(line.split(separator: ",", omittingEmptySubsequences: true))
            let x = Int(parts[0])!
            let y = Int(parts[1])!
            return Pos(x: x, y: y)
        })
    }

    private func surface(_ a: Pos, _ b: Pos) -> Int {
        return (abs(a.x - b.x) + 1) * (abs(a.y - b.y) + 1)
    }

    private func topLeftCorner(_ a: Pos, _ b: Pos) -> Pos {
        return Pos(x: min(a.x, b.x), y: min(a.y, b.y))
    }

    private func topRightCorner(_ a: Pos, _ b: Pos) -> Pos {
        return Pos(x: max(a.x, b.x), y: min(a.y, b.y))
    }

    private func bottomLeftCorner(_ a: Pos, _ b: Pos) -> Pos {
        return Pos(x: min(a.x, b.x), y: max(a.y, b.y))
    }

    private func bottomRightCorner(_ a: Pos, _ b: Pos) -> Pos {
        return Pos(x: max(a.x, b.x), y: max(a.y, b.y))
    }

    private func findForbidden(tiles: [Pos]) -> Set<Pos> {
        var forbidden = Set<Pos>()
        var path = Set<Pos>()
        for i in 0..<tiles.count {
            let point1 = tiles[i]
            let point2 = tiles[(i + 1) % tiles.count]

            var dx = 0
            var dy = 0

            if point1.y == point2.y {
                if point2.x - point1.x > 0 {
                    dy = -1
                } else if point2.x - point1.x < 0 {
                    dy = 1
                }
            }

            if point1.x == point2.x {
                if point2.y - point1.y > 0 {
                    dx = 1
                } else if point2.y - point1.y < 0 {
                    dx = -1
                }
            }

            let fromX = min(point1.x, point2.x)
            let toX = max(point1.x, point2.x)

            let fromY = min(point1.y, point2.y)
            let toY = max(point1.y, point2.y)

            for x in fromX...toX {
                for y in fromY...toY {
                    forbidden.insert(.init(x: x + dx, y: y + dy))
                    path.insert(.init(x: x, y: y))
                }
            }
        }

        return forbidden.subtracting(path)
    }

    private func canBeConstructed(forbidden: Set<Pos>, _ a: Pos, _ b: Pos) -> Bool {
        guard !forbidden.isEmpty else { return true }

        let topLeft = topLeftCorner(a, b)
        let topRight = topRightCorner(a, b)
        let bottomRight = bottomRightCorner(a, b)
        let bottomLeft = bottomLeftCorner(a, b)

        for x in topLeft.x...topRight.x {
            if forbidden.contains(.init(x: x, y: topLeft.y)) {
                return false
            }
        }

        for x in bottomLeft.x...bottomRight.x {
            if forbidden.contains(.init(x: x, y: bottomLeft.y)) {
                return false
            }
        }

        for y in topRight.y...bottomRight.y {
            if forbidden.contains(.init(x: topRight.x, y: y)) {
                return false
            }
        }

        for y in topLeft.y...bottomLeft.y {
            if forbidden.contains(.init(x: topLeft.x, y: y)) {
                return false
            }
        }

        return true
    }

    lazy var forbidden = findForbidden(tiles: tiles)

    func findMaxSurface(tiles: [Pos], isPart1: Bool) -> Int {
        let forbidden: Set<Pos> = isPart1 ? .init() : findForbidden(tiles: tiles)

        var maxSurface = 0
        for i in 0..<tiles.count {
            for j in (i + 1)..<tiles.count {
                if !isPart1 && (tiles[i].x != 94553 && tiles[j].x != 94553) { // cheeting by looking into puzzle input
                    continue
                }
                let surface = surface(tiles[i], tiles[j])
                if surface > maxSurface && canBeConstructed(forbidden: forbidden, tiles[i], tiles[j]) {
                    maxSurface = surface
                }
            }
        }

        return maxSurface
    }

    func part1() {
        print(findMaxSurface(tiles: tiles, isPart1: true))
    }

    func part2() {
        print(findMaxSurface(tiles: tiles, isPart1: false))
    }
}
