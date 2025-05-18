import Foundation

class QuizFetcher: ObservableObject {
    @Published var quizzes: [Quiz] = []
    @Published var errorMessage: String?

    func fetch(from urlString: String) {
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error as? URLError, error.code == .notConnectedToInternet {
                    self.errorMessage = "No internet connection"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode([RemoteQuiz].self, from: data)
                    self.quizzes = self.convert(remote: decoded)
                }
                catch {
                    self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    private func iconForTitle(_ title: String) -> String {
        switch title {
        case "Mathematics":
            return "math_icon"
        case "Science!":
            return "science_icon"
        case "Marvel Super Heroes":
            return "marvel_icon"
        default:
            return "default_icon"
        }
    }
    
    func convert(remote: [RemoteQuiz]) -> [Quiz] {
        return remote.map { remoteQuiz in
            let icon = iconForTitle(remoteQuiz.title)
            return Quiz(
                title: remoteQuiz.title,
                description: remoteQuiz.desc,
                iconName: icon,
                questions: remoteQuiz.questions.map { remoteQ in
                    Question(
                        text: remoteQ.text,
                        options: remoteQ.answers,
                        correctIndex: Int(remoteQ.answer) ?? 0
                    )
                }
            )
        }
    }
}
