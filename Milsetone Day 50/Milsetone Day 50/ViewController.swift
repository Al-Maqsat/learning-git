//
//  ViewController.swift
//  Milsetone Day 50
//
//  Created by Maksat Baiserke on 08.09.2022.
//

import UIKit

class ViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let picker = UIImagePickerController()
    var imageCells = [imageCellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(openCamera))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openGallary))
    }
    
    @objc func openGallary(action: UIAlertAction){
        picker.allowsEditing = true
        picker.delegate = self          // I want to be your intern
        present(picker, animated: true)
    }
    
    @objc func openCamera(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.allowsEditing = true
            picker.delegate = self   // I want to be your intern
            present(picker, animated: true)
            
        } else {
            let alert = UIAlertController(title: "Camera is not available", message: "Please, check the settings", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(alert, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
                
        let imageDefaultData = imageCellData(image: imageName, description: "Unknown")
        
        imageCells.append(imageDefaultData)
        tableView.reloadData()
        dismiss(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageCells.count
    }
    
    func getDocumentsDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as? imageCell else {
            fatalError("Cannot dequeue the cell")
        }
        
        let path = getDocumentsDirectory().appendingPathComponent(imageCells[indexPath.row].image)
            cell.actualImage.image = UIImage(contentsOfFile: path.path)
        
        cell.actualLabel.text = imageCells[indexPath.row].description
        
        cell.actualImage.layer.cornerRadius = 10
        cell.layer.cornerRadius = 17
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = imageCells[indexPath.row].image
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

