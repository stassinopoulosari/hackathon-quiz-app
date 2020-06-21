//
//  HQHomeScreenViewController.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/21/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import UIKit

class HQHomeScreenViewController: UIViewController {

    @IBOutlet weak var difficultySelector: UISegmentedControl!;
    @IBOutlet weak var startButton: UIButton!;
    
    private let url = "https://raw.githubusercontent.com/stassinopoulosari/hackathon-quiz-app/backend/QuestionBank.json";
    
    private var gameToSend: HQGame?;
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func unwindToHomeScreen(_ segue: UIStoryboardSegue) {
        
    }

    @IBAction func startButtonPressed(_ sender: UIButton) {
        let difficultyIndex = difficultySelector.selectedSegmentIndex;
        var difficulty = HQQuestion.HQQuestionDifficulty.easy;
        switch(difficultyIndex) {
        case 0:
            difficulty = .easy;
            break;
        case 1:
            difficulty = .hard;
            break;
        case 2:
            difficulty = .expert;
            break;
        default:
            difficulty = .easy;
            break;
        }
        
        HQQuestion.HQQuestionSet.make(fromURL: url, withDifficulty: difficulty) { (questionSet) in
            if let questionSet = questionSet {
                let game = HQGame(fromQuestionSet: questionSet);
                self.gameToSend = game;
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "homeToGameSegue", sender: self);
                }
                
            } else {
                print("Failed to create question set");
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination;
        if let destination = destination as? HQQuestionAnsweringViewController {
            destination.game = self.gameToSend;
        }
    }
}
