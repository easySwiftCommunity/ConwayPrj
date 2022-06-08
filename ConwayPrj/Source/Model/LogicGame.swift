//
//  GameController.swift
//  ConwayPrj
//
//  Created by Danya on 08/06/2022.
//  Copyright © 2022 Danya. All rights reserved.
//

import Foundation

class LogicGame: GameProtocol {

    var world: [[Bool]] = []
    var worldSize: Int = 0
    var generations: Int = 0
    var staleGeneration: [(Int,Int)] = []
    internal var nextGeneration: [(Int,Int)] = []
    internal var currentGeneration: [(Int,Int)] = []
    internal var generationsHistory: [String]
    var gameStatus: GameStatus?
    
    init(worldSize: Int) {
        generationsHistory = []
        self.worldSize = worldSize
        for _ in 0..<worldSize {
            var line: [Bool] = []
            for _ in 0..<worldSize {
                line.append(false)
            }
            world.append(line)
        }
    }
    var lastIndexAllowed:Int = 0

    func runGeneration() {
        gameStatus = .RUNNING
        lastIndexAllowed = worldSize-1
        generations = generations + 1
        if currentGeneration.isEmpty {
            gameStatus = .OVER
            return
        }
        
        updateGenerations()
        nextGeneration.removeAll()
        for creature in currentGeneration {
            validateLife(line:creature.0, col:creature.1)
            for cell in getNeighboursIndexes(x:creature.0, y:creature.1) {
                let line = cell.0
                let col  = cell.1
                if !world[line][col] {
                    validateLife(line:line, col:col)
                }
            }
        }
        for creature in currentGeneration {
            world[creature.0][creature.1] = false
        }
        currentGeneration.removeAll()
        for creature in nextGeneration {
            world[creature.0][creature.1] = true
        }
        currentGeneration = nextGeneration
        nextGeneration.removeAll()
    }
    func updateGenerations() {
        if generationsHistory.count >= 5 {
            generationsHistory.removeFirst()
        }
        generationsHistory.append("\(currentGeneration)")
        staleGeneration = currentGeneration
    }
    
    func changeStatus(status: GameStatus) {
        gameStatus = status
    }
    func validateLife(line:Int,col:Int) {
        let alive: Bool = world[line][col]
        let neighboursAlive: Int = getNeighbours(x:line, y:col)
        if alive {
            if neighboursAlive >= 2 && neighboursAlive <= 3 {
                appendNextGeneration(line:line,col:col)
            }
        } else {
            if neighboursAlive == 3 {
                appendNextGeneration(line:line,col:col)
            }
        }
    }
    func toggleCell(line: Int, col: Int) {
        let cellState = world[line][col]
        if cellState {
            world[line][col] = false
            removeCurrentGeneration(line: line, col: col)
        } else {
            world[line][col] = true
            appendCurrentGeneration(line: line, col: col)
        }
    }
    
    func startRandom() {
        var randomNumber = Int.random(in: 0...2500)
        for i in 0...randomNumber {
            let randomLine = Int.random(in: 0...49)
            let randomCol = Int.random(in: 0...49)
            world[randomLine][randomCol] = true
            appendCurrentGeneration(line: randomLine, col: randomCol)
           
        }
    }
    
    func getCellAt(row: Int, col: Int) -> Bool {
        return world[row][col]
    }
    
    func appendCurrentGeneration(line:Int, col: Int) {
        let index = currentGeneration.index{$0 == line && $1 == col}
        if index == nil {
            currentGeneration.append((line, col))
        }
    }
    public func getCurrentSize() -> Int {
        return currentGeneration.count
    }
    
    func removeCurrentGeneration(line:Int, col: Int) {
        if let index = currentGeneration.index(where: {$0 == line && $1 == col}) {
            currentGeneration.remove(at: index)
        }
    }

    func appendNextGeneration(line:Int, col: Int) {
        let index = nextGeneration.index{$0 == line && $1 == col}
        if index == nil {
            // print("append to next: \(line, col)")
            nextGeneration.append((line, col))
        }
    }
    
    func getNeighboursIndexes(x:Int, y:Int) -> [(Int,Int)] {
        let xMin1 = x-1 < 0 ? lastIndexAllowed :x-1
        let xPlu1 = x+1 > lastIndexAllowed ? 0 : x+1
        let yMin1 = y-1 < 0 ? lastIndexAllowed : y-1
        let yPlu1 = y+1 > lastIndexAllowed ? 0 : y+1
        let arr = [
            (xMin1, yMin1),(x, yMin1),(xPlu1, yMin1),
            (xMin1, y),           (xPlu1, y),
            (xMin1, yPlu1),(x, yPlu1),(xPlu1, yPlu1)
        ]
        return arr
    }
    
    func getNeighbours(x:Int, y:Int) -> Int {
        let arr = getNeighboursIndexes(x:x, y:y)
        var sum: Int = 0
        for cell in arr {
            let line = cell.0
            let col  = cell.1
            sum = sum + (world[line][col] ? 1 : 0)
        }
        return sum
    }
}
