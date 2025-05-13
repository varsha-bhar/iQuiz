//
//  ContentView.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/5/25.
//

import SwiftUI

struct ContentView: View {
    let quizzes = sampleQuizzes
    @State private var showingSettings = false

    var body: some View {
        NavigationView {
            List(quizzes) { quiz in
                NavigationLink(destination: QuizView(viewModel: QuizViewModel(quiz: quiz))) {
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
