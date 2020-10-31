//
//  Move.swift
//  GameplayKit testing_app
//
//  Created by DDDD on 31/10/2020.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
}
