//
//  Tetromino.swift
//  Tetris
//
//  Created by Илья Лысенко on 09.08.2025.
//

// Tetromino.swift
import UIKit

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
    
    var initialOrientation: Int { 0 }
    
    var rotationCount: Int {
        switch self {
        case .O: return 1
        case .I, .S, .Z: return 2
        case .J, .L, .T: return 4
        }
    }
}

struct Tetromino {
    static let shapes: [TetrominoType: [[[Int]]]] = [
        .I: [
                    [
                        [0, 0, 0, 0],
                        [1, 1, 1, 1],
                        [0, 0, 0, 0],
                        [0, 0, 0, 0]
                    ],
                    [
                        [0, 0, 1, 0],
                        [0, 0, 1, 0],
                        [0, 0, 1, 0],
                        [0, 0, 1, 0]
                    ],
                    [
                        [0, 0, 0, 0],
                        [0, 0, 0, 0],
                        [1, 1, 1, 1],
                        [0, 0, 0, 0]
                    ],
                    [
                        [0, 1, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0],
                        [0, 1, 0, 0]
                    ]
                ],
                
                // J-фигура (4 положения)
                .J: [
                    [
                        [1, 0, 0],
                        [1, 1, 1],
                        [0, 0, 0]
                    ],
                    [
                        [0, 1, 1],
                        [0, 1, 0],
                        [0, 1, 0]
                    ],
                    [
                        [0, 0, 0],
                        [1, 1, 1],
                        [0, 0, 1]
                    ],
                    [
                        [0, 1, 0],
                        [0, 1, 0],
                        [1, 1, 0]
                    ]
                ],
                
                // L-фигура (4 положения)
                .L: [
                    [
                        [0, 0, 1],
                        [1, 1, 1],
                        [0, 0, 0]
                    ],
                    [
                        [0, 1, 0],
                        [0, 1, 0],
                        [0, 1, 1]
                    ],
                    [
                        [0, 0, 0],
                        [1, 1, 1],
                        [1, 0, 0]
                    ],
                    [
                        [1, 1, 0],
                        [0, 1, 0],
                        [0, 1, 0]
                    ]
                ],
                
                // O-фигура (1 положение)
                .O: [
                    [
                        [1, 1],
                        [1, 1]
                    ]
                ],
                
                // S-фигура (2 положения)
                .S: [
                    [
                        [0, 1, 1],
                        [1, 1, 0],
                        [0, 0, 0]
                    ],
                    [
                        [0, 1, 0],
                        [0, 1, 1],
                        [0, 0, 1]
                    ],
                    [
                        [0, 0, 0],
                        [0, 1, 1],
                        [1, 1, 0]
                    ],
                    [
                        [1, 0, 0],
                        [1, 1, 0],
                        [0, 1, 0]
                    ]
                ],
                
                // T-фигура (4 положения)
                .T: [
                    [
                        [0, 1, 0],
                        [1, 1, 1],
                        [0, 0, 0]
                    ],
                    [
                        [0, 1, 0],
                        [0, 1, 1],
                        [0, 1, 0]
                    ],
                    [
                        [0, 0, 0],
                        [1, 1, 1],
                        [0, 1, 0]
                    ],
                    [
                        [0, 1, 0],
                        [1, 1, 0],
                        [0, 1, 0]
                    ]
                ],
                
                // Z-фигура (2 положения)
                .Z: [
                    [
                        [1, 1, 0],
                        [0, 1, 1],
                        [0, 0, 0]
                    ],
                    [
                        [0, 0, 1],
                        [0, 1, 1],
                        [0, 1, 0]
                    ],
                    [
                        [0, 0, 0],
                        [1, 1, 0],
                        [0, 1, 1]
                    ],
                    [
                        [0, 1, 0],
                        [1, 1, 0],
                        [1, 0, 0]
                    ]
                ]
            ]
    
    static func getNextRotation(for type: TetrominoType, currentRotation: Int) -> [[Int]] {
        let rotations = shapes[type]!
        return rotations[(currentRotation + 1) % rotations.count]
    }
}
