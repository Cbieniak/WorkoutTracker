//
//  CreateDenominationViewController.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 28/12/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit

class CreateDenominationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var suffixTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var wholeNumberSwitch: UISwitch!
    @IBOutlet weak var ascendingSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameTextField.delegate = self
        self.suffixTextField.delegate = self
        
    }

    
    @IBAction func saveTouchedUpInside(_ sender: Any) {
        //create denomination
        let context = Datamodel.sharedInstance.container.viewContext
    
        let denomination = Denomination(context: context)
        
        denomination.name = self.nameTextField.text ?? ""
        denomination.suffix = self.suffixTextField.text
        denomination.ascending = self.ascendingSwitch.isOn
        
        do {
            try context.save()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "denominationCreated"), object: nil)
            _ = self.navigationController?.popToRootViewController(animated: false)
        } catch {
            print("error\(error)")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case self.nameTextField:
                self.nameTextField.resignFirstResponder()
            break
            case self.suffixTextField:
                self.suffixTextField.resignFirstResponder()
            break
            default: break
            
        }
        return true
    }

}
