//
//  EditViewController.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 28.09.2021.
//

import UIKit
import CoreData

class EditViewController: UIViewController {
    
    var currentNote: Note?
    let storageManager = StorageManager()
    let notesVC = NotesViewController()

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       setupEditScreen()
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
    }
    
    @IBAction func saveText(_ sender: UIBarButtonItem) {
        
        if let newNote = textView.text{
            if currentNote != nil {
                currentNote?.text = newNote
                let context = storageManager.getContext()
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else {
                storageManager.saveNote(withText: newNote)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupEditScreen() {
        if currentNote != nil {
            textView.text = currentNote?.text
            self.navigationItem.title = "Edit note"
        }
    }
}
