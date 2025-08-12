//
//  ViewController.swift
//  Tetris
//
//  Created by Илья Лысенко on 04.08.2025.
//

import UIKit

class TetrisViewController: UIViewController, TetrisViewProtocol {

    private var rotateButton: UIButton!
    
    private var gridLabels: [[UILabel]] = []
    
    private let scoreLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        label.text = "0"
        return label
    }()
    
    private let gameOverLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textAlignment = .center
        label.text = "GAME OVER"
        label.isHidden = true
        return label
    }()
    
    private lazy var restartButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Restart", for: .normal)
        button.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.isHidden = true
        return button
    }()
    
    private lazy var presenter: TetrisPresenter = {
        return TetrisPresenter(view: self)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        presenter.startGame()
    }
    
    func updateScore(_ score: Int) {
        DispatchQueue.main.async {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            self.scoreLabel.text = formatter.string(from: NSNumber(value: score))
            
            UIView.animate(withDuration: 0.15, animations: {
                self.scoreLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }) { _ in
                UIView.animate(withDuration: 0.15) {
                    self.scoreLabel.transform = .identity
                }
            }
        }
    }
    
    func showGameOver(_ isVisible: Bool) {
        DispatchQueue.main.async {
            self.gameOverLabel.isHidden = !isVisible
            self.restartButton.isHidden = !isVisible
            
            if isVisible {
                self.view.bringSubviewToFront(self.gameOverLabel)
                self.view.bringSubviewToFront(self.restartButton)
            }
        }
    }
    
    func updateGrid(_ grid: [[Int]]) {
        DispatchQueue.main.async {
            for row in 0..<20 {
                for col in 0..<10 {
                    let cellValue = grid[row][col]
                    self.gridLabels[row][col].backgroundColor = cellValue == 0 ? .black : self.colorForCell(value: cellValue)
                }
            }
        }
    }
    
    @objc private func moveLeft() {
        presenter.movePiece(.left)
    }
    
    @objc private func moveRight() {
        presenter.movePiece(.right)
    }
    
    @objc private func moveDown() {
        presenter.movePiece(.down)
    }
    
    @objc private func restartGame() {
        presenter.startGame()
    }
    
    @objc internal func rotatePiece() {
        presenter.rotatePiece()
        
        
        // 2. Анимация кнопки (опционально)
        UIView.animate(withDuration: 0.1, animations: {
            self.rotateButton.transform = CGAffineTransform(rotationAngle: .pi/4)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.rotateButton.transform = .identity
            }
        }
    }
}

private extension TetrisViewController {
    func setupUI() {
        setupGameGrid()
        setupScoreLabel()
        setupGameOverLabel()
        setupRestartButton()
        setupControls()
        
        view.bringSubviewToFront(gameOverLabel)
        view.bringSubviewToFront(restartButton)
    }
    
    func setupScoreLabel() {
        view.addSubview(scoreLabel)
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            scoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupGameOverLabel() {
        view.addSubview(gameOverLabel)
        gameOverLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gameOverLabel.font = UIFont.boldSystemFont(ofSize: 42)
        gameOverLabel.numberOfLines = 0
        gameOverLabel.textAlignment = .center
        
        NSLayoutConstraint.activate([
            gameOverLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameOverLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameOverLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        gameOverLabel.layer.shadowColor = UIColor.black.cgColor
        gameOverLabel.layer.shadowRadius = 5
        gameOverLabel.layer.shadowOpacity = 1
        gameOverLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        view.bringSubviewToFront(gameOverLabel)
        view.bringSubviewToFront(restartButton)
    }
    
    func setupRestartButton() {
        view.addSubview(restartButton)
        restartButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            restartButton.topAnchor.constraint(equalTo: gameOverLabel.bottomAnchor, constant: 20),
            restartButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            restartButton.widthAnchor.constraint(equalToConstant: 120),
            restartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func setupGameGrid() {
        for row in 0..<20 {
            var rowLabels: [UILabel] = []
            for col in 0..<10 {
                let label = UILabel()
                label.frame = CGRect(
                    x: CGFloat(col) * 30 + 20,
                    y: CGFloat(row) * 30 + 50,
                    width: 28,
                    height: 28
                )
                label.backgroundColor = .black
                label.layer.borderWidth = 1
                label.layer.borderColor = UIColor.gray.cgColor
                view.addSubview(label)
                rowLabels.append(label)
            }
            gridLabels.append(rowLabels)
        }
    }
    
    func setupControls() {
        // 1. Сначала создаем все кнопки
        let leftButton = createButton(title: "←", action: #selector(moveLeft))
        let rightButton = createButton(title: "→", action: #selector(moveRight))
        let downButton = createButton(title: "↓", action: #selector(moveDown))
        let rotateButton = createButton(title: "↻", action: #selector(rotatePiece))
        
        // 2. Сохраняем кнопку поворота как свойство класса
        self.rotateButton = rotateButton
        
        // 3. Теперь создаем stackView
        let stackView = UIStackView(arrangedSubviews: [leftButton, downButton, rightButton, rotateButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 15
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // 4. Добавляем stackView на экран
        view.addSubview(stackView)
        
        // 5. Настраиваем констрейнты
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            leftButton.widthAnchor.constraint(equalToConstant: 60),
            rightButton.widthAnchor.constraint(equalToConstant: 60),
            downButton.widthAnchor.constraint(equalToConstant: 60),
            rotateButton.widthAnchor.constraint(equalToConstant: 60), // Добавляем для кнопки поворота
            leftButton.heightAnchor.constraint(equalToConstant: 40),
            rightButton.heightAnchor.constraint(equalToConstant: 40),
            downButton.heightAnchor.constraint(equalToConstant: 40),
            rotateButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        return button
    }
    
    func colorForCell(value: Int) -> UIColor {
        switch value {
        case 1: return .systemTeal    // I
        case 2: return .systemBlue    // J
        case 3: return .systemOrange  // L
        case 4: return .systemYellow  // O
        case 5: return .systemGreen   // S
        case 6: return .systemPurple  // T
        case 7: return .systemRed     // Z
        default: return .black
        }
    }
}
