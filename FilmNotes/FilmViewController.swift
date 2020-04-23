//
//  FilmViewController.swift
//  FilmNotes
//
//  Created by Alexander Giagoulas on 22.04.20.
//  Copyright © 2020 Alexander Giagoulas. All rights reserved.
//

import UIKit

class FilmViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: Properties
    @IBOutlet weak var filmTextField: UITextField!
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // value either passed by "FilmTableViewController" in "prepare(for:sender)" or constructed as part of adding new film
    var film: Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Handle user input
        filmTextField.delegate = self;
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
    }

    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following :\(info)")
        }
        filmImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Actions
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        filmTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    

}

