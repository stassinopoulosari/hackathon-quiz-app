//
//  HQQuestionAnsweringViewController.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/20/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import UIKit

public class HQQuestionAnsweringViewController: UIViewController {
    
    @IBOutlet weak var questionView: HQQuestionView!;
    @IBOutlet weak var factsView: HQLifeScoreView!;
    @IBOutlet weak var button0: HQAnswerView!;
    @IBOutlet weak var button1: HQAnswerView!;
    @IBOutlet weak var button2: HQAnswerView!;
    @IBOutlet weak var button3: HQAnswerView!;
    @IBOutlet weak var closeButton: UIButton!;
    
    public var game: HQGame?;
    private var currentQuestion: HQQuestion?;
    
    override public func viewDidLoad() {
        super.viewDidLoad();
        [questionView, factsView, button0, button1, button2, button3].forEach { (view: UIView?) in
            view?.alpha = 0.0;
        }
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        [button0, button1, button2, button3].forEach { (answerView: HQAnswerView?) in
            answerView?.answeringViewController = self;
            answerView?.addGestureRecognizer(UITapGestureRecognizer(target: answerView, action: #selector(answerView?.onSelected)));
        }
        if let firstQuestion = game?.next() {
            display(question: firstQuestion);
        } else {
            gameOver();
        }
        [questionView, factsView, button0, button1, button2, button3].forEach { (view: UIView?) in
            UIView.animate(withDuration: 0.5) {
                view?.alpha = 1.0;
            }
        }
    }
    
    private func display(question: HQQuestion) {
        self.currentQuestion = question;
        var answers = question.answers;
        answers.shuffle();
        
        let questionText = question.text;
        
        [button0, button1, button2, button3].enumerated().forEach { (index: Int, answerView: HQAnswerView?) in
            if(answers.count > index) {
                let answer = answers[index];
                answerView?.isHidden = false;
                answerView?.questionText.text = answer.text;
                answerView?.answer = answer;
            } else {
                answerView?.questionText.text = "";
                answerView?.isHidden = true;
                answerView?.answer = nil;
            }
        }
        
        if let game = game {
            let lives = game.userLives;
            let score = game.userScore;
            factsView.livesLabel.text = String(describing: lives);
            factsView.scoreLabel.text = String(describing: score);
        }
        
        questionView.questionLabel.text = questionText;
    }
    
    public func receive(answer: HQQuestion.HQAnswer, from answerView: HQAnswerView) {
        if var game = game, let currentQuestion = currentQuestion {
            game.takeResult(result: answer.isCorrect ? .win : .loss, fromQuestion: currentQuestion);
            if(answer.isCorrect) {
                factsView.scoreIcon.image = UIImage(named: "upScoreIcon");
            } else {
                factsView.scoreIcon.image = UIImage(named: "downScoreIcon");
            }
            let currBackgroundColor =                 answerView.backgroundColor;
            UIView.animate(withDuration: 0.25, animations: {
                answerView.backgroundColor = answer.isCorrect ? UIColor.green : UIColor.red;
            }) { _ in
                UIView.animate(withDuration: 0.25, animations: {
                    answerView.backgroundColor = currBackgroundColor;
                }, completion: { _ in
                    DispatchQueue.main.async {
                        let nextQuestion = game.next();
                        self.game = game;
                        if let nextQuestion = nextQuestion {
                            self.display(question: nextQuestion);
                        } else {
                            self.gameOver();
                        }
                    }
                })
            }
            
            
        }
    }
    
    private func gameOver() {
        self.performSegue(withIdentifier: "unwindToHomeScreenSegue", sender: self);
    }
    
    
}
