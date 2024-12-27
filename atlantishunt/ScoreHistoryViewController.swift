//
//  ScoreHistoryViewController.swift
//  atlantishunt
//
//  Created by Clement Gan on 26/12/2024.
//

import UIKit

class ScoreHistoryViewController: UIViewController, UITableViewDataSource {
    
    // TableView for displaying the scores and times
    let tableView = UITableView()
    
    var scoresHistory: [[String: Any]] = [] // Store the scores and times
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the scores and times from UserDefaults
        if let savedScores = UserDefaults.standard.array(forKey: "scoresHistory") as? [[String: Any]] {
            scoresHistory = savedScores
        }
        print(scoresHistory)
        
        // Setup TableView
        tableView.frame = view.bounds
        tableView.dataSource = self
        tableView.register(ScoreCellTVC.self, forCellReuseIdentifier: "ScoreCell")
        view.addSubview(tableView)
        
        // Add a background color to the screen
        view.backgroundColor = .white
        
        // Add a back button to return to the menu
//        let backButton = UIButton(type: .system)
//        backButton.frame = CGRect(x: (view.frame.width - 200) / 2, y: view.frame.height - 80, width: 200, height: 50)
//        backButton.setTitle("Back to Menu", for: .normal)
//        backButton.addTarget(self, action: #selector(backToMenu), for: .touchUpInside)
//        view.addSubview(backButton)
    }
    
    // Data source method for TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scoresHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ScoreCell", for: indexPath) as? ScoreCellTVC {
            // Get the score record for this row
//            let score = ScoreHistory.scores[indexPath.row]
//            let exitTime = UserDefaults.standard.object(forKey: "lastExitTime") as? Date ?? Date()
            let scoreData = scoresHistory[indexPath.row]
            let score = scoreData["score"] as? Int ?? 0
            let exitTime = scoreData["time"] as? Date ?? Date()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            
            // Set the text for the game mode, score, and time labels
            cell.scoreLabel.text = "Highest Score: \(score)"
            cell.timeLabel.text = "Time: \(formatter.string(from: exitTime))"
            
           
            return cell
        }
        
        return UITableViewCell()
        
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .default, reuseIdentifier: "cell")
//        
//        let score = ScoreHistory.scores[indexPath.row]
//        let exitTime = UserDefaults.standard.object(forKey: "lastExitTime") as? Date ?? Date()
//        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        
//        cell.textLabel?.text = "Score: \(score), Time: \(formatter.string(from: exitTime))"
//        return cell
    }
    
    @objc func backToMenu() {
        dismiss(animated: true, completion: nil)
    }
}


