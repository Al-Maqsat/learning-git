//
//  ViewController.swift
//  Project 7
//
//  Created by Maksat Baiserke on 23.08.2022.
//

import UIKit
import WebKit

class ViewController: UITableViewController {
    var petitions = [Petition]()
    var backupPetiton = [Petition]()
    var found = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(search))
            
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Petitions"
        
        let urlString: String
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
                return
            }
        }
        showError()
    }
    
    @objc func search(){
        let x = UIAlertController(title: "Filtering", message: "Enter keywords to find necessary information", preferredStyle: .alert)
        x.addTextField()
        
        let search = UIAlertAction(title: "search", style: .default){
            [weak self, weak x] action in
            
            guard let answer = x?.textFields?[0].text else {return}
            self?.submit(answer)
        }
        x.addAction(search)
        present(x, animated: true)
    }
    
    func submit(_ answer: String){
        petitions = backupPetiton
        tableView.reloadData()
        
        for i in 0..<petitions.count{
            
            if petitions[i].title.lowercased().contains(answer.lowercased()) || petitions[i].body.lowercased().contains(answer.lowercased()){
                found.append(petitions[i])
            }
        }
        petitions.removeAll(keepingCapacity: true)
        petitions = found
        found.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    
    @objc func showCredits(){
        let ac = UIAlertController(title: "Source:", message: " This data comes from: \"We The People API of the Whitehouse\" ", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func showError(){
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel))
        present(ac, animated: true)
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
            petitions = jsonPetitions.results
            backupPetiton = petitions
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
//        print(petitions[0])
        navigationController?.pushViewController(vc, animated: true)
    }
}

