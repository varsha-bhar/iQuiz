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

