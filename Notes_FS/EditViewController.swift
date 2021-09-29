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
    var isBold = false
    var isItalic = false
    
    var fontNames = ["AmericanTypewriter",
                     "AppleSDGothicNeo-Regular",
                     "ChalkboardSE-Regular",
                     "Cochin",
                     "Farah",
                     "Georgia",
                     "Noteworthy-Light",
                     "Optima-Regular"]
    
    var selectedFontName: String?

    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var stepperButton: UIStepper!
    @IBOutlet weak var fontNameField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupEditScreen()
        choiceFont()
        
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        //отслеживаем появление и скрытие клавы
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateTextView(notification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        textView.layer.cornerRadius = 10
        
        stepperButton.value = 22
        stepperButton.minimumValue = 15
        stepperButton.maximumValue = 30
        stepperButton.tintColor = .white
        stepperButton.backgroundColor = .gray
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true) //скроем клаву при тапе вне поля
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        guard let font = textView.font?.fontName else { return }
        let fontSize = CGFloat(sender.value)
        textView.font = UIFont(name: font, size: fontSize)
        let context = storageManager.getContext()
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
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
    
    @IBAction func boldText(_ sender: UIButton) {
        
        isBold = !isBold
        
        if isBold {
            guard let fontSize = textView.font?.pointSize else { return }
            self.textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        } else {
            guard let fontSize = textView.font?.pointSize else { return }
            self.textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)
        }
        
    }
    
    @IBAction func italicText(_ sender: UIButton) {
        
        isItalic = !isItalic
        
        if isItalic {
            guard let fontSize = textView.font?.pointSize else { return }
            self.textView.font = UIFont(name: "Georgia-Italic", size: fontSize)
        } else {
            guard let fontSize = textView.font?.pointSize else { return }
            self.textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)
        }
    }
    
    
    
    //поднимаем текст над клавой
    @objc private func updateTextView(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else { return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height - 20, right: 0)
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    private func setupEditScreen() {
        if currentNote != nil {
            textView.text = currentNote?.text
            self.navigationItem.title = "Edit note"
        }
    }
}
