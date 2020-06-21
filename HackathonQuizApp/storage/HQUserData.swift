//
//  UserData.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/21/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import Foundation
import UIKit

public class HQUserData {
    private var userDefaults: UserDefaults;
    
    public init() {
        userDefaults = UserDefaults(suiteName: "group.com.Stassinopoulos.hackathonQuiz")!;
    }
    
    let totalQuestionsAnsweredKey = "hqTotalQuestionsAnswered";
    let totalPointsKey = "hqTotalPoints";
    let totalAnsweredCorrectlyKey = "hqTotalQuestionsAnsweredCorrectly";
    
    public func incrementQuestions() {
        let totalAnswered = userDefaults.integer(forKey: totalQuestionsAnsweredKey)
        userDefaults.set(totalAnswered + 1, forKey: totalQuestionsAnsweredKey);
    }
    
    public func incrementPoints(byAmount points: Int) {
        if(points < 0) {
            return;
        }
        let totalPoints = userDefaults.integer(forKey: totalPointsKey);
        userDefaults.set(totalPoints + points, forKey: totalPointsKey);
    }
    
    public func incrementAnsweredCorrectly() {
        let totalAnsweredCorrectly = userDefaults.integer(forKey: totalAnsweredCorrectlyKey)
        userDefaults.set(totalAnsweredCorrectly + 1, forKey: totalAnsweredCorrectlyKey);
    }
    
    public func getBattingAverage() -> Double {
        let totalAnswered = userDefaults.integer(forKey: totalQuestionsAnsweredKey)
        let totalAnsweredCorrectly = userDefaults.integer(forKey: totalAnsweredCorrectlyKey)
        if(totalAnswered == 0) { return 0.0;}
        return Double(totalAnsweredCorrectly) / Double(totalAnswered);
    }
    
    public func getAveragePoints() -> Double {
        let totalAnswered = userDefaults.integer(forKey: totalQuestionsAnsweredKey)
        let totalPoints = userDefaults.integer(forKey: totalPointsKey);
        if(totalAnswered == 0) { return 0.0;}
        return Double(totalPoints) / Double(totalAnswered);
    }
}
