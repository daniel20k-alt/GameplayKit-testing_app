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
        
        for i in 0...placedChips.count {
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
            newChip.layer.cornerRadius = size / 2 //making it a circle
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)
            
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })
            
            placedChips[column].append(newChip)
            
        }
    }
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height)
        
        let xOffset = button.frame.midX
        let yOffset = button.frame.midY
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }
}

