//
//  TetrisPresenter.swift
//  Tetris
//
//  Created by Илья Лысенко on 04.08.2025.
//

import Foundation

protocol TetrisViewProtocol: AnyObject {
    func updateGrid(_ grid: [[Int]])
}

class TetrisPresenter {
    
    private let model: TetrisModel
    private weak var view: TetrisViewProtocol?
    
    init(view: TetrisViewProtocol) {
        self.model = TetrisModel()
        self.view = view
    }
    
    func movePiece(_ direction: Direction) {
        model.movePiece(direction: direction)
        view?.updateGrid(model.grid)
    }
}
