//
//  NotesViewController.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 28.09.2021.
//

import UIKit
import CoreData

class NotesViewController: UITableViewController {
    
    var notes: [Note] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "text", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            try notes = context.fetch(fetchRequest)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        tableView.reloadData()
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        //deleteNote()

    }
    
    private func deleteNote(note: Note) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //let fetchRequest: NSFetchRequest<Note> = Note.fetchRequest()
        
        context.delete(note)
        
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }


    @IBAction func addNote(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddNote", sender: nil)
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let note = notes[indexPath.row]
        cell.textLabel?.text = note.text // только первую строку из заметки

        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = notes[indexPath.row]
            deleteNote(note: note)
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)

        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
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

}
