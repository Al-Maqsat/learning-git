//
//  ViewController.swift
//  Project 2
//
//  Created by Maksat Baiserke on 04.08.2022.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var i = 0
    var highestScore = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(showScore))
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland" ,"russia", "spain", "uk", "us"]
            
        button1.imageView?.layer.borderWidth = 1
        button2.imageView?.layer.borderWidth = 1
        button3.imageView?.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion(action: nil)
//        [button1, button2, button3].forEach {
//                    $0?.imageView?.layer.borderWidth = 1
//                    $0?.imageView?.layer.borderColor = UIColor.lightGray.cgColor
//                }
        }
    func askQuestion(action: UIAlertAction?){
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        [button1, button2, button3].forEach {
            $0?.transform = CGAffineTransform(scaleX: 1, y: 1)
        }  // very useful one
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        title = countries[correctAnswer].uppercased() + " (Your current score is \(score))"
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String?
                
        if sender.tag == correctAnswer{
            title = "Correct! Your current score is \(score)"
            score += 1
            i += 1
        } else {
            title = "Wrong!"

            let ac = UIAlertController(title: title, message:  "It is not \(countries[correctAnswer].uppercased()), it is \(countries[sender.tag].uppercased())", preferredStyle: .alert)
            
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            
            present(ac, animated: true)
            title = "Your current score is \(score)"

            score -= 1
            if score <= 0 {
                score = 0
            }
            i += 1
        }

        if i == 10 {
            var message: String?
            if score > highestScore {
                message = "New record"
                highestScore = score
            }
            
            title = "Final score is: \(score)"
            
            let x = UIAlertController(title: title, message: message, preferredStyle: .alert)

            x.addAction(UIAlertAction(title: "Try again", style: .default))
//            , handler: askQuestion)
            present(x, animated: true)
            i = 0
            score = 0
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 4, options: [], animations: {
            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        }, completion: {
            finished in
        })
        
//        UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
//            sender.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
//        }, completion: {
//            finished in
//        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            [weak self] in
            self?.askQuestion(action: nil)
        })
    }
    
    @objc func showScore(){
        
        let x = UIAlertController(title: "Your score is \(score)", message: nil, preferredStyle: .alert)
        x.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(x, animated: true)
    }

}

