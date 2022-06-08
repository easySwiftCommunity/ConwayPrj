//
//  GameController.swift
//  ConwayPrj
//
//  Created by Danya on 08/06/2022.
//  Copyright © 2022 Danya. All rights reserved.
//

import Foundation

protocol GameProtocol {
    
    typealias T = GameStatus
    
    var gameStatus:GameStatus? {get set}
    var generations: Int {get set}
    var nextGeneration: [(Int,Int)] {get}
    var currentGeneration: [(Int,Int)] {get}
    var staleGeneration: [(Int,Int)] {get} // fix erasing.
    var generationsHistory: [String] {get}
    var worldSize: Int {get set}
    
    func changeStatus(status: T)
    func runGeneration()
    func toggleCell(line: Int, col: Int)
    func appendCurrentGeneration(line:Int, col: Int)
    func getCurrentSize() -> Int
    func getCellAt(row: Int, col: Int) -> Bool
    
    func startRandom() 
    
}
