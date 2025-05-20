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
                    print("Offline mode: loading local quizzes")
                    self.loadFromDevice()
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data"
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode([RemoteQuiz].self, from: data)
                    self.quizzes = self.convert(remote: decoded)
                    self.saveToDisk(data)
                } catch {
                    self.errorMessage = "Failed to decode: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    func convert(remote: [RemoteQuiz]) -> [Quiz] {
        return remote.map { remoteQuiz in
            let icon = iconForTitle(remoteQuiz.title)
            return Quiz(
                title: remoteQuiz.title,
                description: remoteQuiz.desc,
                iconName: icon,
                questions: remoteQuiz.questions.map { remoteQ in
                    let correctIndex = max((Int(remoteQ.answer) ?? 1) - 1, 0)
                    return Question(
                        text: remoteQ.text,
                        options: remoteQ.answers,
                        correctIndex: correctIndex
                    )
                }
            )
        }
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

    private func saveLocalFile() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0].appendingPathComponent("quizzes.json")
    }

    private func saveToDisk(_ data: Data) {
        do {
            let url = saveLocalFile()
            try data.write(to: url)
        } catch {
            print("Failed to save quizzes locally: \(error)")
        }
    }

    private func loadFromDevice() {
        let fileURL = saveLocalFile()
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([RemoteQuiz].self, from: data)
            self.quizzes = self.convert(remote: decoded)
        } catch {
            self.errorMessage = "Failed to load local data"
        }
    }
}
