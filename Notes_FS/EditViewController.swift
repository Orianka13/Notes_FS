//
//  EditViewController.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 28.09.2021.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    let notesVC = NotesViewController()
    
    //var newNote: String = ""

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveText(_ sender: UIBarButtonItem) {
        if let newNote = textView.text{
            self.saveNote(withText: newNote)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func saveNote(withText text: String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Note", in: context) else { return }
        let noteObject = Note(entity: entity, insertInto: context)
        
        noteObject.text = text
        
        do {
            try context.save()
            notesVC.notes.insert(noteObject, at: 0)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
   
  

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
