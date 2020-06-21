//
//  Question.swift
//  HackathonQuizApp
//
//  Created by Ari Stassinopoulos on 6/20/20.
//  Copyright © 2020 Ari Stassinopoulos. All rights reserved.
//

import Foundation

public class HQQuestion {
    public final var text: String;
    public final var answers: [HQAnswer];
    public final var difficulty: HQQuestionDifficulty;
    
    public init(withText text: String, answers: [HQAnswer], difficulty: HQQuestionDifficulty) {
        self.text = text;
        self.answers = answers;
        self.difficulty = difficulty;
    }
    
    public class HQAnswer {
        public final var text: String;
        public final var isCorrect: Bool;
        
        public init(withText text: String, isCorrect: Bool) {
            self.text = text;
            self.isCorrect = isCorrect;
        }
    }
    
    public class HQQuestionSet {
        
        public final var difficulty: HQQuestionDifficulty;
        public var questions: [HQQuestion] {
            if let questions = _questions {
                return questions;
            } else {
                return [];
            }
        };
        private var _questions: [HQQuestion]?;
        
        private func parse(questionObject: [String: Any]) -> HQQuestion {
            var questionText = "";
            if let questionTextFromObject = questionObject["Question"] as? String {
                questionText = questionTextFromObject;
            }
            let questionAnswers = ["Correct Answer", "Choice 1", "Choice 2", "Choice 3"].map { (header) -> Any? in
                return questionObject[header];
            }.map { (answer: Any?) -> String in
                if let answer = answer {
                    return String(describing: answer);
                }
                return "";
            }.filter {(answer) in return answer != "<null>"}.enumerated().map { (index: Int, element: String) -> HQAnswer in
                return HQAnswer(withText: element, isCorrect: index == 0);
            }
            var difficulty: HQQuestionDifficulty = .easy;
            if let difficultyString = questionObject["Difficulty"] as? String {
                switch difficultyString.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
                case "easy":
                    difficulty = .easy;
                    break;
                case "hard":
                    difficulty = .hard;
                    break;
                case "expert":
                    difficulty = .expert;
                    break;
                default:
                    difficulty = .easy;
                    break;
                }
            }
            
            return HQQuestion(withText: questionText, answers: questionAnswers, difficulty: difficulty);
        }
        
        private init(withData data: Data, withDifficulty difficulty: HQQuestionDifficulty) {
            
            self.difficulty = difficulty;
            
            var questions: [HQQuestion] = [];
            
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: []);
            if let questionObjects = jsonData as? [Any] {
                for questionObject in questionObjects {
                    if let questionObject = questionObject as? [String: Any] {
                        let question = parse(questionObject: questionObject);
                        questions.append(question);
                    }
                }
            }
            
            self._questions = questions.filter({ (question) -> Bool in
                switch(difficulty) {
                case .easy:
                    return question.difficulty == .easy;
                case .hard:
                    return question.difficulty == .easy || question.difficulty == .hard;
                case .expert:
                    return true;
                }
            });
            
        }
        
        private init(withQuestions questions: [HQQuestion], withDifficulty difficulty: HQQuestionDifficulty) {
            
            self.difficulty = difficulty;
            
            self._questions = questions;
            
        }
        
        public static func make(fromURL urlString: String, withDifficulty difficulty: HQQuestionDifficulty,  onCompletion completionBlock: @escaping (HQQuestionSet?) -> Void) {
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url);
                request.httpMethod = "GET";
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let _ = error {
                        completionBlock(nil);
                    } else if let data = data {
                        let hqQuestionSet = HQQuestionSet(withData: data, withDifficulty: difficulty);
                        completionBlock(hqQuestionSet);
                    } else {
                        completionBlock(nil);
                    }
                }
                task.resume();
            } else {
                completionBlock(nil);
            }
        }
        
        public func shuffled() -> HQQuestionSet {
            var shuffleableQuestions = questions
            shuffleableQuestions.shuffle();
            return HQQuestionSet(withQuestions: shuffleableQuestions, withDifficulty: difficulty);
        }
        
        public func popped() -> (HQQuestionSet, HQQuestion?) {
            if var questions = self._questions {
                let popped = questions.popLast();
                return (HQQuestionSet(withQuestions: questions, withDifficulty: self.difficulty), popped);
            } else {
                return (self, nil);
            }
        }
    }
    
    public enum HQQuestionDifficulty {
        case easy, hard, expert
    }
    
    
    
    
}

