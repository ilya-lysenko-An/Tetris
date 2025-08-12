//
//  TetrisModel.swift
//  Tetris
//
//  Created by Илья Лысенко on 04.08.2025.
//

import Foundation
import UIKit

class TetrisModel {
    
    private var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 10), count: 20)
    private var _currentPiece: [[Int]] = Tetromino.shapes[.I]![0]
    private var currentPosition: (row: Int, col: Int) = (0, 3)
    private var currentRotation = 0
    
    var currentPiece: [[Int]] {
         get { return _currentPiece }
         set { _currentPiece = newValue }
     }
    
    var currentType: TetrominoType {
        for (type, rotations) in Tetromino.shapes {
            if rotations.contains(where: { $0 == _currentPiece }) {
                return type
            }
        }
        return .I
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
          let randomType = TetrominoType.allCases.randomElement() ?? .I
        _currentPiece = Tetromino.shapes[randomType]![0]
          currentPosition = (0, 3)
      }
    
    
    func rotate() -> Bool {
        guard currentType != .O else { return false } // Квадрат не вращается
        
        let rotations = Tetromino.shapes[currentType]!
        let newRotationIndex = (currentRotation + 1) % rotations.count
        let rotatedPiece = rotations[newRotationIndex]
        
        if canPlace(rotatedPiece, at: currentPosition) {
            _currentPiece = rotatedPiece
            currentRotation = newRotationIndex
            return true
        }
        
        // Попробуем Wall Kick (сдвиг при повороте у стенки)
        return tryWallKick(rotatedPiece: rotatedPiece)
    }

    private func rotateMatrix(_ matrix: [[Int]]) -> [[Int]] {
        let size = matrix.count
        var result = Array(repeating: Array(repeating: 0, count: size), count: size)
        for i in 0..<size {
            for j in 0..<size {
                result[j][size - 1 - i] = matrix[i][j]
            }
        }
        return result
    }

    private func tryWallKick(rotatedPiece: [[Int]]) -> Bool {
        let offsets = [(0, -1), (0, 1), (-1, 0), (1, 0)] // Смещения: влево, вправо, вверх, вниз
        
        for (dx, dy) in offsets {
            let newPosition = (row: currentPosition.row + dy, col: currentPosition.col + dx)
            if canPlace(rotatedPiece, at: newPosition) {
                _currentPiece = rotatedPiece
                currentPosition = newPosition
                currentRotation = (currentRotation + 1) % Tetromino.shapes[currentType]!.count
                return true
            }
        }
        
        return false
    }
    
    private func canPlace(_ piece: [[Int]], at position: (row: Int, col: Int)) -> Bool {
        for (i, row) in piece.enumerated() {
            for (j, cell ) in row.enumerated() where cell != 0 {
                let r = position.row + i
                let c = position.col + j
                if r >= 20 || c < 0 || c >= 10 || (r >= 0 && grid[r][c] != 0){
                    
                }
            }
        }
        return true
    }
    
    func mergePiece() {
        for (i, row) in currentPiece.enumerated() {
            for (j, cell) in row.enumerated() where cell != 0 {
                let r = currentPosition.row + i
                let c = currentPosition.col + j
                if (0..<20).contains(r) && (0..<10).contains(c) {
                    grid[r][c] = currentType.rawValue + 1 // +1 чтобы 0 оставался пустым
                }
            }
        }
    }
    
    func clearLines() -> Int {
        var linesCleared = 0
        grid = grid.filter { row in
            let isFull = !row.contains(0)
            if isFull { linesCleared += 1 }
            return !isFull
        }
        
        for _ in 0..<linesCleared {
             grid.insert(Array(repeating: 0, count: 10), at: 0)
         }
         
         return linesCleared
     }
    
    func reset() {
        grid = Array(repeating: Array(repeating: 0, count: 10), count: 20)
        generateNewPiece()
    }
    
    func isGameOver() -> Bool {
        for (i, row) in currentPiece.enumerated() {
            for (j, cell) in row.enumerated() where cell != 0 {
                let r = currentPosition.row + i
                if r <= 1 { // Фигура в верхних 2 рядах
                    return true
                }
            }
        }
        return false
    }
    
}

enum Direction {
    case left, right, down
}



