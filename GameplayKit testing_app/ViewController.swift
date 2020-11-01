//
//  ViewController.swift
//  GameplayKit testing_app
//
//  Created by DDDD on 23/10/2020.
//

import UIKit
import GameplayKit

var placedChips = [[UIView]]()
var board: Board!

var strategist: GKMinmaxStrategist!

class ViewController: UIViewController {
    
    @IBOutlet var columnButtons: [UIButton]!
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag

         if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column) //adds the current player's chip
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            continueGame() //automatically switches players after each move
         }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 5
        strategist.randomSource = nil //returning the first best move in a tie of options
       // strategist.randomSource = GKARC4RandomSource() //random best move
        
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }

        resetBoard()
    }
    
    func resetBoard() {
        board = Board()
        
        strategist.gameModel = board //sending all new boards to the strategist to analyze
        
        updateUI()

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
       
        //activating the AI when it's black's move
        if board.currentPlayer.chip == .black {
            startAIMove()
        }
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
    
    
    func columnForAIMove() -> Int? { //return an Int? for best column for a move
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }
        
        return nil
    }
    
    //once the above move has been found, it has to be run
    func makeAIMove(in column: Int) {
        
        //the activity buttons dissapears when the AI finished its move
        columnButtons.forEach { $0.isEnabled = true }
        navigationItem.leftBarButtonItem = nil
        
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, color: board.currentPlayer.color)
            
            continueGame() //checking for win or draw, and move the turn
        }
    }
    
    //combining the above methods to create the move
    func startAIMove() {
        //disabling the column buttons and show the activity spinner
        columnButtons.forEach { $0.isEnabled = false } //looping through each item in the array and $0 dissabling
        
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
       ///

        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent() //computes differences in time
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime
            
            let aiTimeCeiling = 1.0 //standard time
            let delay = aiTimeCeiling - delta //making the AI take 1 second to display the move
            
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(in: column)
            }
        }
    }
}
