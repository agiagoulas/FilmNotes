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
    @IBOutlet weak var isoTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var cameraTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    // Define film picker
    let filmPicker = UIPickerView()
    let filmPickerData = [String](arrayLiteral: "Adox CMS 20 II", "Adox SilverMax", "Agfa APX 100", "Agfa APX 400", "Bergger Pancro 400", "Cinestill BW", "Cinestill 50D", "Cinestill 800T", "CHM 100", "CHM 400", "Ferrania P30", "Fomapan 100", "Fomapan 200", "Fomapan 400", "Foma Retropan 320", "Fomapan R 100", "Fuji Neopan Acros 100", "Fuji Neopan 400CN", "FujiColor 100", "FujiColor Superia 400", "FujiColor C200", "FujiColor Superia X-tra 400", "FujiColor Pro 160NS", "FujIColor Pro 400H", "Fujichrome Velvia 50", "Fujichrome Velvia 100", "Fujichrome Velvia 100F", "Fujichrome Provia 100F", "Ilford Pan 100", "Ilford Pan 400", "Ilford Pan F", "Ilford FP4", "Ilford HP5", "Ilford Delta 100", "Ilford Delta 400", "Ilford Delta 3200", "Ilford XP2", "Ilford SFX200", "JCH 400", "Kentmere Pan 100", "Kentmere Pan 400", "Kodak Tri-X", "Kodak T-Max 100", "Kodak T-Max 400", "Kodak T-Max P3200", "Kodak ColorPlus 200", "Kodak Pro Image 100", "Kodak Gold 200", "Kodak Ultramax 400", "Kodak Ektar 100", "Kodak Portra 160", "Kodak Portra 400", "Kodak Portra 800", "Kodak Ektachrome E100", "KosmoFoto Mono", "Revolog Film", "Rollei RPX 25", "Rollei RPX 100", "Rollei RPX 400", "Rollei Ortho Plus", "Rollei Retro 80S", "Rollei SuperPan 200", "Rollei Retro 400S", "Rollei Infrared 400", "Rollei Blackbird", "other film")
    
    
    // Define iso picker
    let isoPicker = UIPickerView()
    let isoPickerData = [String](arrayLiteral: "12", "25", "50", "100", "125", "200", "400", "800", "1600", "3200", "6400")
    
    // Define date picker
    let datePicker = UIDatePicker()
    
    // Define pickerAccessory
    var pickerAccessory: UIToolbar?
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FilmViewController.doneBtnClicked(_:)))
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // flexible space
    
    // Define date pickerAccessory
    var datePickerAccessory: UIToolbar?
    let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FilmViewController.doneBtnDateClicked(_:)))
    let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // flexible space

    // value either passed by "FilmTableViewController" in "prepare(for:sender)" or constructed as part of adding new film
    var film: Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup film picker
        filmTextField.inputView = filmPicker
        filmPicker.delegate = self
        
        // Setup iso picker
        isoTextField.inputView = isoPicker
        isoPicker.delegate = self
        
        // Setup date picker
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        
        // Create UIToolbar for inputAccessoryView
        pickerAccessory = UIToolbar()
        pickerAccessory?.autoresizingMask = .flexibleHeight
        var frame = pickerAccessory?.frame
        frame?.size.height = 44.0
        pickerAccessory?.frame = frame!
        pickerAccessory?.items = [flexSpace, doneButton]
                
        // Create Date UIToolbar for inputAccessoryView
        datePickerAccessory = UIToolbar()
        datePickerAccessory?.autoresizingMask = .flexibleHeight
        var dateFrame = datePickerAccessory?.frame
        dateFrame?.size.height = 44.0
        datePickerAccessory?.frame = dateFrame!
        datePickerAccessory?.items = [dateFlexSpace, dateDoneButton]
               
        // Handle Event name input
        eventTextField.delegate = self
        
        // Handle film input
        filmTextField.inputAccessoryView = pickerAccessory
        
        // Handle iso input
        isoTextField.inputAccessoryView = pickerAccessory
        
        // Handle date input
        dateTextField.inputAccessoryView = datePickerAccessory
        
        // set up views when editing existing film
        if let film = film {
            navigationItem.title = film.event
            filmTextField.text = film.name
            filmImageView.image = film.photo
            isoTextField.text = film.iso
            eventTextField.text = film.event
            cameraTextField.text = film.camera
            locationTextField.text = film.location
            dateTextField.text = film.date
            notesTextField.text = film.notes
        }
        
        // enable save button only if text field has valid film event
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
        if pickerView == filmPicker {
            return filmPickerData.count
        } else {
            return isoPickerData.count
        }
    }
       
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == filmPicker {
            return filmPickerData[row]
        } else {
            return isoPickerData[row]
        }
    }
    
    // Capture picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == filmPicker {
            filmTextField.text = filmPickerData[row]
        } else {
            isoTextField.text = isoPickerData[row]
        }
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
        let iso = isoTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let event = eventTextField.text ?? ""
        let camera = cameraTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let notes = notesTextField.text ?? ""

        // set film to be passed to FilmTableViewController after unwind segue
        film = Film(name: name, photo: photo, event: event, camera: camera, iso: iso, location: location, date: date, notes: notes)
        
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
        let text = eventTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // Dismiss picker
    @objc func doneBtnClicked(_ button: UIBarButtonItem) {
        // iso text field
        isoTextField?.resignFirstResponder()
        filmTextField?.resignFirstResponder()
    }
    
    // Dismiss date picker
    @objc func doneBtnDateClicked(_ button: UIBarButtonItem) {
        // date text field
        let df = DateFormatter()
        df.dateStyle = .full
        dateTextField.text = df.string(from: datePicker.date)
        dateTextField?.resignFirstResponder()
    }
    
    

}

