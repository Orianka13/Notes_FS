//
//  EditViewController.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 28.09.2021.
//

import UIKit

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
            notesVC.notes.insert(newNote, at: 0)
            print(notesVC.notes)
        }
        notesVC.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
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
