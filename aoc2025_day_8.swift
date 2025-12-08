import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    162,817,812
    57,618,57
    906,360,560
    592,479,940
    352,342,300
    466,668,158
    542,29,236
    431,825,988
    739,650,466
    52,470,668
    216,146,977
    819,987,18
    117,168,530
    805,96,715
    346,949,466
    970,615,88
    941,993,340
    862,61,35
    984,92,344
    425,690,689
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    struct Pos: Hashable {
        let x: Int
        let y: Int
        let z: Int

        func print() {
            Swift.print("x: \(x), y: \(y), z: \(z)")
        }
    }

    var strings: [String] = []
    var n = 0
    var boxes: [Pos] = []

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }

        n = 10
//        n = 1000

        boxes = strings.map({ string in
            let parts = string.split(separator: ",", omittingEmptySubsequences: true)
            let x = Int(parts[0])!
            let y = Int(parts[1])!
            let z = Int(parts[2])!
            return Pos(x: x, y: y, z: z)
        })
    }

    private func distance(a: Pos, b: Pos) -> Double {
        let dx = Double(a.x - b.x) * Double(a.x - b.x)
        let dy = Double(a.y - b.y) * Double(a.y - b.y)
        let dz = Double(a.z - b.z) * Double(a.z - b.z)
        return sqrt(dx + dy + dz)
    }

    private func calculateDistances(boxes: [Pos]) -> [[Int]: Double] {
        var dict: [[Int]: Double] = [:]

        for i in 0..<boxes.count {
            for j in i + 1..<boxes.count {
                let dist = distance(a: boxes[i], b: boxes[j])
                dict[[i, j]] = dist
            }
        }

        return dict
    }

    private func mergeCircuitsIfNeeded(circuits: inout [Set<Int>]) {
        var i = 1
        while i < circuits.count {
            var j = 0
            while j < i && j < circuits.count {
                if circuits[i].intersection(circuits[j]).count > 0 {
                    circuits[j] = circuits[i].union(circuits[j])
                    circuits.remove(at: i)

                    i = 0

                    j = circuits.count // break
                } else {
                    j += 1
                }
            }
            i += 1
        }
    }

    private func alreadyInCircuit(circuits: [Set<Int>], index1: Int, index2: Int) -> Bool {
        for circuit in circuits {
            if circuit.contains(index1) && circuit.contains(index2) {
                return true
            }
        }
        return false
    }

    private func insert(circuits: inout [Set<Int>], index1: Int, index2: Int) {
        defer { mergeCircuitsIfNeeded(circuits: &circuits) }

        for index in 0..<circuits.count {
            if circuits[index].contains(index1) {
                circuits[index].insert(index2)
                return
            } else if circuits[index].contains(index2) {
                circuits[index].insert(index1)
                return
            }
        }
        circuits.append(Set([index1, index2]))
    }

    private func findNClosest(boxes: [Pos], n: Int) -> Int {
        let sortedDict = calculateDistances(boxes: boxes).sorted { $0.value < $1.value }

        var circuits: [Set<Int>] = []
        var count = 0
        for elem in sortedDict {
            if count == n {
                break
            }

            let index1 = elem.key[0]
            let index2 = elem.key[1]
            if alreadyInCircuit(circuits: circuits, index1: index1, index2: index2) {
                count += 1
            } else {
                insert(circuits: &circuits, index1: index1, index2: index2)
                count += 1
            }
        }

        return Array(
            circuits.sorted(by: { $0.count > $1.count })
                .prefix(3)
        ).reduce(1, { $0 * $1.count })
    }

    private func findLastConnector(boxes: [Pos]) -> Int {
        let sortedDict = calculateDistances(boxes: boxes).sorted { $0.value < $1.value }

        var circuits: [Set<Int>] = []
        for elem in sortedDict {
            let index1 = elem.key[0]
            let index2 = elem.key[1]

            if alreadyInCircuit(circuits: circuits, index1: index1, index2: index2) {
                continue
            } else {
                insert(circuits: &circuits, index1: index1, index2: index2)

                if circuits[0].count == boxes.count {
                    return boxes[index1].x * boxes[index2].x
                }
            }
        }

        return 0
    }

    func part1() {
        print(findNClosest(boxes: boxes, n: n))
    }

    func part2() {
        print(findLastConnector(boxes: boxes))
    }
}

