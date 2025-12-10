import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    [.##.] (3) (1,3) (2) (2,3) (0,2) (0,1) {3,5,4,7}
    [...#.] (0,2,3,4) (2,3) (0,4) (0,1,2) (1,2,3,4) {7,5,12,7,2}
    [.###.#] (0,1,2,3,4) (0,3,4) (0,1,2,4,5) (1,2) {10,11,11,5,10,5}
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    var lights: [[String]] = []
    var buttons: [[[Int]]] = []

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
        
        strings.forEach { string in
            buttons.append([])
            let components = string.components(separatedBy: " ")
            for component in components {
                if component.hasPrefix("[") {
                    let lightString = component.trimmingCharacters(in: CharacterSet(charactersIn: "[]"))
                        .map { String($0) }
                    lights.append(lightString)
                }
                else if component.hasPrefix("(") {
                    let buttonString = component.trimmingCharacters(in: CharacterSet(charactersIn: "()"))
                    let buttonIndices = buttonString.split(separator: ",", omittingEmptySubsequences: true)
                        .map { Int($0) ?? 0 }
                    buttons[buttons.count - 1].append(buttonIndices)
                }
            }
        }
    }
    
    func apply(current: inout [String], button: [Int]) {
        for index in button {
            if current[index] == "#" {
                current[index] = "."
            } else {
                current[index] = "#"
            }
        }
    }
    
    func backtrackLights(_ bestSum: inout Int,
                         _ currentSum: inout Int,
                         _ current: inout [String],
                         _ currentButtonsIndicies: inout [Int],
                         _ goal: [String],
                         _ buttons: [[Int]]) {
        if current == goal {
            bestSum = min(bestSum, currentSum)
            return
        }
        
        if currentSum >= bestSum {
            return
        }
        
        for (index, button) in buttons.enumerated() {
            if index <= (currentButtonsIndicies.last ?? -1) {
                continue
            }
            if currentButtonsIndicies.contains(index) {
                continue
            }
            
            currentSum += 1
            currentButtonsIndicies.append(index)
            apply(current: &current, button: button)
            
            backtrackLights(&bestSum, &currentSum, &current, &currentButtonsIndicies, goal, buttons)

            apply(current: &current, button: button)
            currentButtonsIndicies.removeLast()
            currentSum -= 1
        }
    }
    
    func findMinimumButtonPresses(lights: [[String]], buttons: [[[Int]]]) -> Int {
        var totalPresses = 0
        
        for (light, buttonSet) in zip(lights, buttons) {
            var bestSum = buttons.count + 1
            var currentSum = 0
            var current = Array(repeating: ".", count: light.count)
            var currentButtonsIndicies: [Int] = []
            backtrackLights(&bestSum, &currentSum, &current, &currentButtonsIndicies, light, buttonSet)
            
            totalPresses += bestSum
        }
        
        return totalPresses
    }

    func part1() {
        print(findMinimumButtonPresses(lights: lights, buttons: buttons))
    }

    func part2() {
    }
}
