//
//  QuizView.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/12/25.
//

import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel
    @State private var selectedIndex: Int? = nil
    @Environment(\.dismiss) private var dismiss
    @State private var showSwipeHint = true

    var body: some View {
        VStack(spacing: 24) {
            // switch between 3 states: question, answer, finished
            switch viewModel.currentScene {

            // question sceen
            case .question(let index):
                let question = viewModel.quiz.questions[index]
                let total = viewModel.quiz.questions.count

                VStack(alignment: .leading, spacing: 16) {
                    Text("Question \(index + 1) of \(total)")
                        .font(.headline)

                    Text(question.text)
                        .font(.title2)

                    // display answer options
                    ForEach(0..<question.options.count, id: \.self) { i in
                        HStack {
                            Image(systemName: selectedIndex == i ? "largecircle.fill.circle" : "circle")
                            Text(question.options[i])
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedIndex = i
                        }
                    }

                    HStack {
                        Spacer()
                        Button("Submit") {
                            if let selected = selectedIndex {
                                viewModel.submitAnswer(index: index, selected: selected)
                                selectedIndex = nil // reset selection
                            }
                        }
                        .disabled(selectedIndex == nil)
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }

                    Spacer()

                    // indicate swiping ability?
                    if showSwipeHint {
                        HStack {
                            Image("swipe_left_icon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .opacity(0.4)

                            Spacer()

                            Image("swipe_right_icon")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .opacity(0.4)
                        }
                        .transition(.opacity)
                        .padding(.horizontal)
                    }
                }
                // fade after 3 seocnds
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        withAnimation {
                            showSwipeHint = false
                        }
                    }
                }

            // answer scene
            case .answer(let index, let selected):
                let question = viewModel.quiz.questions[index]
                let isCorrect = selected == question.correctIndex
                let correctColor = isCorrect ? Color.green : Color.red
                let resultMessage = isCorrect ? "Correct!" : "That answer was incorrect."

                VStack(spacing: 16) {
                    Text(resultMessage)
                        .font(.title)
                        .bold()
                        .foregroundColor(correctColor)

                    Text(question.text)
                        .font(.title2)

                    Text("Correct answer: \(question.options[question.correctIndex])")
                        .font(.headline)
                        .bold()
                        .foregroundColor(correctColor)

                    Button("Next") {
                        viewModel.nextScene(after: index) // move to next scene
                    }
                    .buttonStyle(.borderedProminent)
                }

            // finished scene
            case .finished:
                let total = viewModel.quiz.questions.count
                let score = viewModel.score
                let ratio = Double(score) / Double(total) // right/wrong

                let message = {
                    if ratio == 1.0 {
                        return "🎉 Perfect Score!"
                    } else if ratio >= 0.7 {
                        return "👏 Almost there!"
                    } else if ratio >= 0.4 {
                        return "👍 Nice try!"
                    } else {
                        return "💡 Keep practicing!"
                    }
                }()

                VStack(spacing: 16) {
                    Text("Quiz Complete!")
                        .font(.title)

                    Text(message)
                        .font(.headline)

                    Text("Your score: \(score) / \(total)")
                        .font(.title2)

                    Button("Back") {
                        viewModel.reset()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
        .padding()
        .contentShape(Rectangle()) //
        
        // HANDLE SWIPING
        .gesture(
            DragGesture(minimumDistance: 10, coordinateSpace: .local)
                .onEnded { value in
                    let dx = value.translation.width
                    let dy = value.translation.height

                    // print("Final swipe: \(value.translation)")

                    if abs(dx) > 50 && abs(dx) > abs(dy) {
                        if dx > 0 {
                            print("👉 Right swipe")
                            handleRightSwipe()
                        }
                        else {
                            // print("👈 Left swipe")
                            handleLeftSwipe()
                        }
                    }
                    else {
                        // print("Not a valid horizontal swipe")
                    }
                }
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    
    // swipe handler helper functions
    private func handleRightSwipe() {
        switch viewModel.currentScene {
        case .question(let index):
            if let selected = selectedIndex {
                viewModel.submitAnswer(index: index, selected: selected)
                selectedIndex = nil
            }
        case .answer(let index, _):
            viewModel.nextScene(after: index)
        case .finished:
            break
        }
    }

    private func handleLeftSwipe() {
        viewModel.reset()
        dismiss()
    }
}

#Preview {
    ContentView()
}
