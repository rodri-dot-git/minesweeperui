//
//  MinesweeperViewModel.swift
//  minesweeper
//
//  Created by Rodrigo de Leon Castilla on 12/12/23.
//

import Foundation
import UIKit

class MinesweeperViewModel: ObservableObject {
    @Published var grid: [[Tile]] = []
    @Published var rows = 20 // Default value
    @Published var columns = 10 // Default value
    @Published var mineCount = 20 // Default value
    @Published var gameStatus: GameStatus = .playing
    private var gameStarted = false
    
    enum GameStatus {
        case playing, won, lost
    }

    init() {
        startGame()
    }

    func startGame() {
        // Initialize the grid with no mines
        grid = Array(repeating: Array(repeating: Tile(), count: columns), count: rows)
    }
    
    func firstClick(row: Int, column: Int) {
        placeMines(exceptAtRow: row, andColumn: column)
        revealTile(atRow: row, column: column)
        // Continue with the game...
    }

    private func placeMines(exceptAtRow excludedRow: Int, andColumn excludedColumn: Int) {
        var minesPlaced = 0
        while minesPlaced < mineCount {
            let randomRow = Int.random(in: 0..<rows)
            let randomColumn = Int.random(in: 0..<columns)

            // Check if the tile is not the first clicked tile, not adjacent to it, and does not already have a mine
            if isSafeToPlaceMine(atRow: randomRow, column: randomColumn, excludedRow: excludedRow, excludedColumn: excludedColumn) {
                grid[randomRow][randomColumn].isMine = true
                minesPlaced += 1
            }
        }

        // Calculate adjacent mines for each tile
        for row in 0..<rows {
            for column in 0..<columns {
                grid[row][column].adjacentMines = countAdjacentMines(row: row, column: column)
            }
        }
    }

    private func isSafeToPlaceMine(atRow row: Int, column: Int, excludedRow: Int, excludedColumn: Int) -> Bool {
        if abs(row - excludedRow) <= 1 && abs(column - excludedColumn) <= 1 {
            return false // Tile is the first clicked tile or adjacent to it
        }
        return !grid[row][column].isMine // Tile does not already have a mine
    }
    
    private func countAdjacentMines(row: Int, column: Int) -> Int {
        var count = 0
        for i in max(row - 1, 0)...min(row + 1, rows - 1) {
            for j in max(column - 1, 0)...min(column + 1, columns - 1) {
                if !(i == row && j == column) && grid[i][j].isMine {
                    count += 1
                }
            }
        }
        return count
    }
    func restartGame() {
            gameStarted = false
            gameStatus = .playing
            startGame() // This should reinitialize the grid
        }

    func tapTile(atRow row: Int, column: Int) {
        guard gameStatus == .playing else { return }

        if !gameStarted {
            firstClick(row: row, column: column)
            gameStarted = true
        } else {
            revealTile(atRow: row, column: column)
            // Continue with regular game logic...
        }
    }
    
    func revealTile(atRow row: Int, column: Int) {
        // Check if the tile is already revealed or flagged
        if grid[row][column].isRevealed || grid[row][column].isFlagged {
            return
        }

        // Reveal the tile
        grid[row][column].isRevealed = true

        // If the tile is a mine, trigger game over logic
        if grid[row][column].isMine {
            gameStatus = .lost
            revealAllMines()
            return
        }

        // If the tile has 0 adjacent mines, reveal adjacent tiles
        if grid[row][column].adjacentMines == 0 {
            // Reveal all adjacent tiles
            for i in max(row - 1, 0)...min(row + 1, rows - 1) {
                for j in max(column - 1, 0)...min(column + 1, columns - 1) {
                    if !(i == row && j == column) {
                        revealTile(atRow: i, column: j)
                    }
                }
            }
        }

        // Check for win
        if checkForWin() {
            gameStatus = .won
        }
    }
    
    private func revealAllMines() {
        for row in 0..<rows {
            for column in 0..<columns {
                if grid[row][column].isMine {
                    grid[row][column].isRevealed = true
                }
            }
        }
    }

    private func checkForWin() -> Bool {
        let nonMineTiles = rows * columns - mineCount
        let revealedTiles = grid.flatMap { $0 }.filter { $0.isRevealed && !$0.isMine }.count
        
        if revealedTiles == nonMineTiles {
            gameStatus = .won
            revealAllMines()
            return true
        }
        return false
    }

    func flagTile(atRow row: Int, column: Int) {
        guard gameStatus == .playing else { return }

        // Check if the tile is already revealed
        if grid[row][column].isRevealed {
            return
        }

        // Toggle the flag state
        grid[row][column].isFlagged.toggle()

        // Trigger haptic feedback
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()

        // Update remaining mines count or any other related logic if necessary
        // For example, if you're keeping track of how many flags are placed
    }


}
