//
//  ViewController.swift
//  Milestone day 32
//
//  Created by Maksat Baiserke on 22.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    var shopList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Shopping list"
//        let textLabel = UILabel()
//        textLabel.text = "Shopping list"
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//
//        let targetView = self.navigationController?.navigationBar
//        targetView?.addSubview(textLabel)
//        textLabel.centerXAnchor.constraint(equalTo: (targetView?.centerXAnchor)!).isActive = true
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refresher))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addStuff))
        
        toolbarItems = [spacer, shareButton]
        navigationController?.isToolbarHidden = false
        
        // Do any additional setup after loading the view.
    }
    @objc func refresher(){
        shopList.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shopList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Shop", for: indexPath)
        cell.textLabel?.text = shopList[indexPath.row]
        return cell
    }
    
    @objc func addStuff(){
        let ac = UIAlertController(title: "Write halal product", message: "Do not eat haram!", preferredStyle: .alert)
        ac.addTextField()
        
        let add = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] action in
            
            guard let answer = ac?.textFields?[0].text else{return}
            self?.submit(answer)
        }
        ac.addAction(add)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: false)
    }
    
    func submit(_ thing: String){
        shopList.insert(thing, at: 0)

        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func share(){
        
        let list = shopList.joined(separator: "\n")
        let share = UIActivityViewController(activityItems: [list], applicationActivities: [])
        share.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(share, animated: false)
    }

}

