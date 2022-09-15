//
//  ViewController.swift
//  Project 6b
//
//  Created by Maksat Baiserke on 19.08.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .red
        label1.text = "These"
        label1.sizeToFit()
        
        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .cyan
        label2.text = "Are"
        label2.sizeToFit()
        
        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .blue
        label3.text = "Some"
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .gray
        label4.text = "Awesome"
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .green
        label5.text = "Labels"
        label5.sizeToFit()
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
//        let viewDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
//
//        for label in viewDictionary.keys{
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|",options: [], metrics: nil, views: viewDictionary))
//        }
//
//        let metrics = ["labelH": 80]
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelH@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewDictionary))
//        // Do any additional setup after loading the view.
        
        var previous: UILabel?
        for label in [label1, label2, label3, label4, label5] {
//            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//            label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//            label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            
//            let y = view.bounds.height
//            label.heightAnchor.constraint(equalToConstant: y/5 - 24).isActive = true
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
            
            if let previous = previous {
                    label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
                } else {
                    label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
                }
            
            previous = label
        }
        

    }
    


}

