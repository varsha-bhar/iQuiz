//
//  Quiz.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/5/25.
//

import SwiftUI

struct Quiz: Identifiable {
    let id = UUID()
    let title: String // math science etc
    let description: String // short desc of topic
    let iconName: String // math_icon, science_icon
    let questions: [Question]
}

struct Question: Identifiable {
    let id = UUID()
    let text: String // question
    let options: [String] // multiple choice
    let correctIndex: Int // answer
}
