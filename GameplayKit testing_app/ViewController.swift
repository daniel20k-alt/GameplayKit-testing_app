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
}

