//
//  AddSessionInterfaceController.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 6/11/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit
import WatchKit
import WatchConnectivity


class AddSessionInterfaceController: WKInterfaceController, WKCrownDelegate {
    
    var exercise: TransferrableExercise!
    var denominations: [TransferrableDenomination] = []
    var amounts: [TransferrableAmount] = []
    var session: Session!
    
    var currentlyTrackedAttribute: TransferrableDenomination?
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var picker: WKInterfacePicker!
    
    @IBOutlet var valueButton: WKInterfaceButton!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        exercise = context as? TransferrableExercise
        
        WCSession.default().sendMessage(["lastSession" : exercise.primaryKey], replyHandler: { result in
        
            
            if let denomDictionary = result["denominations"] as? [[String: Any]] {
                self.denominations = denomDictionary.flatMap { TransferrableDenomination(ascending: $0["ascending"] as! Bool, incrementWholeNumber: $0["incrementWholeNumber"] as! Bool, name: $0["name"] as! String, suffix: $0["suffix"] as! String? )}
            }
            
            if let amountsDictionary = result["amounts"] as? [[String: Any]] {
                self.amounts = amountsDictionary.flatMap( { TransferrableAmount(amount: $0["amount"] as! Double, denominationName: $0["denominationName"] as! String) })
            
            }
            self.setup()
        }) { (error) in
            print(error)
        }
        
        crownSequencer.delegate = self
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
        

        self.titleLabel.setText(exercise.name)
        
        //denomination first
        //let amounts = session.amounts?.allObjects as! [TransferrableAmount]
       
    }
    
    func setup() {
        let currentDenom = denominations.first
        if let amount = amounts.first(where: {
            $0.denominationName == currentDenom?.name
        }) {
            
            self.currentlyTrackedAttribute = self.denominations.first(where: {$0.name == amount.denominationName})
            self.valueButton.setTitle("\(amount.amount)")
        }
        
        self.picker.setItems(denominations.map {
            let picker =  WKPickerItem()
            picker.title = $0.name
            return picker
        })
    }
    
    override func willDisappear() {
        super.willDisappear()
        
        
    }
    
    public func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        //create an amount
        //get value
        //increment value
        //save it
        
        if let amount = amounts.first(where: { $0.denominationName == self.currentlyTrackedAttribute?.name } ) {
            var value = amount.amount
            
            if let denom = self.currentlyTrackedAttribute,  denom.incrementWholeNumber {
                value = value + (rotationalDelta > 0 ? 1 : -1)
                let newAmount = TransferrableAmount(amount: value, denominationName: amount.denominationName)
                self.valueButton.setTitle("\(Int(newAmount.amount))")
                self.amounts = self.amounts.filter({ $0.denominationName != self.currentlyTrackedAttribute?.name }) + [newAmount]
                
            } else {
                value = value + (rotationalDelta > 0 ? 0.5 : -0.5)
                let newAmount = TransferrableAmount(amount: value, denominationName: amount.denominationName)
                self.valueButton.setTitle("\(newAmount.amount)")
                self.amounts = self.amounts.filter({ $0.denominationName != self.currentlyTrackedAttribute?.name }) + [newAmount]
            }
            
            
            
            
            
        }

    }
    
    
    
    // called when the crown becomes idle
    public func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        
    }
    
    
    
    @IBAction func pickerAction(_ value: Int) {
        self.currentlyTrackedAttribute = self.denominations[value]
        
        if let amount = amounts.filter( { $0.denominationName == self.currentlyTrackedAttribute?.name } ).first {
            self.valueButton.setTitle("\(amount.amount)")
        } else {
            self.valueButton.setTitle("")
        }
    }
    
    override func pickerDidFocus(_ picker: WKInterfacePicker) {
        super.pickerDidFocus(picker)
    }
    
    override func pickerDidResignFocus(_ picker: WKInterfacePicker) {
        super.pickerDidResignFocus(picker)
        crownSequencer.focus()
    }


    @IBAction func valueButtonTouchedUpInside() {
        self.picker.resignFocus()
    }

    @IBAction func saveTouchedUpInside() {
        //save session.
        var sessionDict:[NSString: Any] = [:]
            
        var amountDict:[NSString: Any] = [:]
        for amount in amounts  {
            amountDict.updateValue(NSNumber(value: amount.amount), forKey: amount.denominationName as NSString)
        }
        
        sessionDict.updateValue(amountDict, forKey: "amounts")
        
        sessionDict.updateValue(NSNumber(value:Date().timeIntervalSince1970), forKey: "date")
        sessionDict.updateValue(exercise.primaryKey, forKey: "exercisePK")
        
        WCSession.default().sendMessage(["session": sessionDict], replyHandler: nil, errorHandler: { (error) -> Void in
            print(error)
        })
        
        self.pop()
    }
}
