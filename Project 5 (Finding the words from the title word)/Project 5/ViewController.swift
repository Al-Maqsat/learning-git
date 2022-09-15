//
//  ViewController.swift
//  Project 5
//
//  Created by Maksat Baiserke on 18.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    var Storage: storage = storage(theLastTitle: nil, LastUsedWords: nil)
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
            if let startWords = try? String(contentsOf: startWordsURL){
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty{
            allWords = ["silkworm"]
        }
        
        let defaults = UserDefaults.standard
        
        if let savedData = defaults.object(forKey: "storage") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                Storage = try jsonDecoder.decode(storage.self, from: savedData)
            } catch {
                print("Unable to load the data")
            }
        }
        
        if Storage.theLastTitle == nil {
            startGame()
        }
        
        if let Storedtitle = Storage.theLastTitle {
            if !Storedtitle.isEmpty {
                title = Storedtitle
                if Storage.LastUsedWords != nil{
                    usedWords = Storage.LastUsedWords!
                    tableView.reloadData()
                }
            }
        }
        // Do any additional setup after loading the view.
    }
    @objc func startGame(){
        Storage.theLastTitle?.removeAll()
        Storage.LastUsedWords?.removeAll()
        
        title = allWords.randomElement()
        if let titles = title {
            Storage.theLastTitle = titles
        }
        
        usedWords.removeAll(keepingCapacity: true)
        save()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    @objc func promptForAnswer(){
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default){
            [weak self, weak ac] action in
            
            guard let answer = ac?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String){
        
        let lowercasedAnswer = answer.lowercased()
        
        let errorMessage: String
        let errorTitle: String
        if isPossible(word: lowercasedAnswer){
            if isOriginal(word: lowercasedAnswer){
                if isReal(word: lowercasedAnswer){
                    usedWords.insert(answer, at: 0)
                    Storage.LastUsedWords = usedWords
                    save()
                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                    return
                } else {
                    errorTitle = "This is not real word"
                    errorMessage = "Likewise, maybe it is shorter than 3 letters, maybe it is the exactly same word as title"
                    showErrorMessage(title: errorTitle, message: errorMessage)
                }
            } else {
                errorTitle = "You already used this word"
                errorMessage = "Common, where is your imagination"
                showErrorMessage(title: errorTitle, message: errorMessage)
            }
        } else {
            guard let title = title?.lowercased() else {return}
            errorTitle = "This is not possible"
            errorMessage = "You just do not have some letters in the word \(title)"
            showErrorMessage(title: errorTitle, message: errorMessage)
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    func isPossible(word: String) -> Bool{
        
        guard var tempWord = title?.lowercased() else {return false}
        
        for letter in word {
            if let position = tempWord.firstIndex(of: letter){
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool{
        return !usedWords.description.lowercased().contains(word.lowercased())
    }
    
    func isReal(word: String) -> Bool{
        
        if word.utf16.count < 3 || word == title?.lowercased() {
            return false
        }
        
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspellRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspellRange.location == NSNotFound
    }
    
    func showErrorMessage(title: String, message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func save(){
        let jsonEncoder = JSONEncoder()
        
        if let savedData = try? jsonEncoder.encode(Storage){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "storage")
        } else {
            print("Failed to save the data")
        }
        
    }
}

