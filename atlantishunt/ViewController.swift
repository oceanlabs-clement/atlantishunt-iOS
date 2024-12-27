//
//  ViewController.swift
//  atlantishunt
//
//  Created by Clement Gan on 26/12/2024.
//

import UIKit

class ViewController: UIViewController {

    // Game state variables
    var score = 0
    var timeLeft = 30
    var timer: Timer?
    var exitTime: Date?
    
    // UI Elements
    let scoreLabel = UILabel()
    let timerLabel = UILabel()
    let quitButton = UIButton(type: .system)
    var activeCreatures: [UILabel] = [] // Keeps track of all active creatures
    
    // Sea creatures and points (including a bad creature that deducts points)
    let creatures = [
        "🐙": 5,   // Octopus
        "🐠": 2,   // Fish
        "🦑": 3,   // Squid
        "🦀": 4,   // Crab
        "🐬": 6,   // Dolphin
        "🦈": 8,   // Shark (Bonus points!)
        "🐚": 1,   // Shell (Low points)
        "💀": -3   // Bad creature (Penalty)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup background image
        let backgroundImage = UIImage(named: "image_bg") // Add a background image to Assets
        let backgroundImageView = UIImageView(frame: view.bounds)
        backgroundImageView.image = backgroundImage
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        
        // Configure score label
        scoreLabel.frame = CGRect(x: 20, y: 60, width: 200, height: 40)
        scoreLabel.text = "Score: \(score)"
        scoreLabel.font = UIFont.boldSystemFont(ofSize: 24)
        scoreLabel.textColor = .white
        view.addSubview(scoreLabel)
        
        // Configure timer label
        timerLabel.frame = CGRect(x: view.frame.width - 150, y: 60, width: 200, height: 40)
        timerLabel.text = "Time Left: \(timeLeft)"
        timerLabel.font = UIFont.boldSystemFont(ofSize: 24)
        timerLabel.textColor = .white
        view.addSubview(timerLabel)
        
        // Quit game button
        quitButton.frame = CGRect(x: (view.frame.width - 200) / 2, y: view.frame.height - 80, width: 200, height: 50)
        quitButton.setTitle("Quit Game", for: .normal)
        quitButton.addTarget(self, action: #selector(quitGame), for: .touchUpInside)
        quitButton.setTitleColor(.white, for: .normal)
        quitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        quitButton.layer.borderWidth = 2
        quitButton.layer.borderColor = UIColor.white.cgColor
        quitButton.layer.cornerRadius = 20
        view.addSubview(quitButton)
        
        // Start the game
        startGame()
    }
    
    // Start the game
    func startGame() {
        score = 0
        timeLeft = 30
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "Time Left: \(timeLeft)"
        
        // Start the countdown timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        // Show random creatures
        showRandomCreature()
    }
    
    // Update timer
    @objc func updateTimer() {
        timeLeft -= 1
        timerLabel.text = "Time Left: \(timeLeft)"
        
        if timeLeft <= 0 {
            timer?.invalidate()
            timer = nil
            
            showGameOverAlert()
        }
    }
    
    // Show random sea creature
    func showRandomCreature() {
        let randomCreature = creatures.randomElement()!
        let creatureLabel = UILabel()
        creatureLabel.text = randomCreature.key
        creatureLabel.font = UIFont.systemFont(ofSize: 50)
        creatureLabel.textAlignment = .center
        creatureLabel.frame = CGRect(x: Int.random(in: 20..<Int(view.frame.width - 60)),
                                      y: Int.random(in: 100..<Int(view.frame.height - 100)),
                                      width: 50,
                                      height: 50)
        creatureLabel.isUserInteractionEnabled = true
        creatureLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(creatureTapped(_:))))
        view.addSubview(creatureLabel)
        activeCreatures.append(creatureLabel) // Add the creature to the active list
        
        // Remove creature after 2 seconds (if not tapped yet)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.removeCreature(creatureLabel)
            
            if self.timeLeft > 0 {
                self.showRandomCreature()
            }
        }
        
        // Show next random creature
//        DispatchQueue.main.asyncAfter(deadline: .now() + .random(in: 1...3)) {
//            self.showRandomCreature()
//        }
    }
    
    // Handle tapping on a creature
    @objc func creatureTapped(_ sender: UITapGestureRecognizer) {
        if let creatureLabel = sender.view as? UILabel {
            let tappedCreature = creatureLabel.text ?? ""
            let points = creatures[tappedCreature] ?? 0
            
            // If the creature is the bad one (💀), deduct points
            if points < 0 {
                score += points
                scoreLabel.text = "Score: \(score)"
                showPenaltyAlert()
            } else {
                // Otherwise, add the points to the score
                score += points
                scoreLabel.text = "Score: \(score)"
            }
            
            // Remove the tapped creature
            removeCreature(creatureLabel)
        }
    }
    
    // Function to remove the creature from the screen and active creatures list
    func removeCreature(_ creature: UILabel) {
        creature.removeFromSuperview()
        if let index = activeCreatures.firstIndex(of: creature) {
            activeCreatures.remove(at: index)
        }
    }
    
    // Show a penalty alert if the bad creature is tapped
    func showPenaltyAlert() {
        let alertController = UIAlertController(title: "Oops!", message: "You tapped a bad creature! -3 points.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
//    // Show Game Over Alert
//    func showGameOverAlert() {
//        let alertController = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)
//        
//        // Store the current time when the user exits the game
//        let currentTime = Date()
//        exitTime = currentTime
//        
//        // Save score to history
//        ScoreHistory.addScore(score) // Save the score using the ScoreHistory class
//        
//        // Save current time (to be shown in score history)
//        UserDefaults.standard.set(currentTime, forKey: "lastExitTime")
//        
//        // Play Again action
//        let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { _ in
//            self.startGame()
//        }
//        alertController.addAction(playAgainAction)
//        
//        // Exit action
//        let exitAction = UIAlertAction(title: "Exit", style: .destructive) { _ in
//            self.dismiss(animated: true, completion: nil)
//        }
//        alertController.addAction(exitAction)
//        
//        present(alertController, animated: true, completion: nil)
//    }
    
    // Show Game Over Alert
        func showGameOverAlert() {
            let alertController = UIAlertController(title: "Game Over", message: "Your final score is \(score)", preferredStyle: .alert)
            
            // Store the current time when the user exits the game
            let currentTime = Date()
            exitTime = currentTime
            
            // Save the score and current time into UserDefaults (store as an array of dictionaries)
            let scoreData: [String: Any] = ["score": score, "time": currentTime]
            var scoresHistory = UserDefaults.standard.array(forKey: "scoresHistory") as? [[String: Any]] ?? []
            scoresHistory.append(scoreData)
            UserDefaults.standard.set(scoresHistory, forKey: "scoresHistory")
            
            // Play Again action
            let playAgainAction = UIAlertAction(title: "Play Again", style: .default) { _ in
                self.startGame()
            }
            alertController.addAction(playAgainAction)
            
            // Exit action
            let exitAction = UIAlertAction(title: "Exit", style: .destructive) { _ in
                self.dismiss(animated: true, completion: nil)
            }
            alertController.addAction(exitAction)
            
            present(alertController, animated: true, completion: nil)
        }
    
    // Quit Game action
    @objc func quitGame() {
        dismiss(animated: true, completion: nil)
    }
}
