//
//  QuizScene.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/12/25.
//
import SwiftUI

enum QuizScene {
    case question(index: Int)
    case answer(index: Int, selected: Int)
    case finished
}

