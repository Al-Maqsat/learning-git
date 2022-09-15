//
//  ViewController.swift
//  Project 4
//
//  Created by Maksat Baiserke on 10.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    var websites = ["apple.com", "hackingwithswift.com", "youtube.com", "google.com"]
    var safeWebsites = ["apple.com", "hackingwithswift.com"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browser"
        navigationController?.navigationBar.prefersLargeTitles = true
    
        // Do any additional setup after loading the view.
    }

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "URL", for: indexPath)
        cell.textLabel?.text = websites[indexPath.row]
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let wvc = storyboard?.instantiateViewController(withIdentifier: "Website") as? WebsiteViewController {
            wvc.selectedWebsite = websites
            wvc.safe = safeWebsites
            wvc.x = indexPath.row
            navigationController?.pushViewController(wvc, animated: true)
        }
        
    }
    

}

