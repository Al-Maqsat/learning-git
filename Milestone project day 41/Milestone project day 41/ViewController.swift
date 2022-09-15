//
//  ViewController.swift
//  Milestone project day 41
//
//  Created by Maksat Baiserke on 28.08.2022.
//

import UIKit

class ViewController: UIViewController {
    var livesLabel: UILabel!
    var gameName: UILabel!
    var theWordArea: UILabel!
    var currentCharacter: UITextField!
    var counter = 0
    var x: String?
    var y = [String]()
    var wordLowercased = [String]()
    var hiddenWord = [String]()
    var submit: UIButton!

    var lives = 7 {
        didSet {
            livesLabel.text = "Lives left: \(lives)"
        }
    }
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        livesLabel = UILabel()
        livesLabel.translatesAutoresizingMaskIntoConstraints = false
        livesLabel.textAlignment = .right
        livesLabel.text = "Lives left: 7"
        view.addSubview(livesLabel)
        
        gameName = UILabel()
        gameName.translatesAutoresizingMaskIntoConstraints = false
        gameName.font = UIFont.systemFont(ofSize: 60)
        gameName.text = "Hang Man"
        view.addSubview(gameName)
        
        theWordArea = UILabel()
        theWordArea.translatesAutoresizingMaskIntoConstraints = false
        theWordArea.font = UIFont.systemFont(ofSize: 30)
        theWordArea.text = "Alisher"
        view.addSubview(theWordArea)
        
        currentCharacter = UITextField()
        currentCharacter.translatesAutoresizingMaskIntoConstraints = false
        currentCharacter.placeholder = "Enter a character"
        currentCharacter.autocapitalizationType = .none
        currentCharacter.textAlignment = .center
        currentCharacter.font = UIFont.systemFont(ofSize: 40)
        view.addSubview(currentCharacter)
        
        let submit = UIButton(type: .system)
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        submit.setTitle("SUBMIT", for: .normal)
        submit.layer.borderColor = UIColor.black.cgColor
        submit.layer.borderWidth = 1
        view.addSubview(submit)
        
        let clear = UIButton(type: .system)
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
        NSLayoutConstraint.activate([
            livesLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            livesLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            gameName.topAnchor.constraint(equalTo: livesLabel.bottomAnchor,constant: 50),
            gameName.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            
            theWordArea.topAnchor.constraint(equalTo: gameName.bottomAnchor, constant: 70),
            theWordArea.centerXAnchor.constraint(equalTo: gameName.centerXAnchor),
            
            currentCharacter.topAnchor.constraint(equalTo: theWordArea.bottomAnchor, constant: 40),
            currentCharacter.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
            currentCharacter.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.9),
            
            submit.topAnchor.constraint(equalTo: currentCharacter.bottomAnchor,constant: 20),
            submit.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -100),
            submit.heightAnchor.constraint(equalToConstant: 44),
            
            clear.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 100),
            clear.heightAnchor.constraint(equalToConstant: 44),
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor)
        ])
        
        livesLabel.backgroundColor = .green
        gameName.textColor = .purple
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel()
    }
    
    func loadLevel(){
        if let x = theWordArea.text{
            for letter in x {
                let fromLetterToString = String(letter)
                        y.append(fromLetterToString)
                        wordLowercased.append(fromLetterToString.lowercased())
                    }
        }
        
        for _ in 0..<y.count{
            hiddenWord += ["?"]
        }
        theWordArea.text = hiddenWord.joined()
    }
    
    @objc func submitTapped(){
        guard let characterSubmitted = currentCharacter.text else {return}
        
        
        if currentCharacter.text?.utf16.count == 1{
            let char = characterSubmitted.lowercased()
            if wordLowercased.firstIndex(of: char) != nil {} else { warning("There is no such letter in this word", "Now you are one point closer to lose", "OK") }
            
            while true {
                    if let replacingPosition = wordLowercased.firstIndex(of: char){
                            hiddenWord[replacingPosition] = y[replacingPosition]
                            wordLowercased[replacingPosition] = ""
                            counter += 1
                        if counter == wordLowercased.count{
                            warning("You won", "Good deduction", "Great")
                        }
                    } else {
                        break
                    }
            }
        } else {
            warning("It must be exactly one letter", "Now you are one point closer to lose", "OK")
        }
            theWordArea.text = hiddenWord.joined()
            currentCharacter.text?.removeAll(keepingCapacity: true)
//        if currentCharacter.text?.utf16.count == 1{
//            while true {
//            let char = Character(characterSubmitted.lowercased())
//                let word = y.joined().lowercased()
//                    if let replacingPosition = word.firstIndex(of: char){
//                            hiddenWord[replacingPosition] = y[replacingPosition]
//                            y[replacingPosition] = ""
//                    } else { break }
//                }
//        }
    }
    
    func warning(_ errorType: String, _ message: String, _ button: String) {
        let ac = UIAlertController(title: errorType, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: button, style: .default, handler: youHaveLostOneLife))
        present(ac, animated: true)
    }
    
    func  youHaveLostOneLife(action: UIAlertAction){
        lives -= 1
        clearTapped()
        if lives == 4{
            livesLabel.backgroundColor = .yellow
        } else if lives == 0 {
            livesLabel.backgroundColor = .red
            let startOverOrNot = UIAlertController(title: "Game is over", message: "You can try this game", preferredStyle: .alert)
            startOverOrNot.addAction(UIAlertAction(title: "I am tired", style: .cancel))
            startOverOrNot.addAction(UIAlertAction(title: "Try again", style: .default, handler: startOverFunc))
            present(startOverOrNot, animated: true)
        }
        
    }
    
    @objc func clearTapped(){
        currentCharacter.text?.removeAll(keepingCapacity: true)
    }
    
    func startOverFunc(action: UIAlertAction){
        lives = 7
        y.removeAll()
        hiddenWord.removeAll()
        loadLevel()
    }
}
