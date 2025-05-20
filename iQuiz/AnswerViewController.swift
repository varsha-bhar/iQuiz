import UIKit

class AnswerViewController: UIViewController {
    
    @IBOutlet weak var correctAnswerLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var yourAnswerLabel: UILabel!
    
    
    var questionText: String = ""
    var answers: [String] = []
    var correctAnswerIndex: Int = 0
    var selectedAnswerIndex: Int? = nil
    var currentQuestionIndex: Int = 0
    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    var quiz: Quiz!
    var userAnswer: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configure()
        configureGestures()
    }
    
    private func configure() {
        questionLabel.text = questionText
        correctAnswerLabel.text = "Correct Answer: \(answers[correctAnswerIndex])"

        if let selected = selectedAnswerIndex {
            let selectedAnswer = answers[selected]
            yourAnswerLabel.text = "You answered: \(selectedAnswer)"
            
            if selected == correctAnswerIndex {
                resultLabel.text = "✅ Correct!"
                resultLabel.textColor = .systemGreen
                correctAnswers += 1
            }
            else {
                resultLabel.text = "❌ Incorrect"
                resultLabel.textColor = .systemRed
            }
        }
        else {
            yourAnswerLabel.text = "You didn’t select an answer"
            resultLabel.text = "No answer selected"
            resultLabel.textColor = .systemGray
        }
    }

    private func configureGestures() {
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(nextTapped))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)

        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(exitQuiz))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        if currentQuestionIndex + 1 < quiz.questions.count {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
            nextVC.quiz = quiz
            nextVC.currentQuestionIndex = currentQuestionIndex + 1
            nextVC.correctAnswers = correctAnswers
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            performSegue(withIdentifier: "showFinishedScene", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFinishedScene",
           let finishedVC = segue.destination as? FinishedViewController {
            finishedVC.quizTitle = quiz.title
            finishedVC.totalQuestions = quiz.questions.count
            finishedVC.correctAnswers = correctAnswers
        }
    }
    
    @objc func exitQuiz() {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
