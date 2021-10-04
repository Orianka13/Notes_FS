//
//  NotesViewController.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 28.09.2021.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {
    
    let storageManager = StorageManager()
    
    var notes: [Note] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let context = storageManager.getContext()
        
            let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
            do {
                try notes = context.fetch(fetchRequest)
                notes.reverse()
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = primaryColor
        navigationController?.navigationBar.backgroundColor = primaryColor
        
    }
    
    
    @IBAction func addNote(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddNote", sender: nil)
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text
        cell.textLabel?.textColor = .white
        cell.backgroundColor = primaryColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            storageManager.deleteNote(note: note)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditNote" {
            guard let indexPath = tableView.indexPathForSelectedRow else {
                print("Error with indexPath for selected row")
                return }
            let note = notes[indexPath.row]
            let editVC = segue.destination as! EditViewController
            editVC.currentNote = note
        }
    }
}
