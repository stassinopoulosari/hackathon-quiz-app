//
//  QuestionView.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/20/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import UIKit

public class HQAnswerView: HQRoundedCornerView {

    @IBOutlet weak var questionText: UILabel!;
    public var answer: HQQuestion.HQAnswer?;
    public var answeringViewController: HQQuestionAnsweringViewController?;
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @objc public func onSelected() {
        if let answeringViewController = answeringViewController, let answer = answer {
            answeringViewController.receive(answer: answer, from: self);
        }
    }

    
}

