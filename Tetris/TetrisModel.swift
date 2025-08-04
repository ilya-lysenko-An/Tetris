//
//  TetrisModel.swift
//  Tetris
//
//  Created by Илья Лысенко on 04.08.2025.
//

import Foundation
import UIKit

class TetrisModel {
    
    var grid: [[Int]] = Array(repeating: Array(repeating: 0, count: 10), count: 20)
    
    var currentPiece: (type: Int, position: (row: Int, col: Int)) = (1, (0, 4))
    
    func movePiece(direction: Direction) {
        switch direction {
        case .left:
            currentPiece.position.col -= 1
        case .right:
            currentPiece.position.col += 1
        case .down:
            currentPiece.position.row = 1
        }
        print("Фигура перемещена:", currentPiece.position)
    }
}

enum Direction {
    case left, right, down
}
