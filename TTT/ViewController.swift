//
//  ViewController.swift
//  TicTacToe
//
//  Created by Sri Devulapalli on 2/28/25.
//

import UIKit

class ViewController: UIViewController {
    
    private var gameBoard: [[String]] = Array(repeating: Array(repeating: "", count: 3), count: 3)
    private var currentPlayer = "X"
    private var gameActive = false
    private var emitter: CAEmitterLayer?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "TIC TAC TOE!"
        label.font = UIFont(name: "Marker Felt", size: 70)
        label.textAlignment = .center
        label.textColor = .systemIndigo
        
        // Add stroke effect
        label.layer.shadowColor = UIColor.systemPink.cgColor
        label.layer.shadowOffset = CGSize(width: 0, height: 4)
        label.layer.shadowRadius = 2
        label.layer.shadowOpacity = 0.8
        
        // Add multiple shadow layers for bubble effect
        let bubbleEffect = CALayer()
        bubbleEffect.frame = label.bounds
        bubbleEffect.shadowColor = UIColor.systemPurple.cgColor
        bubbleEffect.shadowOffset = CGSize(width: 0, height: 0)
        bubbleEffect.shadowRadius = 15
        bubbleEffect.shadowOpacity = 0.6
        label.layer.addSublayer(bubbleEffect)
        
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start!", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 40)
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play Again!", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 24)
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.isHidden = true
        return button
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Home", for: .normal)
        button.titleLabel?.font = UIFont(name: "Marker Felt", size: 24)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 4)
        button.layer.shadowRadius = 5
        button.layer.shadowOpacity = 0.3
        button.isHidden = true
        return button
    }()
    
    private let gameContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.isHidden = true
        return view
    }()
    
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Marker Felt", size: 24)
        label.textAlignment = .center
        label.text = "Player X's Turn"
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        // Add subviews
        view.addSubview(titleLabel)
        view.addSubview(startButton)
        view.addSubview(gameContainer)
        view.addSubview(statusLabel)
        view.addSubview(resetButton)
        view.addSubview(homeButton)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: startButton.topAnchor, constant: -40),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            startButton.widthAnchor.constraint(equalToConstant: 200),
            startButton.heightAnchor.constraint(equalToConstant: 60),
            
            gameContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            gameContainer.widthAnchor.constraint(equalToConstant: 300),
            gameContainer.heightAnchor.constraint(equalToConstant: 300),
            
            statusLabel.bottomAnchor.constraint(equalTo: gameContainer.topAnchor, constant: -20),
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            resetButton.topAnchor.constraint(equalTo: gameContainer.bottomAnchor, constant: 30),
            resetButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            resetButton.widthAnchor.constraint(equalToConstant: 140),
            resetButton.heightAnchor.constraint(equalToConstant: 50),
            
            homeButton.topAnchor.constraint(equalTo: gameContainer.bottomAnchor, constant: 30),
            homeButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            homeButton.widthAnchor.constraint(equalToConstant: 140),
            homeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Add bouncing animation to title
        UIView.animate(withDuration: 1.0, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: {
            self.titleLabel.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        })
        
        setupGameBoard()
        
        // Add button actions
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        resetButton.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
    }
    
    private func setupGameBoard() {
        for row in 0..<3 {
            for col in 0..<3 {
                let cellButton = UIButton()
                cellButton.translatesAutoresizingMaskIntoConstraints = false
                cellButton.backgroundColor = .systemGray6
                cellButton.layer.cornerRadius = 10
                cellButton.layer.borderWidth = 2
                cellButton.layer.borderColor = UIColor.systemGray3.cgColor
                cellButton.tag = row * 3 + col
                
                gameContainer.addSubview(cellButton)
                
                let size: CGFloat = 90
                let spacing: CGFloat = 10
                let x = CGFloat(col) * (size + spacing) + spacing
                let y = CGFloat(row) * (size + spacing) + spacing
                
                NSLayoutConstraint.activate([
                    cellButton.leadingAnchor.constraint(equalTo: gameContainer.leadingAnchor, constant: x),
                    cellButton.topAnchor.constraint(equalTo: gameContainer.topAnchor, constant: y),
                    cellButton.widthAnchor.constraint(equalToConstant: size),
                    cellButton.heightAnchor.constraint(equalToConstant: size)
                ])
                
                cellButton.addTarget(self, action: #selector(cellTapped(_:)), for: .touchUpInside)
            }
        }
    }
    
    @objc private func startButtonTapped() {
        gameActive = true
        startButton.isHidden = true
        titleLabel.isHidden = true
        gameContainer.isHidden = false
        statusLabel.isHidden = false
        resetGame()
    }
    
    @objc private func resetButtonTapped() {
        resetButton.isHidden = true
        homeButton.isHidden = true
        statusLabel.layer.removeAllAnimations()
        statusLabel.transform = .identity
        resetGame()
    }
    
    @objc private func homeButtonTapped() {
        // Remove confetti if present
        emitter?.removeFromSuperlayer()
        
        // Show title and start button
        titleLabel.isHidden = false
        startButton.isHidden = false
        
        // Hide game elements
        gameContainer.isHidden = true
        statusLabel.isHidden = true
        resetButton.isHidden = true
        homeButton.isHidden = true
        
        // Reset game state
        resetGame()
        gameActive = false
    }
    
    @objc private func cellTapped(_ sender: UIButton) {
        guard gameActive else { return }
        
        let row = sender.tag / 3
        let col = sender.tag % 3
        
        guard gameBoard[row][col].isEmpty else { return }
        
        gameBoard[row][col] = currentPlayer
        drawShape(in: sender)
        
        if checkWin() {
            handleGameEnd(with: "Player \(currentPlayer) Wins! 🎉")
            animateWinning()
            return
        }
        
        if checkDraw() {
            handleGameEnd(with: "It's a Draw! 🤝")
            return
        }
        
        currentPlayer = currentPlayer == "X" ? "O" : "X"
        statusLabel.text = "Player \(currentPlayer)'s Turn"
    }
    
    private func drawShape(in button: UIButton) {
        let shapeLayer = CAShapeLayer()
        let path = UIBezierPath()
        
        if currentPlayer == "X" {
            // Draw X
            let padding: CGFloat = 20
            path.move(to: CGPoint(x: padding, y: padding))
            path.addLine(to: CGPoint(x: button.bounds.width - padding, y: button.bounds.height - padding))
            path.move(to: CGPoint(x: button.bounds.width - padding, y: padding))
            path.addLine(to: CGPoint(x: padding, y: button.bounds.height - padding))
            
            shapeLayer.strokeColor = UIColor.systemRed.cgColor
            shapeLayer.lineWidth = 8
            shapeLayer.lineCap = .round
        } else {
            // Draw O
            let center = CGPoint(x: button.bounds.width/2, y: button.bounds.height/2)
            let radius: CGFloat = button.bounds.width/2 - 20
            path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: .pi * 2, clockwise: true)
            
            shapeLayer.strokeColor = UIColor.systemBlue.cgColor
            shapeLayer.lineWidth = 8
            shapeLayer.fillColor = nil
        }
        
        shapeLayer.path = path.cgPath
        button.layer.addSublayer(shapeLayer)
        
        // Animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 0.3
        shapeLayer.strokeEnd = 1
        shapeLayer.add(animation, forKey: "strokeEnd")
    }
    
    private func createConfetti() {
        emitter = CAEmitterLayer()
        
        emitter?.emitterPosition = CGPoint(x: view.center.x, y: -10)
        emitter?.emitterShape = .line
        emitter?.emitterSize = CGSize(width: view.frame.size.width, height: 2.0)
        
        let colors: [UIColor] = [.systemRed, .systemBlue, .systemGreen, .systemYellow, .systemPurple, .systemPink]
        
        var cells: [CAEmitterCell] = []
        
        for color in colors {
            let cell = CAEmitterCell()
            cell.birthRate = 4.0
            cell.lifetime = 14.0
            cell.lifetimeRange = 0
            cell.velocity = CGFloat(350.0)
            cell.velocityRange = CGFloat(80.0)
            cell.emissionLongitude = CGFloat.pi
            cell.emissionRange = CGFloat.pi/4
            cell.spin = CGFloat(3.5)
            cell.spinRange = CGFloat(4.0)
            cell.scale = 0.3
            cell.scaleRange = 0.15
            cell.scaleSpeed = -0.1
            cell.contents = createConfettiImage(color: color)?.cgImage
            cells.append(cell)
        }
        
        emitter?.emitterCells = cells
        view.layer.addSublayer(emitter!)
        
        // Stop confetti after 1 second
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.emitter?.birthRate = 0
        }
        
        // Remove confetti layer after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            self?.emitter?.removeFromSuperlayer()
            self?.emitter = nil
        }
    }
    
    private func createConfettiImage(color: UIColor) -> UIImage? {
        let size = CGSize(width: 12, height: 12)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        context.setFillColor(color.cgColor)
        context.fill(CGRect(origin: .zero, size: size))
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    private func handleGameEnd(with message: String) {
        gameActive = false
        statusLabel.text = message
        resetButton.isHidden = false
        homeButton.isHidden = false
        
        if message.contains("Wins") {
            createConfetti()
        }
        
        // Bounce animation for the buttons
        resetButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        homeButton.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.resetButton.transform = .identity
            self.homeButton.transform = .identity
        })
    }
    
    private func checkWin() -> Bool {
        // Check rows
        for row in gameBoard {
            if row.allSatisfy({ $0 == currentPlayer }) { return true }
        }
        
        // Check columns
        for col in 0..<3 {
            if (0..<3).allSatisfy({ gameBoard[$0][col] == currentPlayer }) { return true }
        }
        
        // Check diagonals
        if gameBoard[0][0] == currentPlayer && gameBoard[1][1] == currentPlayer && gameBoard[2][2] == currentPlayer { return true }
        if gameBoard[0][2] == currentPlayer && gameBoard[1][1] == currentPlayer && gameBoard[2][0] == currentPlayer { return true }
        
        return false
    }
    
    private func checkDraw() -> Bool {
        return gameBoard.flatMap { $0 }.allSatisfy { !$0.isEmpty }
    }
    
    private func resetGame() {
        gameBoard = Array(repeating: Array(repeating: "", count: 3), count: 3)
        currentPlayer = "X"
        gameActive = true
        statusLabel.text = "Player X's Turn"
        
        // Clear all buttons
        for case let button as UIButton in gameContainer.subviews {
            button.layer.sublayers?.forEach { layer in
                if layer is CAShapeLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
    
    private func animateWinning() {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.autoreverse, .repeat]) {
            self.statusLabel.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }
    }
}
