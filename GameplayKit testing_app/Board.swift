//
//  Board.swift
//  GameplayKit testing_app
//
//  Created by DDDD on 26/10/2020.
//

import UIKit

enum ChipColor: Int {
    case none = 0
    case red
    case black
}

class Board: NSObject {
    
    static var width = 7
    static var height = 6
    
    var slots = [ChipColor]()
    
    //all slots will have no chip in them by default
    override init() {
        for _ in 0 ..< Board.width * Board.height {
            slots.append(.none)
        }
        super.init()
    }

}
