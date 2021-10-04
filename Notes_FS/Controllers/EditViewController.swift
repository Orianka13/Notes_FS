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
    
    var fontNames = ["AppleSDGothicNeo-Regular",
                     "AmericanTypewriter",
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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    
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
        
        stepperButton.value = 18
        stepperButton.minimumValue = 10
        stepperButton.maximumValue = 25
        stepperButton.backgroundColor = UIColor(hexValue: "#F9F9FF", alpha: 0.3)
        stepperButton.layer.cornerRadius = 5
        
        view.backgroundColor = primaryColor
        textView.backgroundColor = primaryColor
        textView.textColor = .white
        fontNameField.backgroundColor = UIColor(hexValue: "#F9F9FF", alpha: 0.3)
        fontNameField.textColor = .white
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true) //скроем клаву при тапе вне поля
    }
    
    @IBAction func stepper(_ sender: UIStepper) {
        guard let font = textView.font?.fontName else {
            print("Error with font name")
            return }
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
            guard let textFont = textView.font?.fontName else {
                print("Error with font name")
                return}
            guard let fontPreSize = textView.font?.pointSize else {
                print("Error with font size")
                return }
            let fontSize = Double(fontPreSize)
            if currentNote != nil {
                currentNote?.text = newNote
                currentNote?.font = textFont
                currentNote?.fontSize = fontSize
                let context = storageManager.getContext()
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            } else {
                storageManager.saveNote(withText: newNote, font: textFont, fontSize: fontSize)
            }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func boldText(_ sender: UIButton) {
        
        isBold = !isBold
        
        if isBold {
            guard let fontSize = textView.font?.pointSize else {
                print("Error with font size")
                return }
            self.textView.font = UIFont(name: "AppleSDGothicNeo-Bold", size: fontSize)
        } else {
            guard let fontSize = textView.font?.pointSize else {
                print("Error with font size")
                return }
            self.textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)
        }
    }
    
    @IBAction func italicText(_ sender: UIButton) {
        
        isItalic = !isItalic
        
        if isItalic {
            guard let fontSize = textView.font?.pointSize else {
                print("Error with font size")
                return }
            self.textView.font = UIFont(name: "Georgia-Italic", size: fontSize)
        } else {
            guard let fontSize = textView.font?.pointSize else {
                print("Error with font size")
                return }
            self.textView.font = UIFont(name: "AppleSDGothicNeo-Regular", size: fontSize)
        }
    }
    
    //поднимаем текст над клавой
    @objc private func updateTextView(notification: Notification) {
        guard
            let userInfo = notification.userInfo as? [String: Any],
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        else {
            print("Error with keyboard frame value")
            return }
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            textView.contentInset = UIEdgeInsets.zero
            bottomConstraint.constant = 41
        } else {
            textView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
            bottomConstraint.constant = keyboardFrame.height + 2
            
            textView.scrollIndicatorInsets = textView.contentInset
        }
        textView.scrollRangeToVisible(textView.selectedRange)
    }
    
    private func setupEditScreen() {
        if currentNote != nil {
            textView.text = currentNote?.text
            guard let fontName = currentNote?.font else {
                print("Error with current font name")
                return }
            guard let fontPreSize = currentNote?.fontSize else {
                print("Error with current font size")
                return }
            let fontSize = CGFloat(fontPreSize)
            textView.font = UIFont(name: fontName, size: fontSize)
            self.navigationItem.title = "Edit note"
        }
    }
}
