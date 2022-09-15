//
//  DetailViewController.swift
//  Milsetone Day 50
//
//  Created by Maksat Baiserke on 08.09.2022.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let selectedImage = selectedImage else {
            return
        }

        let path = getDocumentsDirectory().appendingPathComponent(selectedImage)
        
        imageView.image = UIImage(contentsOfFile: path.path)
        // Do any additional setup after loading the view.
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
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
