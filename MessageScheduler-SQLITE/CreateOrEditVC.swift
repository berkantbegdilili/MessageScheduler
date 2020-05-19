//
//  CreateNewVC.swift
//  MessageScheduler-SQLITE
//
//  Created by Berkant Beğdilili on 18.05.2020.
//  Copyright © 2020 Berkant Beğdilili. All rights reserved.
//

import UIKit
import ContactsUI

class CreateOrEditVC: UIViewController {

    private let contactPicker = CNContactPickerViewController()
    
    @IBOutlet weak var number: UITextField!
    @IBOutlet weak var message: UITextField!
    @IBOutlet weak var date: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    var sch:Scheduler?
    var edit:Bool = false
    
    // Bildirim Degiskenleri
    var year:Int?
    var month:Int?
    var day:Int?
    var hour:Int?
    var minute:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if edit{
            navigationItem.title = "Edit"
            button.setTitle("SAVE", for: .normal)
            
            if let s = sch {
                number.text = "\(s.sch_num!)"
                message.text = s.sch_message
                date.text = s.sch_date
            }
        }else{
            navigationItem.title = "Create New"
            button.setTitle("CREATE NEW", for: .normal)
        }
        
        number.delegate = self
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        date.setInputViewDatePicker(target: self, selector: #selector(tapDone))
        
    }
    

    @IBAction func addContact(_ sender: Any) {
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
    }
    
    
    @IBAction func button(_ sender: Any) {
        if number.text != "" && message.text != "" && date.text != ""{
            
            if edit{
                if let s = sch, let n = number.text, let m = message.text , let d = date.text{
                    
                    DAO().updateScheduler(sch_id: s.sch_id!, sch_num: n, sch_message: m, sch_date: d)
                    
                    dismiss(animated: true)
                    let alert = UIAlertController(title: "SUCCESSFUL", message: nil, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
            }else{
                if let n = number.text, let m = message.text, let d = date.text{
                    
                    DAO().addScheduler(sch_num: n, sch_message: m, sch_date: d)
                    
                    dismiss(animated: true)
                    let alert = UIAlertController(title: "SUCCESSFUL", message: nil, preferredStyle: .alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
  
                }
            }
        } else {
            dismiss(animated: true)
            
            let alert = UIAlertController(title: "UNSUCCESSFUL", message: nil, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        
        // Bildirim Oluşturma
        
        let content = UNMutableNotificationContent()
        content.title = "Message Scheduler"
        content.body = "It's time for send a message to the number \n \(number.text!)"
        content.sound = UNNotificationSound.default
        content.badge = 1
        
        let dateComponents = DateComponents(calendar: .autoupdatingCurrent, timeZone: .autoupdatingCurrent, year: year, month: month, day: day, hour: hour, minute: minute)
        
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: false)
        
        let userId = UUID().uuidString
        
        let request = UNNotificationRequest(identifier: userId, content: content, trigger: trigger)
        
        notificationCenter.add(request){ (error) in
            if let error = error{
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    @objc func tapDone() {
        if let datePicker = self.date.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            dateformatter.dateFormat = "dd.MM.yyyy - HH:mm"
            self.date.text = dateformatter.string(from: datePicker.date)
            
            dateformatter.dateFormat = "dd"
            self.day = Int(dateformatter.string(from: datePicker.date))
            
            dateformatter.dateFormat = "MM"
            self.month = Int(dateformatter.string(from: datePicker.date))
            
            dateformatter.dateFormat = "yyyy"
            self.year = Int(dateformatter.string(from: datePicker.date))
            
            dateformatter.dateFormat = "HH"
            self.hour = Int(dateformatter.string(from: datePicker.date))
            
            dateformatter.dateFormat = "mm"
            self.minute = Int(dateformatter.string(from: datePicker.date))
        }
        self.date.resignFirstResponder()
    }
}

extension CreateOrEditVC: CNContactPickerDelegate{

        func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
            let phoneNumberCount = contact.phoneNumbers.count

            guard phoneNumberCount > 0 else {
                dismiss(animated: true)
                
                let alert = UIAlertController(title: "No number found for contact: \(contact.givenName) \(contact.familyName)", message: nil, preferredStyle: .alert)
                alert.addAction(.init(title: "OKAY", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }

            if phoneNumberCount == 1 {
                setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
            } else {
                dismiss(animated: true)
                
                let alert = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)

                for i in 0...phoneNumberCount-1 {
                    alert.addAction(.init(title: contact.phoneNumbers[i].value.stringValue , style: .default, handler: { alert -> Void in
                        self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                    }))
                }
                
                alert.addAction(.init(title: "Cancel", style: .destructive, handler: nil))
                
                self.present(alert, animated: true, completion: nil)
            }
        }

        func setNumberFromContact(contactNumber: String) {

            var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
            contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
            contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
            contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
            contactNumber = String(contactNumber.suffix(10))
            contactNumber.insert("(", at: contactNumber.startIndex)
            contactNumber.insert(")", at: contactNumber.index(contactNumber.startIndex, offsetBy: 4))
            contactNumber.insert(" ", at: contactNumber.index(contactNumber.startIndex, offsetBy: 5))
            contactNumber.insert(" ", at: contactNumber.index(contactNumber.startIndex, offsetBy: 9))
            
            
            
            guard contactNumber.count >= 10 else {
                dismiss(animated: true)
                
                let alert = UIAlertController(title: "ERROR", message: "Selected contact does not have a valid number.", preferredStyle: .alert)
                alert.addAction(.init(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            number.text = String(contactNumber)
        }

        func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

        }
}


extension UITextField {
    
    func setInputViewDatePicker(target: Any, selector: Selector) {
        
        let screenWidth = UIScreen.main.bounds.width
        let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 216))
        datePicker.datePickerMode = .dateAndTime
        datePicker.minimumDate = Date()
        self.inputView = datePicker
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: screenWidth, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancel = UIBarButtonItem(title: "Cancel", style: .plain, target: nil, action: #selector(tapCancel))
        cancel.tintColor = UIColor.init(displayP3Red: 0.543973, green: 0.127511, blue: 0.10608, alpha: 1)
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: selector)
        toolBar.setItems([cancel, flexible, barButton], animated: false)
        self.inputAccessoryView = toolBar
    }
    
    @objc func tapCancel() {
        self.resignFirstResponder()
    }
    
}

extension CreateOrEditVC:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if number.text!.count == 1 && string != "" {
            number.text!.insert("(", at: number.text!.startIndex)
        }
            
        if number.text!.count == 4 && string != "" {
            number.text!.insert(")", at: number.text!.index(number.text!.startIndex, offsetBy: 4))
        }
                 
        if number.text!.count == 5 && string != "" {
            number.text!.insert(" ", at: number.text!.index(number.text!.startIndex, offsetBy: 5))
        }
                 
        if number.text!.count == 9 && string != "" {
            number.text!.insert(" ", at: number.text!.index(number.text!.startIndex, offsetBy: 9))
        }
        
        
        guard let textFieldText = number.text, let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        
        return count <= 14
    }
    
}

