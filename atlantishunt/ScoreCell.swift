//
//  ScoreCell.swift
//  atlantishunt
//
//  Created by Clement Gan on 26/12/2024.
//

import UIKit

class ScoreCellTVC: UITableViewCell {
    
    let scoreLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(scoreLabel)
        contentView.addSubview(timeLabel)
        
        // Set up Auto Layout constraints
        NSLayoutConstraint.activate([
            // Trailing (right) constraint for score label
            scoreLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            scoreLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Trailing (right) constraint for time label, just next to score
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            timeLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
