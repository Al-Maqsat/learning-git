//
//  DetailViewController.swift
//  Project_1
//
//  Created by Maksat Baiserke on 30.07.2022.
//

import UIKit

class DetailViewController: UIViewController {

                                            // These lines are for accessing before entering
    @IBOutlet var imageView: UIImageView! // This is connected to something in                                              Interface Builder
    var selectedImage: String?
    var x: Int?
    var total: Int?
    
    override func viewDidLoad() {   // This part of the code will start when we will                                push this Detail View Controller
        super.viewDidLoad()
        
        title = "Picture \(x!) of \(total!)"
        navigationItem.largeTitleDisplayMode = .never


        if let imageToLoad = selectedImage{
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) { // After entering VC from View Controller it will automatically activate hidesBarsOnTap, for all View Controllers
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {// Before leaving the VC it will deactivate hidesBarsOnTap, for all View Controllers, without this function, hidesBarOnTap will be activated for all of them
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
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
