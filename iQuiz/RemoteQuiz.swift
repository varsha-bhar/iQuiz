//
//  RemoteQuiz.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/16/25.
//


import Foundation

struct RemoteQuiz: Codable {
    let title: String
    let desc: String
    let questions: [RemoteQuestion]
}

struct RemoteQuestion: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

