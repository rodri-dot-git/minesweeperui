//
//  ContentView.swift
//  minesweeperui
//
//  Created by Rodrigo de Leon Castilla on 12/12/23.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = MinesweeperViewModel()
    
    var body: some View {
        VStack {
            gameStatusView
            gameGridView
        }
    }

    var gameStatusView: some View {
        HStack() {
            Text(viewModel.gameStatusText)
                .font(.headline)
                .padding()
            Button("Restart Game") {
                viewModel.restartGame()
            }
        }
    }

    var gameGridView: some View {
        VStack(spacing: 0) {
            ForEach(0..<viewModel.rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<viewModel.columns, id: \.self) { column in
                        TileView(viewModel: viewModel, tile: viewModel.grid[row][column])
                        .onTapGesture {
                            viewModel.tapTile(atRow: row, column: column)
                        }
                        .onLongPressGesture {
                            viewModel.flagTile(atRow: row, column: column)
                        }
                    }
                }
            }
        }
    }
}

extension MinesweeperViewModel {
    var gameStatusText: String {
        switch gameStatus {
        case .playing:
            return "Game in Progress"
        case .won:
            return "Congratulations, You Won!"
        case .lost:
            return "Game Over"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
