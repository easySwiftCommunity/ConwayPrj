//
//  GameController.swift
//  ConwayPrj
//
//  Created by Danya on 08/06/2022.
//  Copyright © 2022 Danya. All rights reserved.
//

import UIKit

extension GameController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return worldSize
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worldSize
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SquareCell
   
        if let cellWorldState = self.gameLogic?.getCellAt(row: indexPath.section, col: indexPath.row) {
         cell.change(cellWorldState)
         }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? SquareCell {
            if let status = self.gameLogic?.gameStatus {
                switch status {
                case .PAUSED, .OVER:
                    changeButton(cell: cell, indexPath: indexPath)
                case .STOPPED:
                    changeButton(cell: cell, indexPath: indexPath)
                case .RUNNING:
                    self.gameLogic?.changeStatus(status: .PAUSED)
                    MessagesHelper.showStandardMessage(reference: self, title: "Игра приастановлена", message: "Выбрать ячейки когда будете готовы")
                case .STABLE:
                    changeButton(cell: cell, indexPath: indexPath)
                    self.timer?.invalidate()
                }
            }
        }
    }
}

class GameController: UIViewController {
    
    var timer: Timer?
    var gameLogic: GameProtocol?
    let standardCellSize = (50.0, 50.0)
    let worldSize = 50
    let reuseIdentifier = "customCell"
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var generationsBar: UIProgressView!
    @IBOutlet var cellCountLbl: UILabel!
    @IBOutlet var startStopButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameLogic = LogicGame(worldSize: worldSize)
        gameLogic?.changeStatus(status: .STOPPED)
        self.generationsBar.setProgress(0.0, animated: true)
    }
    func restart() {
        self.gameLogic?.changeStatus(status: .RUNNING)
        self.gameLogic?.generations = 0
        self.generationsBar.setProgress(0.0, animated: true)
        startStopButton.setTitle("Пауза", for: .normal)
        runTimer()
    }
    
    func changeButton(cell: SquareCell, indexPath: IndexPath) {
        if cell.live ?? true {
            cell.change(false)
        } else {
            cell.change(true)
        }
        if gameLogic?.getCellAt(row: indexPath.row, col: indexPath.section) != nil {
            gameLogic?.toggleCell(line: indexPath.section, col: indexPath.row)
        }
    }
    
    @IBAction func randomGame(_ sender: UIButton) {
        gameLogic?.startRandom()
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        if var game = self.gameLogic {
            if game.getCurrentSize() > 0 {
                if let status = game.gameStatus {
                    switch status {
                    case .RUNNING:
                        self.gameLogic?.changeStatus(status: .PAUSED)
                        startStopButton.setTitle("Старт", for: .normal)
                    case .STOPPED, .OVER:
                        restart()
                    case .STABLE:
                        self.gameLogic?.changeStatus(status: .RUNNING)
                        startStopButton.setTitle("Пауза", for: .normal)
                        runTimer()
                    case .PAUSED:
                        startStopButton.setTitle("Пауза", for: .normal)
                        self.gameLogic?.changeStatus(status: .RUNNING)
                        runTimer()
                    }
                }
            } else {
                MessagesHelper.showStandardMessage(reference: self, title: "Игра неактивна!", message: "Выбрать несколько ячеек, чтобы начать игру")
            }
        } else {
            self.gameLogic?.changeStatus(status: .RUNNING)
            runTimer()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if !(self.collectionView?.visibleCells.isEmpty)! {
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchHandler(gesture:)))
            self.view.addGestureRecognizer(pinchRecognizer)
        }
        MessagesHelper.showStandardMessage(reference: self, title: "Привет!", message: "Нажми ОК, чтобы начать играть!")
    }
    @objc func advanceGeneration() {
        if let status = self.gameLogic?.gameStatus {
            switch status {
            case .RUNNING:
                self.gameLogic?.runGeneration()
            case .OVER:
                self.collectionView?.reloadData()
                MessagesHelper.showStandardMessage(reference: self, title: "Конец игры!", message: "Игра закончена, все существа мертвы.")
                self.timer?.invalidate()
                startStopButton.setTitle("Перезапустить", for: .normal)
            case .STABLE:
                self.collectionView?.reloadData()
                startStopButton.setTitle("Старт", for: .normal)
                MessagesHelper.showStandardMessage(reference: self, title: "Игра приастановлена!", message: "Введите в мир новых существ")
                self.timer?.invalidate()
            case .STOPPED:
                self.collectionView?.reloadData()
                self.timer?.invalidate()
            case .PAUSED:
                self.collectionView?.reloadData()
                self.timer?.invalidate()
            }
            self.generationsBar.setProgress(Float(self.gameLogic!.generations) / 100.0, animated: true)
            self.cellCountLbl.text = "Player Cells: \(self.gameLogic!.getCurrentSize())"
            self.collectionView?.reloadData()
        }
        if let generationsHistory = self.gameLogic?.generationsHistory {
            if generationsHistory.contains("\(self.gameLogic?.currentGeneration ?? [])") {
                self.gameLogic?.gameStatus = .STABLE
            }
        }
    }
    func runTimer() {
        self.timer = Timer.scheduledTimer(
            timeInterval: 1.0, target: self, selector: #selector(GameController.advanceGeneration),
            userInfo: nil, repeats: true)
        self.gameLogic?.changeStatus(status: .RUNNING)
    }

    @objc private func pinchHandler(gesture: UIPinchGestureRecognizer) {
        if let view = gesture.view {
            switch gesture.state {
            case .changed:
                let pinchCenter = CGPoint(x: gesture.location(in: view).x - view.bounds.midX,
                                          y: gesture.location(in: view).y - view.bounds.midY)
                let transform = self.collectionView?.transform.translatedBy(x: pinchCenter.x, y: pinchCenter.y)
                    .scaledBy(x: gesture.scale, y: gesture.scale)
                    .translatedBy(x: -pinchCenter.x, y: -pinchCenter.y)
                self.collectionView?.transform = transform!
                gesture.scale = 1
            case .ended:
                break
            default:
                return
            }
        }
    }
}
