import Foundation
import UIKit

class ViewController: UIViewController {

    let input =
    """
    """

    let testInput =
    """
    svr: aaa bbb
    aaa: fft
    fft: ccc
    bbb: tty
    tty: ccc
    ccc: ddd eee
    ddd: hub
    hub: fff
    eee: dac
    dac: fff
    fff: ggg hhh
    ggg: out
    hhh: out
    """

    override func viewDidLoad() {
        super.viewDidLoad()

        parse()
        part1()
        part2()
    }

    var strings: [String] = []
    var paths: [String: [String]] = [:]

    func parse() {
        strings = testInput.split(separator: "\n", omittingEmptySubsequences: true)
//        strings = input.split(separator: "\n", omittingEmptySubsequences: true)
            .map { String($0) }
        
        for line in strings {
            let parts = line.split(separator: ": ", omittingEmptySubsequences: true)
            let key = String(parts[0])
            let values = parts[1].split(separator: " ", omittingEmptySubsequences: true).map { String($0) }
            paths[key] = values
        }
    }
    
    private var memo: [String: Int] = [:]
    private func countPath(start: String, end: String, isDac: Bool, isFft: Bool, isPart1: Bool) -> Int {
        let key = "\(start)\(isDac)\(isFft)"
        
        if let cached = memo[key] {
            return cached
        }
        
        if start == end {
            if isPart1 {
                return 1
            }
            return isDac && isFft ? 1 : 0
        }
        
        var count = 0
        if let next = paths[start] {
            
            count += next.reduce(0) { partialResult, next in
                partialResult + countPath(start: next,
                                          end: end,
                                          isDac: isDac || next == "dac",
                                          isFft: isFft || next == "fft",
                                          isPart1: isPart1)
            }
        }
        memo[key] = count
        return count
    }

    func part1() {
        print(countPath(start: "you", end: "out", isDac: false, isFft: false, isPart1: true))
    }

    func part2() {
        memo = [:]
        print(countPath(start: "svr", end: "out", isDac: false, isFft: false, isPart1: false))
    }
}
