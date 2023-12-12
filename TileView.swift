//
//  TileView.swift
//  minesweeper
//
//  Created by Rodrigo de Leon Castilla on 12/12/23.
//

import SwiftUI

struct TileView: View {
    var tile: Tile

    var body: some View {
        ZStack {
            if tile.isRevealed {
                if tile.isMine {
                    // Use an emoji or a custom image for mine
                    Text("💣")
                        .font(.system(size: 18))
                } else {
                    // Display number of adjacent mines or empty for no mines
                    Text(tile.adjacentMines > 0 ? "\(tile.adjacentMines)" : "")
                        .foregroundColor(colorForNumber(tile.adjacentMines))
                        .font(.system(size: 18))
                }
            } else {
                if tile.isFlagged {
                    // Use an emoji or a custom image for flag
                    Text("🚩")
                        .font(.system(size: 18))
                } else {
                    // Display default covered tile
                    Rectangle()
                        .foregroundColor(.gray)
                }
            }
        }
        .frame(width: 30, height: 30)
        .border(Color.black)
    }

    func colorForNumber(_ number: Int) -> Color {
        switch number {
        case 1: return .blue
        case 2: return .green
        case 3: return .red
        default: return .black
        }
    }
}

struct TileView_Previews: PreviewProvider {
    static var previews: some View {
        TileView(tile: Tile(isMine: false, isRevealed: false, isFlagged: true))
            .previewLayout(.sizeThatFits)
    }
}
