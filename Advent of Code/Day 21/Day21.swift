//
//  main.swift
//  test
//
//  Created by Dave DeLong on 12/20/17.
//  Copyright © 2017 Dave DeLong. All rights reserved.
//

import Foundation

class Day21: Day {

    enum Bit {
        case on
        case off
    }

    typealias RuleSet = Dictionary<Matrix<Bit>, Matrix<Bit>>
    var rules = RuleSet()
    
    let initial = Matrix<Bit>([
        [.off, .on,  .off],
        [.off, .off, .on],
        [.on,  .on,  .on]
    ])

    required init() {
        let rawRules = Day21.inputLines()
        for rawRule in rawRules {
            let pieces = rawRule.components(separatedBy: " => ")
            let rawCause = pieces[0].split(separator: "/")
            let rawEffect = pieces[1].split(separator: "/")
            
            let cause = Matrix<Bit>(rawCause.map { $0.map { $0 == "#" ? .on : .off } })
            let r1 = cause.rotate(1)
            let r2 = r1.rotate(1)
            let r3 = r2.rotate(1)
            
            let effect = Matrix<Bit>(rawEffect.map { $0.map { $0 == "#" ? .on : .off } })
            
            rules[cause] = effect
            rules[cause.flip()] = effect
            rules[r1] = effect
            rules[r1.flip()] = effect
            rules[r2] = effect
            rules[r2.flip()] = effect
            rules[r3] = effect
            rules[r3.flip()] = effect
        }
    }

    func apply(times: Int) -> Matrix<Bit> {
        var current = initial
        for i in 0 ..< times {
            // first, subdivide current
            let subdivided = current.subdivide()
            
            // apply the rules to each subdivided matrix
            let applied = subdivided.map { _, _, item in
                return rules[item] ?? item
            }
            
            // reconstitue the matrix
            current = Matrix(recombining: applied)
        }
        
        return current
    }
    
    func part1() {
        let part1 = apply(times: 5)
        let pixelsOn1 = part1.count(where: { $0 == .on })
        print("part 1: \(pixelsOn1)")
    }

    func part2() {
        let part2 = apply(times: 18)
        let pixelsOn2 = part2.count(where: { $0 == .on })
        print("part 2: \(pixelsOn2)")
    }
}