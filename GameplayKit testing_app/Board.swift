//
//  Board.swift
//  GameplayKit testing_app
//
//  Created by DDDD on 26/10/2020.
//

import UIKit
import GameplayKit

enum ChipColor: Int {
    case none = 0
    case red
    case black
}

class Board: NSObject, GKGameModel, NSCopying {
    //nscopying - gameplayKit will copy multiple instances of the game board
    
    static var width = 7
    static var height = 6
    
    var slots = [ChipColor]()
    
    var currentPlayer: Player
    
    //all slots will have no chip in them by default
    override init() {
        
        currentPlayer = Player.allPlayers[0]
        
        for _ in 0 ..< Board.width * Board.height {
            slots.append(.none)
        }
        super.init()
    }
    
    
    func chip(inColumn column: Int, row: Int) -> ChipColor {
        return slots[row + column * Board.height]
    }

    
    func set(chip: ChipColor, in column: Int, row: Int) {
        slots[row + column * Board.height] = chip
    }
    
    
    func nextEmptySlot(in column: Int) -> Int? {
        for row in 0 ..< Board.height {
            if chip(inColumn: column, row: row) == .none {
                return row
            }
        }

        return nil
    }
    
    
    func canMove(in column: Int) -> Bool {
        return nextEmptySlot(in: column) != nil
    }
    
    
    func add(chip: ChipColor, in column: Int) {
        if let row = nextEmptySlot(in: column) {
            set(chip: chip, in: column, row: row)
        }
    }
    
    //updating the UI to show whose turn it is
    
    func isFull() -> Bool {
        
        for column in 0 ..< Board.width {
            if canMove(in: column) {
                return false
            }
        }
        return true
    }
    
    func isWin(for player: GKGameModelPlayer) -> Bool {
        let chip = (player as! Player).chip
        
        for row in 0 ..< Board.height {
            for col in 0 ..< Board.width {
                if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 0) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 0, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: 1) {
                    return true
                } else if squaresMatch(initialChip: chip, row: row, col: col, moveX: 1, moveY: -1) {
                    return true
                }
            }
        }

        return false
    }
    
    //checking the wins
    func squaresMatch(initialChip: ChipColor, row: Int, col: Int, moveX: Int, moveY: Int) -> Bool {
        
        //leaving the method if at least 1 space is not ok
        if row + (moveY * 3) < 0 { return false } //lower than height
        if row + (moveY * 3) >= Board.height { return false } //higher than height
        if col + (moveX * 3) < 0 { return false } //greather than width
        if col + (moveX * 3) >= Board.width { return false }
        
        //if any of the above didnt check, continue the test
        if chip(inColumn: col, row: row) != initialChip { return false }
        if chip(inColumn: col + moveX, row: row + moveY) != initialChip { return false }
        if chip(inColumn: col + (moveX * 2), row: row + (moveY * 2)) != initialChip { return false }
        if chip(inColumn: col + (moveX * 3), row: row + (moveY * 3)) != initialChip { return false }
        
        return true
    }
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.setGameModel(self)
        return copy
    }
    
    
    func setGameModel(_ gameModel: GKGameModel) {
        if let board = gameModel as? Board {
            slots = board.slots
            currentPlayer = board.currentPlayer
        }
    }
    
    
    func gameModelUpdates(for player: GKGameModelPlayer) -> [GKGameModelUpdate]? {
        
        //downcasting the GKGameModelPlayer parameter into Player object
        if let playerObject  = player as? Player {
            
            if isWin(for: playerObject) || isWin(for: playerObject.opponent) {
                return nil //if either has won - no moves available
            }
            
            var moves = [Move]() //array will hold Move objects
            
                //looping to see whether the player can move in that colum
            for column in 0 ..< Board.width {
                if canMove(in: column) {
                    moves.append(Move(column: column)) //appending the array of possible moves
                }
            }
            
            return moves //telling the AI the moves it can make
        }
        
        return nil
    }
    
    //AI trying all the moves
    func apply(_ gameModelUpdate: GKGameModelUpdate) {
        if let move = gameModelUpdate as? Move {
            add(chip: currentPlayer.chip, in: move.column)
            currentPlayer = currentPlayer.opponent
        }
    }
    
    
    
    
    
    
    
    
}
