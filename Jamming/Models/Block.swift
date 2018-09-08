//
//  Block.swift
//  Jamming
//
//  Created by Олег Самойлов on 11/04/2018.
//  Copyright © 2018 Oleg Samoylov. All rights reserved.
//

struct Block {
    
    let id: Int
    let begin, end: Cell
    let isHorizontal: Bool
    
    // MARK: - Neighbors
    
    weak var lattice: Lattice?
    
    private var hasNorthernNeighbor: Bool {
        guard let field = lattice else { return false }
        
        if isHorizontal {
            if begin.y > 0 {
                var flag = false
                for x in begin.x...end.x {
                    if field.cells[x][begin.y - 1].isFilled {
                        flag = true
                        break
                    }
                }
                
                return flag
            } else {
                return true
            }
        } else {
            if begin.y > 0 {
                if field.cells[begin.x][begin.y - 1].isFilled {
                    return true
                }
            } else {
                return true
            }
        }
        
        return false
    }
    
    private var northernNeighbors: [Block] {
        guard let field = lattice else { return [Block]() }
        var blocks = [Block]()
        
        if isHorizontal {
            if begin.y > 0 {
                for x in begin.x...end.x {
                    if field.cells[x][begin.y - 1].isFilled {
                        blocks.append(field.cells[x][begin.y - 1].block!)
                    }
                }
            }
        } else {
            if begin.y > 0 {
                if field.cells[begin.x][begin.y - 1].isFilled {
                    blocks.append(field.cells[begin.x][begin.y - 1].block!)
                }
            }
        }
        
        return blocks
    }
    
    private var hasSouthernNeighbor: Bool {
        guard let field = lattice else { return false }
        
        if isHorizontal {
            if end.y < field.size - 1 {
                var flag = false
                for x in begin.x...end.x {
                    if field.cells[x][begin.y + 1].isFilled {
                        flag = true
                        break
                    }
                }
                
                return flag
            } else {
                return true
            }
        } else {
            if end.y < field.size - 1 {
                if field.cells[end.x][end.y + 1].isFilled {
                    return true
                }
            } else {
                return true
            }
        }
        
        return false
    }
    
    private var southernNeighbors: [Block] {
        guard let field = lattice else { return [Block]() }
        var blocks = [Block]()

        if isHorizontal {
            if end.y < field.size - 1 {
                for x in begin.x...end.x {
                    if field.cells[x][begin.y + 1].isFilled {
                        blocks.append(field.cells[x][begin.y + 1].block!)
                    }
                }
            }
        } else {
            if end.y < field.size - 1 {
                if field.cells[end.x][end.y + 1].isFilled {
                    blocks.append(field.cells[end.x][end.y + 1].block!)
                }
            }
        }
        
        return blocks
    }
    
    private var hasWesternNeighbor: Bool {
        guard let field = lattice else { return false }
        
        if isHorizontal {
            if begin.x > 0 {
                if field.cells[begin.x - 1][begin.y].isFilled {
                    return true
                }
            } else {
                return true
            }
        } else {
            if begin.x > 0 {
                var flag = false
                for y in begin.y...end.y {
                    if field.cells[begin.x - 1][y].isFilled {
                        flag = true
                        break
                    }
                }
                
                return flag
            } else {
                return true
            }
        }
        
        return false
    }
    
    private var westernNeighbors: [Block] {
        guard let field = lattice else { return [Block]() }
        var blocks = [Block]()

        if isHorizontal {
            if begin.x > 0 {
                if field.cells[begin.x - 1][begin.y].isFilled {
                    blocks.append(field.cells[begin.x - 1][begin.y].block!)
                }
            }
        } else {
            if begin.x > 0 {
                for y in begin.y...end.y {
                    if field.cells[begin.x - 1][y].isFilled {
                        blocks.append(field.cells[begin.x - 1][y].block!)
                    }
                }
            }
        }
        
        return blocks
    }
    
    private var hasEasternNeighbor: Bool {
        guard let field = lattice else { return false }
        
        if isHorizontal {
            if end.x < field.size - 1 {
                if field.cells[end.x + 1][end.y].isFilled {
                    return true
                }
            } else {
                return true
            }
        } else {
            if end.x < field.size - 1 {
                var flag = false
                for y in begin.y...end.y {
                    if field.cells[end.x + 1][y].isFilled {
                        flag = true
                        break
                    }
                }
                
                return flag
            } else {
                return true
            }
        }
        
        return false
    }
    
    private var easternNeighbors: [Block] {
        guard let field = lattice else { return [Block]() }
        var blocks = [Block]()

        if isHorizontal {
            if end.x < field.size - 1 {
                if field.cells[end.x + 1][end.y].isFilled {
                    blocks.append(field.cells[end.x + 1][end.y].block!)
                }
            }
        } else {
            if end.x < field.size - 1 {
                for y in begin.y...end.y {
                    if field.cells[end.x + 1][y].isFilled {
                        blocks.append(field.cells[end.x + 1][y].block!)
                    }
                }
            }
        }
        
        return blocks
    }
    
    var neighbors: [Block] {
        var blocks = [Block]()
        
        blocks.append(contentsOf: northernNeighbors)
        blocks.append(contentsOf: southernNeighbors)
        blocks.append(contentsOf: westernNeighbors)
        blocks.append(contentsOf: easternNeighbors)
        
        return blocks
    }
    
    var code: String {
        var somecodes = "NSWE"

        if hasNorthernNeighbor {
            somecodes.remove(at: somecodes.index(of: "N")!)
        }
        
        if hasSouthernNeighbor {
            somecodes.remove(at: somecodes.index(of: "S")!)
        }
        
        if hasWesternNeighbor {
            somecodes.remove(at: somecodes.index(of: "W")!)
        }
        
        if hasEasternNeighbor {
            somecodes.remove(at: somecodes.index(of: "E")!)
        }
        
        return somecodes
    }
    
    var neighborsCount: Int {
        var count = 0
        
        if hasNorthernNeighbor {
            count += 1
        }
        
        if hasSouthernNeighbor {
            count += 1
        }
        
        if hasWesternNeighbor {
            count += 1
        }
        
        if hasEasternNeighbor {
            count += 1
        }
        
        return count
    }
    
}
