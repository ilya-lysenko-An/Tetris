//
//  TetrisModel.swift
//  Tetris
//
//  Created by Илья Лысенко on 04.08.2025.
//

import Foundation
import UIKit

class TetrisModel {
    // Основная сетка
    private var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 10), count: 20)
    
    // Текущее состояние
    private var currentType: TetrominoType = .I
    private var currentPosition: (row: Int, col: Int) = (0, 3) // Стартовая позиция
    
    // Текущая фигура (вычисляемое свойство)
    var currentPiece: [[Int]] {
        return Tetromino.shapes[currentType] ?? []
    }
    
    func movePiece(direction: Direction) -> Bool {
        let newPosition: (row: Int, col: Int)
        
        switch direction {
        case .left:
            newPosition = (currentPosition.row, currentPosition.col - 1)
        case .right:
            newPosition = (currentPosition.row, currentPosition.col + 1)
        case .down:
            newPosition = (currentPosition.row + 1, currentPosition.col)
        }
        
        if canMove(to: newPosition) {
            currentPosition = newPosition
            print("Фигура перемещена:", currentPosition)
            return true
        }
        return false
    }
    
    private func canMove(to position: (row: Int, col: Int)) -> Bool {
        for (i, row) in currentPiece.enumerated() {
            for (j, cell) in row.enumerated() where cell != 0 {
                let newRow = position.row + i
                let newCol = position.col + j
                
                guard newCol >= 0, newCol < 10, newRow < 20 else { return false }
                
                if newRow >= 0 && grid[newRow][newCol] != 0 {
                    return false
                }
            }
        }
        return true
    }
    
    func getGridWithPiece() -> [[Int]] {
        var grid = self.grid.map { $0.map { $0 > 0 ? $0 : 0 } }
        
        for (i, row) in currentPiece.enumerated() {
            for (j, cell) in row.enumerated() where cell != 0 {
                let r = currentPosition.row + i
                let c = currentPosition.col + j
                if (0..<20).contains(r) && (0..<10).contains(c) {
                    grid[r][c] = currentType.rawValue + 1
                }
            }
        }
        return grid
    }
    
    func generateNewPiece() {
        currentType = TetrominoType.allCases.randomElement() ?? .I
        currentPosition = (0, 3) // Сброс позиции
    }
    
}

enum Direction {
    case left, right, down
}

enum TetrominoType: Int, CaseIterable {
    case I, J, L, O, S, T, Z
    
    var color: UIColor {
        switch self {
        case .I: return .systemTeal
        case .J: return .systemBlue
        case .L: return .systemOrange
        case .O: return .systemYellow
        case .S: return .systemGreen
        case .T: return .systemPurple
        case .Z: return .systemRed
        }
    }
}

struct Tetromino {
    static let shapes: [TetrominoType: [[Int]]] = [
        .I: [
            [0, 0, 0, 0],
            [1, 1, 1, 1],
            [0, 0, 0, 0],
            [0, 0, 0, 0]
        ],
        .J: [
            [1, 0, 0],
            [1, 1, 1],
            [0, 0, 0]
        ],
        .L: [
            [0, 0, 1],
            [1, 1, 1],
            [0, 0, 0]
        ],
        .O: [
            [1, 1],
            [1, 1]
        ],
        .S: [
            [0, 1, 1],
            [1, 1, 0],
            [0, 0, 0]
        ],
        .T: [
            [0, 1, 0],
            [1, 1, 1],
            [0, 0, 0]
        ],
        .Z: [
            [1, 1, 0],
            [0, 1, 1],
            [0, 0, 0]
        ]
    ]
}
