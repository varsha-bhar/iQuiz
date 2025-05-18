import UIKit

class QuestionViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var answerLabel1: UILabel!
    @IBOutlet weak var answerLabel2: UILabel!
    @IBOutlet weak var answerLabel3: UILabel!
    @IBOutlet weak var answerLabel4: UILabel!
    
    
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

        loadQuestion()
    }
    
    func loadQuestion() {
        let question = quiz.questions[currentQuestionIndex]
        questionLabel.text = question.text

        let labels = [answerLabel1, answerLabel2, answerLabel3, answerLabel4]
        for (i, label) in labels.enumerated() {
            if i < question.options.count {
                label?.text = question.options[i]
                label?.isHidden = false
                label?.backgroundColor = .systemGray5
                label?.layer.cornerRadius = 8
                label?.layer.masksToBounds = true
            }
            else {
                label?.isHidden = true
            }
        }

        selectedLabel = nil
        selectedAnswerIndex = nil
        submitButton.isEnabled = false
    }
    
    @IBAction func answerSelect(_ sender: UITapGestureRecognizer) {
        guard let tappedLabel = sender.view as? UILabel else { return }

        let labels = [answerLabel1, answerLabel2, answerLabel3, answerLabel4]

        // Reset all labels
        for label in labels {
            label?.backgroundColor = .systemGray5
        }

        // Highlight selected
        tappedLabel.backgroundColor = .systemGreen
        selectedLabel = tappedLabel
        submitButton.isEnabled = true

        // Determine selected index
        if let index = labels.firstIndex(of: tappedLabel) {
            selectedAnswerIndex = index
        }
    }

    
    @IBAction func submitTapped(_ sender: UIButton) {
        guard selectedAnswerIndex != nil else { return }
        performSegue(withIdentifier: "showAnswerScene", sender: self)
    }
    
    
    @objc func submitAnswer() {
        guard selectedAnswerIndex != nil else { return }
        performSegue(withIdentifier: "showAnswerScene", sender: self)
    }

    @objc func exitQuiz() {
        correctAnswers = 0
        navigationController?.popToRootViewController(animated: true)
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

            // Score tracking
            if selectedAnswerIndex == dest.correctAnswerIndex {
                dest.correctAnswers += 1
            }
        }
    }
    
}
