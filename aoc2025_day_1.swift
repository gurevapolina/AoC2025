import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var string: [String] = []

    func parse() {
        string = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        string = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
    }

    func findPassword(countingPasses: Bool) -> Int {
        var password = 0
        var dial = 50

        for command in string {
            let steps = Int(command.dropFirst()) ?? 0

            for step in 0..<steps {
                dial += (command.first == "R" ? 1 : -1)
                if dial < 0 {
                    dial = 99
                } else if dial > 99 {
                    dial = 0
                }
                if (countingPasses || step == steps - 1) && dial == 0 {
                    password += 1
                }
            }
        }
        return password
    }

    func part1() {
        print(findPassword(countingPasses: false))
    }

    func part2() {
        print(findPassword(countingPasses: true))
    }
}
