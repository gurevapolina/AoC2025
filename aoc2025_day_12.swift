import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    0:
    ###
    ##.
    ##.

    1:
    ###
    ##.
    .##

    2:
    .##
    ###
    ##.

    3:
    ##.
    ###
    ##.

    4:
    ###
    #..
    ###

    5:
    ###
    .#.
    ###

    4x4: 0 0 0 0 2 0
    12x5: 1 0 1 0 2 2
    12x5: 1 0 1 0 3 2
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    
    var shapes: [[[Int]]] = []
    var mapSizes: [(Int, Int)] = []
    var shapeCounts: [[Int]] = []

    func parse() {
        strings = testInput.split(separator: "\n")
//        strings = input.split(separator: "\n")
            .map { String($0) }
        
        var index = 0
        while index < strings.count {
            let line = strings[index]
            let components = line.split(separator: ":")
            
            if components.count == 2 {
                let sizePart = components[0].trimmingCharacters(in: .whitespaces)
                let sizeComponents = sizePart.split(separator: "x")
                if sizeComponents.count == 2,
                   let width = Int(sizeComponents[0]),
                   let height = Int(sizeComponents[1]) {
                    mapSizes.append((width, height))
                }
                
                let countsPart = components[1].trimmingCharacters(in: .whitespaces)
                let counts = countsPart.split(separator: " ").compactMap { Int($0) }
                shapeCounts.append(counts)
            }
            
            if components.count == 1 {
                index += 1
                var shape: [[Int]] = []
                for _ in 0..<3 {
                    let row = strings[index].map { $0 == "#" ? 1 : 0 }
                    shape.append(row)
                    index += 1
                }
                shapes.append(shape)
                continue
            }
            
            index += 1
        }
    }
    
    private func enoughtSurface(shapes: [[[Int]]], size: (Int, Int), shapesCount: [Int]) -> Bool {
        let desiredArea = size.0 * size.1
        var totalShapeArea = 0

        for shapeIndex in 0..<shapes.count {
            let shape = shapes[shapeIndex]
            let shapeCount = shapesCount[shapeIndex]
            let shapeArea = shape.reduce(0) { $0 + $1.reduce(0, +) }
            totalShapeArea += shapeArea * shapeCount
        }
        return totalShapeArea <= desiredArea
    }
    
    func countMatchingShapes(shapes: [[[Int]]], sizes: [(Int, Int)], shapesCounts: [[Int]]) -> Int {
        var count = 0
        for (size, shapesCount) in zip(sizes, shapesCounts) {
            if enoughtSurface(shapes: shapes, size: size, shapesCount: shapesCount) {
                count += 1
            }
        }
        return count
    }
    
    func part1() {
        print(countMatchingShapes(shapes: shapes, sizes: mapSizes, shapesCounts: shapeCounts))
    }

    func part2() {
    }
}
