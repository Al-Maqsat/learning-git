//
//  DetailViewController.swift
//  Project_1
//
//  Created by Maksat Baiserke on 30.07.2022.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var pictures = [String]()
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        let sortedItems = items.sorted()

        for item in sortedItems {
            if  item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        var x: String?

        for i in 1...pictures.count {
            if selectedImage == pictures[i-1]{
                x = "\(i)"
                break
            }
        }
        
            
        title = "Picture \(x!) of \(pictures.count)"

        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage{
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    // MARK: - Properties
    @objc func shareTapped(){

        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    // MARK: - Properties

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
