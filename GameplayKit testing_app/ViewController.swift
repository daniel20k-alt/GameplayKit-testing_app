//
//  ViewController.swift
//  GameplayKit testing_app
//
//  Created by DDDD on 23/10/2020.
//

import UIKit

var placedChips = [[UIView]]()
var board: Board!

class ViewController: UIViewController {
    
    @IBOutlet var columnButtons: [UIButton]!
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag

         if let row = board.nextEmptySlot(in: column) {
             board.add(chip: .red, in: column)
             addChip(inColumn: column, row: row, color: .red)
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }

        resetBoard()
    }
    
    func resetBoard() {
        board = Board()

        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }

            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    
    func addChip(inColumn column: Int, row: Int, color: UIColor) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)

        if (placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })

            placedChips[column].append(newChip)
        }
    }
    
    //determining where the chip should be placed
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)

        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }
    
    //updating the UI to show whose turn it is
    func updateUI() {
        title = "\(board.currentPlayer.name)'s turn"
    }
    
    
    //calling after every move, to see if the game has to end
    func continueGame() {
        var gameOverTitle: String? = nil
        
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }
        
        //alert controller that resets a draw game
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again!", style: .default) { [unowned self] (action) in
                self.resetBoard() }
            
            alert.addAction(alertAction)
            present(alert, animated:  true)
            
            return
        }
     
        //if game not over or not tie - change the player
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
        
    }
}
