//
//  ViewController.swift
//  Tetris
//
//  Created by Илья Лысенко on 04.08.2025.
//

import UIKit

class TetrisViewController: UIViewController, TetrisViewProtocol {
    
    private lazy var presenter: TetrisPresenter = {
           return TetrisPresenter(view: self)
       }()
    private var gridLabels: [[UILabel]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGameGrid()
        setupControls()
        
        presenter = TetrisPresenter(view: self)
    }
}
    private extension TetrisViewController {
        func  setupGameGrid() {
            for row in 0..<20 {
                var rowLabels: [UILabel] = []
                for col in 0..<10 {
                    var label = UILabel()
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
    }
private extension TetrisViewController {
    private func setupControls() {
       
        let leftButton = createButton(title: "←", action: #selector(moveLeft))
        let rightButton = createButton(title: "→", action: #selector(moveRight))
        let downButton = createButton(title: "↓", action: #selector(moveDown))
        
        let stackView = UIStackView(arrangedSubviews: [leftButton, downButton, rightButton])
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            leftButton.widthAnchor.constraint(equalToConstant: 60),
            rightButton.widthAnchor.constraint(equalToConstant: 60),
            downButton.widthAnchor.constraint(equalToConstant: 60),
            leftButton.heightAnchor.constraint(equalToConstant: 40),
            rightButton.heightAnchor.constraint(equalToConstant: 40),
            downButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

 
    private func createButton(title: String, action: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: action, for: .touchUpInside)
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 8
        return button
    }
    @objc func moveLeft() {
        presenter.movePiece(Direction .left)
        
    }
    @objc  func moveRight() {
        presenter.movePiece(Direction .right)
       }
    @objc  func moveDown() {
        presenter.movePiece(Direction .down)
       }
}

extension TetrisViewController  {
    func updateGrid(_ grid: [[Int]]) {
        for row in 0..<20 {
            for col in 0..<10 {
                let cellValue = grid[row][col]
                gridLabels[row][col].backgroundColor = cellValue == 0 ? .black : .systemBlue
            }
        }
    }
}
