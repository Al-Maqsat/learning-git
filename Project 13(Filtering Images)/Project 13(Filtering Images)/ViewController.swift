//
//  ViewController.swift
//  Project 13(Filtering Images)
//
//  Created by Maksat Baiserke on 09.09.2022.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var intensity: UISlider!
    @IBOutlet var Radius: UISlider!
    @IBOutlet var scale: UISlider!
    @IBOutlet var changeFilterName: UIButton!
    
    
    var currentImage: UIImage!

    var acTitle: UIAlertController!
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    var arrayOfFilters = ["CIBumpDistortion", "CIGaussianBlur", "CIPixellate", "CISepiaTone", "CITwirlDistortion", "CIUnsharpMask", "CIVignette"]

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.alpha = 0
        imageView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        title = "Instafilter"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }
    
    @objc func importPicture(){
        let picker = UIImagePickerController()

        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        currentImage = image
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
        
    }
    
    @IBAction func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        
        for i in 0..<arrayOfFilters.count{
               ac.addAction(UIAlertAction(title: arrayOfFilters[i], style: .default, handler: setFilter))
               }
        acTitle = ac
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController{
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        present(ac, animated: true)

    }
    
    
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Error: there is no image for submission", message: nil, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    @IBAction func radiusChaged(_ sender: Any) {
        applyProcessing()
    }
    @IBAction func Scale(_ sender: Any) {
        applyProcessing()
    }
    
    
    func applyProcessing(){
        guard let outputImage = currentFilter.outputImage else {return}
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey){
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        
        if inputKeys.contains(kCIInputRadiusKey){
            currentFilter.setValue(Radius.value * 1000, forKey: kCIInputRadiusKey)
        }
        
        if inputKeys.contains(kCIInputScaleKey){
            currentFilter.setValue(scale.value * 10, forKey: kCIInputScaleKey)
        }
        
        if inputKeys.contains(kCIInputCenterKey){
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }
        
        
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent){
            let processedImage = UIImage(cgImage: cgImage)
            UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: {
                self.imageView.alpha = 1
                self.imageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: {
                finished in

            })
            imageView.image = processedImage
        }
    }
    
    
    func setFilter(_ action: UIAlertAction){
        guard currentImage != nil else {return}
        guard let actionTitle = action.title else {return}
        
        currentFilter = CIFilter(name: actionTitle)
        changeFilterName.setTitle(currentFilter.name, for: .normal)
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    

    
       @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer){
           if let error = error {
               let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           } else {
               let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos", preferredStyle: .alert)
               ac.addAction(UIAlertAction(title: "OK", style: .default))
               present(ac, animated: true)
           }
       }
    
}

