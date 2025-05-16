//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Varsha Bharath on 5/16/25.
//


import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel1: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var answerLabel3: UILabel!

    
    var selectedLabel: UILabel?
    var selectedAnswerIndex: Int?
        
    var quiz: Quiz!
    var currentQuestionIndex: Int = 0
    var correctAnswers: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        submitButton.isEnabled = false
        title = quiz.title
        
        // Swipe Right = submit answer
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(submitAnswer))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)

        // Swipe Left = exit quiz
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(exitQuiz))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)

        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text

        answerLabel1.text = question.options[0]
        answerLabel2.text = question.options[1]
        answerLabel3.text = question.options[2]

        resetLabelStyles()
    }
    
    func resetLabelStyles() {
        [answerLabel1, answerLabel2, answerLabel3].forEach {
            $0?.backgroundColor = .systemGray5
            $0?.layer.cornerRadius = 8
            $0?.layer.masksToBounds = true
        }
    }
    
    @IBAction func answerSelect(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel else { return }
        
        // Reset previous selection
        selectedLabel?.backgroundColor = .systemGray5

        // Update new selection
        selectedLabel = tappedLabel
        selectedLabel?.backgroundColor = .systemGreen
        submitButton.isEnabled = true

        // Determine selected index
        if tappedLabel == answerLabel1 { selectedAnswerIndex = 0 }
        else if tappedLabel == answerLabel2 { selectedAnswerIndex = 1 }
        else if tappedLabel == answerLabel3 { selectedAnswerIndex = 2 }
    }

    
    @IBAction func submitTapped(_ sender: UIButton) {
        guard selectedAnswerIndex != nil else { return }
        performSegue(withIdentifier: "showAnswerScene", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnswerScene",
           let dest = segue.destination as? AnswerViewController {
            let question = quiz.questions[currentQuestionIndex]
            dest.questionText = question.text
            dest.answers = question.options
            dest.correctAnswerIndex = question.correctIndex
            dest.selectedAnswerIndex = selectedAnswerIndex
            dest.quiz = quiz
            dest.currentQuestionIndex = currentQuestionIndex
            dest.correctAnswers = correctAnswers
        }
    }
    
    @objc func submitAnswer() {
        guard selectedAnswerIndex != nil else { return }
        performSegue(withIdentifier: "showAnswerScene", sender: self)
    }

    @objc func exitQuiz() {
        correctAnswers = 0  // 🧹 Discard score if exiting early
        navigationController?.popToRootViewController(animated: true)
    }
    
}
