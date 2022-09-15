//
//  ViewController.swift
//  Project 10
//
//  Created by Maksat Baiserke on 30.08.2022.
//

import UIKit

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var people = [Person]()
    var indexChosen = IndexPath(item: 0, section: 0)
    let picker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            if let decodePeople = try? NSKeyedUnarchiver.unarchivedObject(ofClasses: [Person.self], from: savedPeople) as? [Person] { // so here we write instead of [anyclass] the [Person] adding self -> [Person.self] because it requires that one
                people = decodePeople
            }
        }
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue a PersonCell.")
         }
        
        let person = people[indexPath.item]
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image) // person image is UUID
        
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
//        cell.clipsToBounds = true
        cell.layer.cornerRadius = 17
        
        
        return cell
    }
    
    @objc func addNewPerson(){

        let ac = UIAlertController(title: "From where you want to import images?", message: nil, preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Photos library", style: .default, handler: openGallary))
        
        ac.addAction(UIAlertAction(title: "Camera", style: .default, handler: openCamera))
        present(ac, animated: true)
    }
    
    
    func openGallary(action: UIAlertAction){
        picker.allowsEditing = true
        picker.delegate = self          // I want to be your intern
        present(picker, animated: true)
    }
    
    
    func openCamera(action: UIAlertAction){
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
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) { // making things that boss send to me
        
        guard let image = info[.editedImage] as? UIImage else {return}
        
        let imageName = UUID().uuidString //generates unique name
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName) // adds that unique name to the directory of the image
        
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath) // writes to that directory compressed photo
        }
        
        let person = Person(name: "unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL{
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return path[0]
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexChosen = indexPath
        
        let renameOrDelete = UIAlertController(title: "Choose what to do", message: "Warning: changes cannot be reverted!", preferredStyle: .alert)
        
        renameOrDelete.addAction(UIAlertAction(title: "Delete", style: .default, handler: deleteImage))
        
        renameOrDelete.addAction(UIAlertAction(title: "Rename", style: .default, handler: renameImage))
        
        present(renameOrDelete, animated: true)
        
        
    }

    func deleteImage(action: UIAlertAction){
        let delete = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
        delete.addAction(UIAlertAction(title: "Yes", style: .destructive){
            [weak self] _ in
            self?.people.remove(at: self!.indexChosen.item)
            self?.collectionView.deleteItems(at: [self!.indexChosen])
            self?.collectionView.reloadData()
        })
        delete.addAction(UIAlertAction(title: "No", style: .cancel))
        
        present(delete, animated: true)
        collectionView.reloadData()
    }
    
    
    
    func renameImage(action: UIAlertAction){
        let person = people[indexChosen.item]
        
        let ac = UIAlertController(title: "Rename", message: "Type what you want", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "OK", style: .default){
            [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else {return}
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(ac, animated: true)
    }
    
    func save(){
        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: people, requiringSecureCoding: false){
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        }
    }
}
