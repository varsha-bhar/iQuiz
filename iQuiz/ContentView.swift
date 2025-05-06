//  ContentView.swift
//  iQuiz
//  Created by Varsha Bharath on 5/5/25.

import SwiftUI

// Sample Data
let sampleQuizzes = [
    Quiz(title: "Mathematics", description: "Test your number skills", iconName: "math_icon"),
    Quiz(title: "Marvel Superheros", description: "Do you know your heros?", iconName: "marvel_icon"),
    Quiz(title: "Science", description: "Explore the laws of nature", iconName: "science_icon")
]

struct ContentView: View {
    let quizzes = sampleQuizzes
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            List(quizzes) { quiz in
                HStack {
                    Image(quiz.iconName)
                        .resizable()
                        .frame(width: 40, height: 40)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(quiz.title)
                            .font(.headline)
                        Text(quiz.description)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("iQuiz")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Settings") {
                        showingSettings = true
                    }
                }
            }
            .alert("Settings go here", isPresented: $showingSettings) {
                Button("OK", role: .cancel) { }
            }
        }
    }
}

#Preview {
    ContentView()
}
