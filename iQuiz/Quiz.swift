//
//  Quiz.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/5/25.
//

import Foundation

struct Quiz: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let iconName: String
}
