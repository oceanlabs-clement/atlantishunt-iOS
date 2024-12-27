//
//  ScoreHistory.swift
//  atlantishunt
//
//  Created by Clement Gan on 26/12/2024.
//

import Foundation

class ScoreHistory {
    // This stores the scores in an array
    static var scores: [Int] = []
    
    // Function to add a new score to history
    static func addScore(_ score: Int) {
        scores.append(score)
    }
    
    // Function to get all scores (returns the scores array)
    static func getScores() -> [Int] {
        return scores
    }
}

