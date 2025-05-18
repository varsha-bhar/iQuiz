import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //let quizzes = sampleQuizzes
    let fetcher = QuizFetcher()
    var quizzes: [Quiz] {
        fetcher.quizzes
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iQuiz"
        tableView.delegate = self
        tableView.dataSource = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
        
        // ✅ Observe changes to quizzes
        fetcher.$quizzes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        // ✅ Optional: print error messages
        fetcher.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        // ✅ Start fetching
        let savedURL = UserDefaults.standard.string(forKey: "quizSourceURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        fetcher.fetch(from: savedURL)
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizzes.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let questionVC = storyboard.instantiateViewController(withIdentifier: "QuestionViewController") as! QuestionViewController
        questionVC.quiz = quizzes[indexPath.row]
        navigationController?.pushViewController(questionVC, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTableCell", for: indexPath) as! QuizTableCell
        let quiz = quizzes[indexPath.row]
        cell.titleLabel.text = quiz.title
        cell.descLabel.text = quiz.description
        cell.iconImageView.image = UIImage(named: quiz.iconName)
        return cell
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "Settings", message: "Enter quiz source URL", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Enter URL"
            textField.text = UserDefaults.standard.string(forKey: "quizSourceURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        }

        alert.addAction(UIAlertAction(title: "Check Now", style: .default, handler: { [weak self] _ in
            if let urlString = alert.textFields?.first?.text {
                UserDefaults.standard.set(urlString, forKey: "quizSourceURL")
                self?.fetcher.fetch(from: urlString)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        present(alert, animated: true)
    }
}

