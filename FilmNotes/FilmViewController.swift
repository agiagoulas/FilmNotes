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
    // Connect storyboard to code
    @IBOutlet weak var filmTextField: UITextField!
    @IBOutlet weak var filmImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var isoTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var eventTextField: UITextField!
    @IBOutlet weak var cameraTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextField!
    
    // Define UIPickerView for film selection with different films
    let filmPicker = UIPickerView()
    let filmPickerData = [String](arrayLiteral: "Adox CMS 20 II", "Adox SilverMax", "Agfa APX 100", "Agfa APX 400", "Bergger Pancro 400", "Cinestill BW", "Cinestill 50D", "Cinestill 800T", "CHM 100", "CHM 400", "Ferrania P30", "Fomapan 100", "Fomapan 200", "Fomapan 400", "Foma Retropan 320", "Fomapan R 100", "Fuji Neopan Acros 100", "Fuji Neopan 400CN", "FujiColor 100", "FujiColor Superia 400", "FujiColor C200", "FujiColor Superia X-tra 400", "FujiColor Pro 160NS", "FujIColor Pro 400H", "Fujichrome Velvia 50", "Fujichrome Velvia 100", "Fujichrome Velvia 100F", "Fujichrome Provia 100F", "Ilford Pan 100", "Ilford Pan 400", "Ilford Pan F", "Ilford FP4", "Ilford HP5", "Ilford Delta 100", "Ilford Delta 400", "Ilford Delta 3200", "Ilford XP2", "Ilford SFX200", "JCH 400", "Kentmere Pan 100", "Kentmere Pan 400", "Kodak Tri-X", "Kodak T-Max 100", "Kodak T-Max 400", "Kodak T-Max P3200", "Kodak ColorPlus 200", "Kodak Pro Image 100", "Kodak Gold 200", "Kodak Ultramax 400", "Kodak Ektar 100", "Kodak Portra 160", "Kodak Portra 400", "Kodak Portra 800", "Kodak Ektachrome E100", "KosmoFoto Mono", "Revolog Film", "Rollei RPX 25", "Rollei RPX 100", "Rollei RPX 400", "Rollei Ortho Plus", "Rollei Retro 80S", "Rollei SuperPan 200", "Rollei Retro 400S", "Rollei Infrared 400", "Rollei Blackbird", "other film")
    
    
    // Define UIPickerView for iso selection with different iso counts
    let isoPicker = UIPickerView()
    let isoPickerData = [String](arrayLiteral: "12", "25", "50", "100", "125", "200", "400", "800", "1600", "3200", "6400")
    
    // Define UIDatePicker for date selection
    let datePicker = UIDatePicker()
    
    // Define pickerAccessory for filmPicker and isoPicker with done button
    var pickerAccessory: UIToolbar?
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FilmViewController.doneBtnClicked(_:)))
    let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // flexible space
    
    // Define pickerAccessory for datePicker
    var datePickerAccessory: UIToolbar?
    let dateDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FilmViewController.doneBtnDateClicked(_:)))
    let dateFlexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // flexible space

    // Film either passed by TableViewController or constructed when adding a new film
    var film: Film?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup filmPicker
        filmTextField.inputView = filmPicker
        filmPicker.delegate = self
        
        // Setup isoPicker
        isoTextField.inputView = isoPicker
        isoPicker.delegate = self
        
        // Setup datePicker
        datePicker.datePickerMode = .date
        dateTextField.inputView = datePicker
        
        // Create UIToolbar for inputAccessoryView used in filmPicker and isoPicker
        pickerAccessory = UIToolbar()
        pickerAccessory?.autoresizingMask = .flexibleHeight
        var frame = pickerAccessory?.frame
        frame?.size.height = 44.0
        pickerAccessory?.frame = frame!
        pickerAccessory?.items = [flexSpace, doneButton]
                
        // Create UIToolbar for inputAccessoryView used in datePicker
        datePickerAccessory = UIToolbar()
        datePickerAccessory?.autoresizingMask = .flexibleHeight
        var dateFrame = datePickerAccessory?.frame
        dateFrame?.size.height = 44.0
        datePickerAccessory?.frame = dateFrame!
        datePickerAccessory?.items = [dateFlexSpace, dateDoneButton]
               
        // Handle film event input
        eventTextField.delegate = self
        
        // Handle film input
        filmTextField.inputAccessoryView = pickerAccessory
        
        // Handle iso input
        isoTextField.inputAccessoryView = pickerAccessory
        
        // Handle date input
        dateTextField.inputAccessoryView = datePickerAccessory
        
        // Set up views when editing existing film from TableView
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
        
        // Film object can only be saved when event is provided
        updateSaveButtonState()
    }
    
    
    // MARK: UIPickerViewDelegate
    // Number of columns of data for UIPickerViews
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // Number of rows of data for UIPickers
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        // Check which UIPickerView called function
        if pickerView == filmPicker {
            return filmPickerData.count
        } else {
            return isoPickerData.count
        }
    }
       
    // Return data from UIPickerView
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // Check which UIPickerView called function
        if pickerView == filmPicker {
            return filmPickerData[row]
        } else {
            return isoPickerData[row]
        }
    }
    
    // Capture picker view selection
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // Check which UIPickerView called function
        if pickerView == filmPicker {
            filmTextField.text = filmPickerData[row]
            // Set the image corresponding to the selected film
            setFilmImage(selectedFilm: filmPickerData[row])
        } else {
            isoTextField.text = isoPickerData[row]
        }
    }
       
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide keyboard after input
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        // Set title to event name after input
        navigationItem.title = textField.text
    }

    // Functions to make filmImageView clickable with ImagePicker
    // MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Change filmImageView to the selected image from gallery
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following :\(info)")
        }
        filmImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Navigation
    // Cancel function to cancel editing / creation of film object
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
        
        // define data of film with empty default string
        let name = filmTextField.text ?? ""
        let photo = filmImageView.image
        let iso = isoTextField.text ?? ""
        let date = dateTextField.text ?? ""
        let event = eventTextField.text ?? ""
        let camera = cameraTextField.text ?? ""
        let location = locationTextField.text ?? ""
        let notes = notesTextField.text ?? ""

        // set film to be passed to FilmTableViewController with defined data
        film = Film(name: name, photo: photo, event: event, camera: camera, iso: iso, location: location, date: date, notes: notes)
        
    }
    
    
    // MARK: Actions
    // Function to select image in photoLibrary
    @IBAction func selectImageFromLibrary(_ sender: UITapGestureRecognizer) {
        filmTextField.resignFirstResponder()
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    // MARK: Private Methods
    // Enable save button only when event is not empty
    private func updateSaveButtonState() {
        // disable save button if text is empty
        let text = eventTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    // Dismiss UIPickerViews on done button
    @objc func doneBtnClicked(_ button: UIBarButtonItem) {
        isoTextField?.resignFirstResponder()
        filmTextField?.resignFirstResponder()
    }
    
    // Dismiss UIDatePicker on done button
    @objc func doneBtnDateClicked(_ button: UIBarButtonItem) {
        // Convert date object from picker to string
        let df = DateFormatter()
        df.dateStyle = .full
        dateTextField.text = df.string(from: datePicker.date)
        dateTextField?.resignFirstResponder()
    }
    
    // Function to get the corresponding image names in Assets.xcassets to the entered film names in the UIPickerView
    // Set filmImageView to the corresponding image
    private func setFilmImage(selectedFilm: String) {
        var selectedImage: String
        
        // Set selectedImage to right image name - if no image exists in Assets.xcassets, defaultFilm image is set
        switch selectedFilm {
        case "Adox CMS 20 II": selectedImage = "adox-cms20"
        case "Adox SilverMax": selectedImage = "adox-silvermax"
        case "Agfa APX 100": selectedImage = "agfa-apx100"
        case "Agfa APX 400": selectedImage = "agfa-apx400"
        case "Bergger Pancro 400": selectedImage = "berrger-pancro400"
        case "Cinestill BW": selectedImage = "cinestill-bw"
        case "Cinestill 50D": selectedImage = "defaultFilm"
        case "Cinestill 800T": selectedImage = "cinestill-800"
        case "CHM 100": selectedImage = "chm100"
        case "CHM 400": selectedImage = "chm400"
        case "Ferrania P30": selectedImage = "defaultFilm"
        case "Fomapan 100": selectedImage = "fomapan100"
        case "Fomapan 200": selectedImage = "fomapan200"
        case "Fomapan 400": selectedImage = "fomapan400"
        case "Foma Retropan 320": selectedImage = "foma-retropan"
        case "Fomapan R 100": selectedImage = "fomapanR100"
        case "Fuji Neopan Acros 100": selectedImage = "defaultFilm"
        case "Fuji Neopan 400CN": selectedImage = "defaultFilm"
        case "FujiColor 100": selectedImage = "defaultFilm"
        case "FujiColor Superia 400": selectedImage = "defaultFilm"
        case "FujiColor C200": selectedImage = "fujicolor-c200"
        case "FujiColor Superia X-tra 400": selectedImage = "fujicolor-xtra400"
        case "FujiColor Pro 160NS": selectedImage = "defaultFilm"
        case "FujIColor Pro 400H": selectedImage = "fujicolor-pro400h"
        case "Fujichrome Velvia 50": selectedImage = "fuji-velvia50"
        case "Fujichrome Velvia 100": selectedImage = "fuji-velvia100"
        case "Fujichrome Velvia 100F": selectedImage = "defaultFilm"
        case "Fujichrome Provia 100F": selectedImage = "fuji-provia100f"
        case "Ilford Pan 100": selectedImage = "defaultFilm"
        case "Ilford Pan 400": selectedImage = "defaultFilm"
        case "Ilford Pan F": selectedImage = "ilford-panf"
        case "Ilford FP4": selectedImage = "ilford-fp4"
        case "Ilford HP5": selectedImage = "ilford-hp5"
        case "Ilford Delta 100": selectedImage = "ilford-delta100"
        case "Ilford Delta 400": selectedImage = "ilford-delta400"
        case "Ilford Delta 3200": selectedImage = "ilford-delta3200"
        case "Ilford XP2": selectedImage = "ilford-xp2"
        case "Ilford SFX200": selectedImage = "ilford-sfx"
        case "JCH 400": selectedImage = "defaultFilm"
        case "Kentmere Pan 100": selectedImage = "defaultFilm"
        case "Kentmere Pan 400": selectedImage = "defaultFilm"
        case "Kodak Tri-X": selectedImage = "kodak-trix"
        case "Kodak T-Max 100": selectedImage = "kodak-tmax100"
        case "Kodak T-Max 400": selectedImage = "kodak-tmax400"
        case "Kodak T-Max P3200": selectedImage = "defaultFilm"
        case "Kodak ColorPlus 200": selectedImage = "kodak-colorplus200"
        case "Kodak Pro Image 100": selectedImage = "defaultFilm"
        case "Kodak Gold 200": selectedImage = "kodak-gold200"
        case "Kodak Ultramax 400": selectedImage = "kodak-ultramax"
        case "Kodak Ektar 100": selectedImage = "kodak-ektar100"
        case "Kodak Portra 160": selectedImage = "kodak-portra160"
        case "Kodak Portra 400": selectedImage = "kodak-portra400"
        case "Kodak Portra 800": selectedImage = "kodak-portra800"
        case "Kodak Ektachrome E100": selectedImage = "defaultFilm"
        case "KosmoFoto Mono": selectedImage = "defaultFilm"
        case "Revolog Film": selectedImage = "revolog"
        case "Rollei RPX 25": selectedImage = "rollei-rpx25"
        case "Rollei RPX 100": selectedImage = "rollei-rpx100"
        case "Rollei RPX 400": selectedImage = "rollei-rpx400"
        case "Rollei Ortho Plus": selectedImage = "rollei-ortho"
        case "Rollei Retro 80S": selectedImage = "defaultFilm"
        case "Rollei SuperPan 200": selectedImage = "rollei-superpan"
        case "Rollei Retro 400S": selectedImage = "rollei-retro400"
        case "Rollei Infrared 400": selectedImage = "rollei-infrared"
        case "Rollei Blackbird": selectedImage = "defaultFilm"
        case "other film": selectedImage = "defaultFilm"
        default: selectedImage = "defaultFilm"
        }
        
        // Set image in filmImageView
        filmImageView.image = UIImage(named: selectedImage)
    }
}

