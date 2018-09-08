//
//  Cell.swift
//  Jamming
//
//  Created by Олег Самойлов on 10/04/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

class Cell {
    
    var x: Int
    var y: Int
    var placeholders = [Placeholder]()
    var block: Block?
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
    
    var isFilled = false
    
}
