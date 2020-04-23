//
//  FilmViewController.swift
//  FilmNotes
//
//  Created by Alexander Giagoulas on 22.04.20.
//  Copyright © 2020 Alexander Giagoulas. All rights reserved.
//

import UIKit
import os.log

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
        
        // enable save button only if text field has valid film name
        updateSaveButtonState()
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
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
    
    // MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // configuring view controller before its presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // configure destination view controller only when save button is pressed
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log:OSLog.default, type: .debug)
            return
        }
        
        let name = filmTextField.text ?? ""
        let photo = filmImageView.image

        // set film to be passed to FilmTableViewController after unwind segue
        film = Film(name: name, photo: photo)
        
    }
    
    // MARK: Actions
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        filmTextField.resignFirstResponder()
        
        let imagePickerController = UIImagePickerController()
        
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: Private Methods
    private func updateSaveButtonState() {
        // disable save button if text is empty
        let text = filmTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    

}

