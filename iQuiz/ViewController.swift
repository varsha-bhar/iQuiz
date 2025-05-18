import UIKit
import Combine

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //let quizzes = sampleQuizzes
    let fetcher = QuizFetcher()
    var quizzes: [Quiz] {
        fetcher.quizzes
    }
    
    // EC pull to refresh
    let refreshControl = UIRefreshControl()
    private var cancellables = Set<AnyCancellable>()
    // EC Timed Refresh
    var refreshTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "iQuiz"
        tableView.delegate = self
        tableView.dataSource = self
        
        refreshControl.addTarget(self, action: #selector(refreshPulled), for: .valueChanged)
        tableView.refreshControl = refreshControl

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Settings",
            style: .plain,
            target: self,
            action: #selector(showSettings)
        )
        
        fetcher.$quizzes
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)

        fetcher.$errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &cancellables)

        let savedURL = UserDefaults.standard.string(forKey: "quizSourceURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        let interval = UserDefaults.standard.integer(forKey: "refreshInterval")
        fetcher.fetch(from: savedURL)
        if interval > 0 {
            startTimedRefresh(with: interval)
        }
    }
    
    // EC pull to refresh
    @objc func refreshPulled() {
        fetcher.fetch(from: "http://tednewardsandbox.site44.com/questions.json")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.refreshControl.endRefreshing()
        }
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
    
    func startTimedRefresh(with interval: Int) {
        refreshTimer?.invalidate()  // Clear existing timer
        refreshTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(interval), repeats: true) { [weak self] _ in
            let url = UserDefaults.standard.string(forKey: "quizSourceURL") ?? "http://tednewardsandbox.site44.com/questions.json"
            self?.fetcher.fetch(from: url)
        }
    }
    
    @objc func showSettings() {
        let alert = UIAlertController(title: "Settings", message: "Enter quiz source URL and refresh interval (in seconds)", preferredStyle: .alert)

        alert.addTextField { textField in
            textField.placeholder = "Enter URL"
            textField.text = UserDefaults.standard.string(forKey: "quizSourceURL") ?? "http://tednewardsandbox.site44.com/questions.json"
        }
        
        // EC refresh in user default
        alert.addTextField { textField in
            textField.placeholder = "Refresh interval (seconds)"
            textField.keyboardType = .numberPad
            textField.text = "\(UserDefaults.standard.integer(forKey: "refreshInterval"))"
        }

        alert.addAction(UIAlertAction(title: "Check Now", style: .default, handler: { [weak self] _ in
            guard let urlString = alert.textFields?[0].text,
                  let intervalText = alert.textFields?[1].text,
                  let interval = Int(intervalText) else { return }

            UserDefaults.standard.set(urlString, forKey: "quizSourceURL")
            UserDefaults.standard.set(interval, forKey: "refreshInterval")

            self?.fetcher.fetch(from: urlString)
            self?.startTimedRefresh(with: interval)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}

