//
//  QuizViewModel.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/12/25.
//


import SwiftUI

class QuizViewModel: ObservableObject {
    let quiz: Quiz
    @Published var currentScene: QuizScene = .question(index: 0)
    @Published var score = 0

    init(quiz: Quiz) {
        self.quiz = quiz
    }

    func submitAnswer(index: Int, selected: Int) {
        let isCorrect = quiz.questions[index].correctIndex == selected
        if isCorrect { score += 1 }
        currentScene = .answer(index: index, selected: selected)
    }

    func nextScene(after index: Int) {
        if index + 1 < quiz.questions.count {
            currentScene = .question(index: index + 1)
        } else {
            currentScene = .finished
        }
    }

    func reset() {
        score = 0
        currentScene = .question(index: 0)
    }
}
