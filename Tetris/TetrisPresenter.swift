//
//  TetrisPresenter.swift
//  Tetris
//
//  Created by Илья Лысенко on 04.08.2025.
//

import Foundation

protocol TetrisViewProtocol: AnyObject {
    func updateGrid(_ grid: [[Int]])
    func updateScore(_ score: Int)
}

class TetrisPresenter {
    
    private let model: TetrisModel
    private weak var view: TetrisViewProtocol?
    
    init(view: TetrisViewProtocol) {
        self.model = TetrisModel()
        self.view = view
    }
    
    private var score = 0

    func addScore(for lines: Int) {
        switch lines {
        case 1: score += 100
        case 2: score += 300
        case 3: score += 500
        case 4: score += 800  // За Tetris!
        default: break
        }
        view?.updateScore(score)
    }
    
    func movePiece(_ direction: Direction) {
        if model.movePiece(direction: direction) {
            view?.updateGrid(model.getGridWithPiece())
        } else if direction == .down {
            model.mergePiece()
            let linesCleared = model.clearLines()
            if linesCleared > 0 {
                addScore(for: linesCleared)
            }
            model.generateNewPiece()
            view?.updateGrid(model.getGridWithPiece())
        }
    }
}
