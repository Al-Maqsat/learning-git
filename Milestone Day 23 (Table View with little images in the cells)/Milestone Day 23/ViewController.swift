//
//  ViewController.swift
//  Milestone Day 23
//
//  Created by Maksat Baiserke on 09.08.2022.
//

import UIKit

class ViewController: UITableViewController {
    var worldFlags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "World Flags app"
        
        navigationController?.navigationBar.prefersLargeTitles = true
                
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        let flags = items.sorted()
        
        for flag in flags{
            if flag.contains(".png"){
                worldFlags.append(flag)
            }
        }
        
        // Do any additional setup after loading the view.
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return worldFlags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "worldFlags", for: indexPath)
        let countryName = worldFlags[indexPath.row].replacingOccurrences(of: "@3x.png", with: "")
        cell.textLabel?.text = countryName.uppercased()
        cell.imageView?.image = UIImage(named: "\(worldFlags[indexPath.row])")
        cell.imageView?.layer.borderColor = UIColor.gray.cgColor
        cell.imageView?.layer.borderWidth = 2
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = worldFlags[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

