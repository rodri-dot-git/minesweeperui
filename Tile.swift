//
//  Tile.swift
//  minesweeper
//
//  Created by Rodrigo de Leon Castilla on 12/12/23.
//

import Foundation

struct Tile {
    var isMine: Bool = false
    var isRevealed: Bool = false
    var isFlagged: Bool = false
    var adjacentMines: Int = 0
    // Add more properties as needed, like adjacent mines count
}
