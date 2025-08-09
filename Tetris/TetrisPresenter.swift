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
    func showGameOver(_ isVisible: Bool)
}

class TetrisPresenter {
    
    private let model: TetrisModel
    private weak var view: TetrisViewProtocol?
    private var score = 0
    private var timer: Timer?
    private var fallSpeed: TimeInterval = 1.0
    
    init(view: TetrisViewProtocol) {
        self.model = TetrisModel()
        self.view = view
    }
    
    func startGame() {
        score = 0
        model.reset()
        view?.updateScore(0)
        view?.showGameOver(false)
        startTimer()
        
    }
    
    private func  startTimer() {
        timer?.invalidate()
              timer = Timer.scheduledTimer(
                  withTimeInterval: fallSpeed,
                  repeats: true
              ) { [weak self] _ in
                  self?.movePiece(.down)
              }
    }
    
    func pauseGame() {
           timer?.invalidate()
       }
    
    func movePiece(_ direction: Direction) {
           if model.movePiece(direction: direction) {
               view?.updateGrid(model.getGridWithPiece())
           } else if direction == .down {
               handlePieceLanding()
           }
       }
    
    private func handlePieceLanding() {
          model.mergePiece()
          
          let linesCleared = model.clearLines()
          if linesCleared > 0 {
              addScore(for: linesCleared)
              increaseSpeedIfNeeded()
          }
          
          if model.isGameOver() {
              endGame()
              return
          }
          
          model.generateNewPiece()
          view?.updateGrid(model.getGridWithPiece())
      }
    
    private func increaseSpeedIfNeeded() {

           if score % 1000 == 0 {
               fallSpeed *= 0.95
               startTimer()
           }
       }
       
       private func endGame() {
           timer?.invalidate()
           view?.showGameOver(true)
       }
    
    private func addScore(for lines: Int) {
        switch lines {
        case 1: score += 100
        case 2: score += 300
        case 3: score += 500
        case 4: score += 800
        default: break
        }
        view?.updateScore(score) 
    }
}
