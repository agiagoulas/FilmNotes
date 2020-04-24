//
//  FilmViewController.swift
//  FilmNotes
//
//  Created by Alexander Giagoulas on 22.04.20.
//  Copyright © 2020 Alexander Giagoulas. All rights reserved.
//

import UIKit
import os.log

class FilmViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    // MARK: Properties
    @IBOutlet weak var filmTextField: UITextField!
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var ISOPicker: UIPickerView!
    
    var isoPickerData: [String] = [String]()
    
    
    // value either passed by "FilmTableViewController" in "prepare(for:sender)" or constructed as part of adding new film
    var film: Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup ISO Picker
        self.ISOPicker.delegate = self
        self.ISOPicker.dataSource = self
        isoPickerData = ["12", "25", "50", "100", "125", "200", "400", "800", "1600", "3200", "6400"]
        
        // Handle user input
        filmTextField.delegate = self;
        
        // set up views when editing existing film
        if let film = film {
            navigationItem.title = film.name
            filmTextField.text = film.name
            filmImageView.image = film.photo
        }
        
        // enable save button only if text field has valid film name
        updateSaveButtonState()
    }
    
    // MARK: UIPickerView
    override func didReceiveMemoryWarning() {
           super.didReceiveMemoryWarning()
           // Dispose of any resources that can be recreated.
       }

    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return isoPickerData.count
    }
       
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return isoPickerData[row]
    }
    
    // Capture picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(isoPickerData[row])
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
        // view controller needs to be dismissed in 2 different ways
        let isPresentingInAddFilmMode = presentingViewController is UINavigationController
        
        if isPresentingInAddFilmMode {
            dismiss(animated: true, completion: nil)
        } else if let owningNavigationController = navigationController {
            owningNavigationController.popViewController(animated: true)
        } else {
            fatalError("The FilmViewController is not inside navigation controller")
        }
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

