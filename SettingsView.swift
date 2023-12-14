//
//  SettingsView.swift
//  minesweeperui
//
//  Created by Rodrigo de Leon Castilla on 12/12/23.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: MinesweeperViewModel
    @State private var inputRows = "10"
    @State private var inputColumns = "10"
    @State private var inputMines = "15"
    
    var body: some View {
        Form {
            Section(header: Text("Customize Game")) {
                TextField("Rows", text: $inputRows)
                    .keyboardType(.numberPad)
                TextField("Columns", text: $inputColumns)
                    .keyboardType(.numberPad)
                TextField("Mines", text: $inputMines)
                    .keyboardType(.numberPad)
                Button("Start Game") {
                    updateGameSettings()
                }
            }
        }
    }
    
    private func updateGameSettings() {
        if let rows = Int(inputRows), let columns = Int(inputColumns), let mines = Int(inputMines) {
            viewModel.rows = rows
            viewModel.columns = columns
            viewModel.mineCount = mines
            viewModel.startGame()
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(viewModel: MinesweeperViewModel())
    }
}
