//
//  FilmTableViewController.swift
//  FilmNotes
//
//  Created by Alexander Giagoulas on 23.04.20.
//  Copyright © 2020 Alexander Giagoulas. All rights reserved.
//

import UIKit

class FilmTableViewController: UITableViewController {

    // MARK: Properties
    var films = [Film]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       // load sample data
        loadSampleFilms()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return films.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "FilmTableViewCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? FilmTableViewCell else {
            fatalError("The dequeued cell is not an instance of FilmTableViewCell")
        }
        
        // fetch the appropriate cell for the data source layout
        let film = films[indexPath.row]

        cell.nameLabel.text = film.name
        cell.photoImageView.image = film.photo
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Private Methods
    
    private func loadSampleFilms() {
        let photo1 = UIImage(named: "fomapan100")
        let photo2 = UIImage(named: "kodak-portra160")
        let photo3 = UIImage(named: "ilford-hp5")
     
        guard let film1 = Film(name: "Fomapan 100", photo: photo1) else {
            fatalError("Unable to instantiate film1")
        }
        
        guard let film2 = Film(name: "Kodak Portra 160", photo: photo2) else {
            fatalError("Unable to instantiate film2")
        }
        
        guard let film3 = Film(name: "Ilford HP5", photo: photo3) else {
            fatalError("Unable to instantiate film3")
        }
        
        films += [film1, film2, film3]
        
    }
    

}
