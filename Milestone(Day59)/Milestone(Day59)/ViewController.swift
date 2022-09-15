//
//  ViewController.swift
//  Milestone(Day59)
//
//  Created by Maksat Baiserke on 13.09.2022.
//

import UIKit

class ViewController: UITableViewController {
    var news = [feed]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://newsapi.org/v2/everything?q=tesla&from=2022-08-15&sortBy=publishedAt&apiKey=55a0db47be0546e1bcf943d80f0445c6"
        
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            }
        }
                // as understand this just returns string
                // parse(json: data)
        }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Title", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = news[indexPath.row].source.name
        
        cell.contentConfiguration = content
        return cell
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let newsFromJson = try? decoder.decode(News.self, from: json){
            news = newsFromJson.articles
            tableView.reloadData()
            // MARK: - WHY we need this tableView reload Data
        }
    }
}

