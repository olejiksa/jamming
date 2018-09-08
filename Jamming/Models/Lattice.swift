//
//  Lattice.swift
//  Jamming
//
//  Created by Олег Самойлов on 10/04/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

import Foundation

protocol LatticeDelegate: class {
    func reloadData()
    func incrementProgress(by value: Double)
}

class Lattice {
    
    private var density = 0
    var inc = 0
    
    var placeholders = [Placeholder]()
    var blocks = [Block]()
    var cells = [[Cell]]()
    var tableViewData = [[String: String]]()
    
    var delegate: LatticeDelegate? 
    var size = 0
    
    func create(fieldSize: Int, blockLength: Int) {
        size = fieldSize
        
        // Creates the table
        for i in 0..<fieldSize {
            var vector = [Cell]()
            for j in 0..<fieldSize {
                vector.append(Cell(x: i, y: j))
            }
            cells.append(vector)
        }
        
        // Counts ways to place a block horizontally
        for i in 0..<fieldSize {
            for j in 0..<(fieldSize-blockLength+1) {
                let item = Placeholder()
                for k in j..<j+blockLength {
                    let c = cells[i][k]
                    item.cells.append(c)
                    c.placeholders.append(item)
                }
                placeholders.append(item)
            }
        }
        
        // And vertically too
        for item in placeholders {
            let newItem = Placeholder()
            for oldCell in item.cells {
                let c = cells[oldCell.y][oldCell.x]
                newItem.cells.append(c)
                c.placeholders.append(newItem)
            }
            placeholders.append(newItem)
        }
        
        // Fills the lattice
        while (!placeholders.isEmpty) {
            if !ViewController.isRunning {
                break
            }
            
            let index = random(0..<placeholders.count)
            let toRemove = placeholders[index]
            
            let leftX = toRemove.cells[0]
            let bottomY = toRemove.cells[toRemove.cells.count-1]
            let isHorizontal = leftX.x != bottomY.x
            
            let block = Block(id: inc, begin: leftX, end: bottomY, isHorizontal: isHorizontal, lattice: self)
            inc += 1
            blocks.append(block)
            
            density += blockLength
            let p = Double(density) / Double(fieldSize * fieldSize)
            let orientation = block.isHorizontal ? "Горизонтальная" : "Вертикальная"
            
            tableViewData.append([
                "Мест для ячейки": "\(placeholders.count)",
                "Координаты ячейки": "(\(block.begin.x), \(block.begin.y))",
                "Координаты хвоста": "(\(block.end.x), \(block.end.y))",
                "Ориентация": "\(orientation)",
                "ρ заполнения решетки": "\(p)",
                "Степеней свободы": "\(4)"])
            delegate?.reloadData()
            delegate?.incrementProgress(by: p * 100.0)
            
            for cell in toRemove.cells {
                for item in cell.placeholders {
                    if let i = self.placeholders.index(where: { $0 === item }) {
                        self.placeholders[i].cells.removeAll()
                        self.placeholders.remove(at: i)
                    }
                }
                
                cell.placeholders.removeAll()
                cell.isFilled = true
                cell.block = block
            }
            
            let degrees = 4 - block.neighborsCount
            tableViewData[block.id]["Степеней свободы"] = "\(degrees)"
            delegate?.reloadData()
            makeChartsData()
            
            for each in block.neighbors {
                let degrees = 4 - each.neighborsCount
                tableViewData[each.id]["Степеней свободы"] = "\(degrees)"
                delegate?.reloadData()
                makeChartsData()
            }
        }
        
        if ViewController.isRunning {
            self.delegate?.incrementProgress(by: 100.0)
        }
        
        density = 0
        inc = 0
    }
    
    private func random(_ range: Range<Int>) -> Int
    {
        let low = range.lowerBound
        let up = range.upperBound
        return low + Int(arc4random_uniform(UInt32(up - low)))
    }
    
    static var valuesForOneBig: [[Double]] = []
    static var valuesForTwoBig: [[Double]] = []
    
    static var codesForOneBig: [[String]] = []
    static var codesForTwoBig: [[String]] = []
    
    private func makeChartsData() {
        var valuesForOne: [Double] = [0, 0, 0, 0, 0]
        var valuesForTwo: [Double] = [0, 0, 0, 0, 0]
        
        var codesForOne = [String]()
        var codesForTwo = [String]()
        
        for i in 0..<blocks.count {
            if blocks[i].isHorizontal {
                let value = 4 - blocks[i].neighborsCount
                valuesForOne[value] = valuesForOne[value] + 1
                codesForOne.append(blocks[i].code)
            } else {
                let value = 4 - blocks[i].neighborsCount
                valuesForTwo[value] = valuesForTwo[value] + 1
                codesForTwo.append(blocks[i].code)
            }
        }
        
        Lattice.valuesForOneBig.append(valuesForOne)
        Lattice.valuesForTwoBig.append(valuesForTwo)
        
        Lattice.codesForOneBig.append(codesForOne)
        Lattice.codesForTwoBig.append(codesForTwo)
    }
    
}
