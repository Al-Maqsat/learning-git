//
//  DetailViewController.swift
//  Milestone Day 23
//
//  Created by Maksat Baiserke on 09.08.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    var worldFlags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let x = selectedImage?.replacingOccurrences(of: "@3x.png", with: "").uppercased()
        
        title = x
        
        navigationItem.largeTitleDisplayMode = .never
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        let flags = items.sorted()
        
        
        
        for flag in flags{
            if flag.contains(".png"){
                worldFlags.append(flag)
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        if let imageToLoad = selectedImage{
            imageView.image = UIImage(named: imageToLoad)
        }
        // Do any additional setup after loading the view.
    }
    
    
    @objc func share(){
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
