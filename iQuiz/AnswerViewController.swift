//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/16/25.
//


import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    var questionText: String = ""
    var answers: [String] = []
    var correctAnswerIndex: Int = 0
    var selectedAnswerIndex: Int? = nil
    var currentQuestionIndex: Int = 0
    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    var quiz: Quiz!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        
        // Swipe right = next
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextTapped))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)

        // Swipe left = exit
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(exitQuiz))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        if let selected = selectedAnswerIndex, selected == correctAnswerIndex {
            correctAnswers += 1
        }
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        if currentQuestionIndex + 1 < quiz.questions.count {
            // Next question
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
            nextVC.quiz = quiz
            nextVC.currentQuestionIndex = currentQuestionIndex + 1

            // ✅ Pass updated score
            nextVC.correctAnswers = correctAnswers

            navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            // ✅ Before finishing, set totalQuestions and score
            performSegue(withIdentifier: "showFinishedScene", sender: self)
        }
    }
    
    func configure() {
        questionLabel.text = questionText
        correctAnswerLabel.text = "Correct Answer: \(answers[correctAnswerIndex])"

        if let selected = selectedAnswerIndex {
            if selected == correctAnswerIndex {
                resultLabel.text = "✅ Correct!"
                resultLabel.textColor = .systemGreen
            }
            else {
                resultLabel.text = "❌ Incorrect"
                resultLabel.textColor = .systemRed
            }
        }
        else {
            resultLabel.text = "No answer selected"
            resultLabel.textColor = .systemGray
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFinishedScene",
           let finishedVC = segue.destination as? FinishedViewController {
            
            finishedVC.totalQuestions = quiz.questions.count
            finishedVC.correctAnswers = correctAnswers
            finishedVC.quizTitle = quiz.title
        }
    }
    
    @objc func exitQuiz() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
