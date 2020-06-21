//
//  HQGame.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/20/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import Foundation

public struct HQGame {
    
    public let POINTS_EASY = 10;
    public let POINTS_HARD = 15;
    public let POINTS_EXPERT = 20;
    
    private var questionSet: HQQuestion.HQQuestionSet;
    public var userScore: Int = 0;
    public var userLives: Int = 10;
    
    private var userData: HQUserData;
    
    public init(fromQuestionSet questionSet: HQQuestion.HQQuestionSet) {
        self.questionSet = questionSet.shuffled();
        self.userData = HQUserData();
    }
    
    public mutating func next() -> HQQuestion? {
        let (newQuestionSet, nextQuestion) = questionSet.popped();
        self.questionSet = newQuestionSet;
        return nextQuestion;
    }
    
    public mutating func takeResult(result: HQGameRoundResult, fromQuestion question: HQQuestion) {
        userData.incrementQuestions();

        switch result {
        case .loss:
            userLives -= 1;
        case .win:
            userData.incrementAnsweredCorrectly()
            switch question.difficulty {
            case .easy:
                userScore += POINTS_EASY;
                userData.incrementPoints(byAmount: POINTS_EASY)
            case .hard:
                userScore += POINTS_HARD;
                userData.incrementPoints(byAmount: POINTS_HARD)
            case .expert:
                userScore += POINTS_EXPERT;
                userData.incrementPoints(byAmount: POINTS_EXPERT);
            }
        }
    }
    
    public enum HQGameRoundResult {
        case loss, win;
    }
    
}
