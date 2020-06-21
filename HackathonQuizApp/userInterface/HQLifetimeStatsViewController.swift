//
//  HQLifetimeStatsViewController.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/21/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import UIKit

class HQLifetimeStatsViewController: UITableViewController {
    
    @IBOutlet var battingAverageLabel: UILabel!;
    
    @IBOutlet var averagePtsLabel: UILabel!;
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        [battingAverageLabel, averagePtsLabel].forEach { (label) in
            label?.alpha = 0.0;
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userData = HQUserData();
        let battingAverage = userData.getBattingAverage();
        let averagePoints = userData.getAveragePoints();
        UIView.animate(withDuration: 0.5, animations: {
            self.battingAverageLabel.text = String(describing: round(battingAverage * 100)) + "%";
            self.averagePtsLabel.text = String(describing: round(averagePoints * 100) / 100);
            [self.battingAverageLabel, self.averagePtsLabel].forEach { (label) in
                label?.alpha = 1.0;
            }
        })
    }
    
    
    
}
