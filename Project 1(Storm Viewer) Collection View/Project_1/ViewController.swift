//
//  ViewController.swift
//  Project_1
//
//  Created by Maksat Baiserke on 30.07.2022.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
                
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(recomendation))
        
        performSelector(inBackground: #selector(loadImages), with: nil)
        collectionView.performSelector(onMainThread: #selector(UICollectionView.reloadData), with: nil, waitUntilDone: false)
        
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
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath)
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: cell.bounds.size.width, height: 50))
        title.text = pictures[indexPath.row]
        title.font = UIFont(name: "AvenirNext-Bold", size: 15)
        title.textAlignment = .center
        cell.contentView.addSubview(title)
        cell.layer.borderColor = UIColor(white: 0, alpha: 0.4).cgColor
        cell.layer.borderWidth = 2
        cell.layer.cornerRadius = 7
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
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
        }
    }
    
    @objc func recomendation(){
        let new = UIActivityViewController(activityItems: ["I recommend this app"], applicationActivities: [])
        new.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(new, animated: true)
    }
}

