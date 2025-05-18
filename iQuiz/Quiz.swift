import SwiftUI

struct Quiz {
    let title: String
    let description: String
    let iconName: String
    let questions: [Question]
}

struct Question {
    let text: String
    let options: [String]
    let correctIndex: Int
}

let sampleQuizzes = [
    Quiz(
        title: "Mathematics",
        description: "Let's test your math brain",
        iconName: "math_icon",
        questions: [
            Question(text: "What is 2 + 2?", options: ["3", "4", "5"], correctIndex: 1),
            Question(text: "What is 5 x 3?", options: ["15", "10", "20"], correctIndex: 0)
        ]
    ),
    Quiz(
        title: "Marvel Superheros",
        description: "Do you know your heros?",
        iconName: "marvel_icon",
        questions: [
            Question(text: "Who is Iron Man?", options: ["Tony Stark", "Bruce Wayne", "Something Else"], correctIndex: 0),
            Question(text: "Captain America's shield is made of?", options: ["Adamantium", "Vibranium", "Something Else"], correctIndex: 1)
        ]
    ),
    Quiz(
        title: "Science",
        description: "Think like a scientist!",
        iconName: "science_icon",
        questions: [
            Question(text: "Water freezes at?", options: ["0°C", "100°C", "293°C"], correctIndex: 0),
            Question(text: "Earth is a?", options: ["Star", "Planet", "Moon"], correctIndex: 1)
        ]
    )
]
