import UIKit

class FinishedViewController: UIViewController {
    
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var totalQuestions: Int = 0
    var correctAnswers: Int = 0
    var quizTitle: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = quizTitle
        updateFeedback()
    }
    
    func updateFeedback() {
        scoreLabel.text = "You got \(correctAnswers) out of \(totalQuestions) correct"

        let percent = Double(correctAnswers) / Double(totalQuestions)
        switch percent {
        case 1.0:
            feedbackLabel.text = "🎉 Perfect Score!"
        case 0.75...0.99:
            feedbackLabel.text = "👏 Great Job!"
        case 0.5..<0.75:
            feedbackLabel.text = "👍 Not bad!"
        default:
            feedbackLabel.text = "😅 Keep practicing!"
        }
    }
    
    @IBAction func homeButtonTapped(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
}
