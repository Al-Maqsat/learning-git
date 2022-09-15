//
//  ViewController.swift
//  Project_1
//
//  Created by Maksat Baiserke on 30.07.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    var storms = [Storm]()
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recomendation))
        
        performSelector(inBackground: #selector(loadImages), with: nil)
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        
    }
    
    @objc func loadImages(){
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        let sortedItems = items.sorted()

        for item in sortedItems {
            if  item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        for i in 0..<pictures.count {
            print("Hello")
            storms.append(Storm(stormImage: pictures[i], stormCounter: 0))
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = storms[indexPath.row].stormImage
        cell.detailTextLabel?.text = "This image has opened \(storms[indexPath.row].stormCounter) times"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        storms[indexPath.row].stormCounter += 1
        if let vc = storyboard?.instantiateViewController(withIdentifier:  "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
                    for i in 1...pictures.count {
                        if vc.selectedImage == pictures[i-1]{
                            vc.x = i
                            vc.total = pictures.count
                            break
                        }
                    }
            navigationController?.pushViewController(vc, animated: true)
            tableView.reloadData()
        }
    }
    
    @objc func recomendation(){
        let new = UIActivityViewController(activityItems: ["I recommend this app"], applicationActivities: [])
        new.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(new, animated: true)
    }
}

