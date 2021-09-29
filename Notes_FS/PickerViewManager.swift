//
//  PickerViewManager.swift
//  Notes_FS
//
//  Created by Олеся Егорова on 29.09.2021.
//

import Foundation
import UIKit

extension EditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { // количество барабанов
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {// количество элементов в барабане
        return fontNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { // название строк в барабане
        return fontNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) { // работаем с выбранным элементом
        selectedFontName = fontNames[row]
        guard let fontSize = textView.font?.pointSize else { return }
        self.fontNameField.text = selectedFontName
        self.textView.font = UIFont(name: selectedFontName ?? "AppleSDGothicNeo-Regular", size: fontSize)
        
    }
    
    func choiceFont() {
        let elementPicker = UIPickerView()
        elementPicker.delegate = self
        self.fontNameField.inputView = elementPicker
    }
}
