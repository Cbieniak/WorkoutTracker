//
//  AddSessionInterfaceController.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 6/11/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit
import WatchKit

class AddSessionInterfaceController: WKInterfaceController, WKCrownDelegate {
    
    var exercise: Exercise!
    var session: Session!
    
    var currentlyTrackedAttribute: String?
    
    @IBOutlet var titleLabel: WKInterfaceLabel!
    @IBOutlet var picker: WKInterfacePicker!
    
    @IBOutlet var valueButton: WKInterfaceButton!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        exercise = context as? Exercise
        let manangedObjectcontext = WatchDataModel.sharedInstance.container!.viewContext
        session = Session(context: manangedObjectcontext)
        session.date = NSDate()
        if let lastSession = exercise.sessions.allObjects.last as? Session {
            session.reps = lastSession.reps
            session.weight = lastSession.weight
            session.time = lastSession.time
            session.speed = lastSession.speed
            session.distance = lastSession.distance
            session.exercise = exercise
            exercise.sessions.adding(session)
        }
        
        crownSequencer.delegate = self
        
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        crownSequencer.focus()
        

        self.titleLabel.setText(exercise.name)
        if let tracked =  exercise.trackedAttributes.firstObject as? String {
            
            self.currentlyTrackedAttribute = tracked
            
            self.valueButton.setTitle("\(session.value(forKey: tracked)!)")
            
            self.picker.setItems(exercise.trackedAttributes.map {
                let picker =  WKPickerItem()
                picker.title = ($0 as! String)
                return picker
            })
        }
    }
    
    override func willDisappear() {
        super.willDisappear()
        //save session.
        //record it in the changelog.
        do {
            try WatchDataModel.sharedInstance.container?.viewContext.save()
        } catch {
            print(error)
        }
        
    }
    
    public func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        
        var value: Double = session.value(forKey: currentlyTrackedAttribute!) as! Double
        
        value = value + (rotationalDelta > 0 ? 1 : -1)
        
        session.setValue(value, forKey: currentlyTrackedAttribute!)
        
        self.valueButton.setTitle("\(value)")

    }
    
    
    
    // called when the crown becomes idle
    public func crownDidBecomeIdle(_ crownSequencer: WKCrownSequencer?) {
        
    }
    
    
    
    @IBAction func pickerAction(_ value: Int) {
        self.currentlyTrackedAttribute = exercise.trackedAttributes[value] as? String
        self.valueButton.setTitle("\(session.value(forKey: self.currentlyTrackedAttribute!)!)")
        
    }
    
    override func pickerDidFocus(_ picker: WKInterfacePicker) {
        super.pickerDidFocus(picker)
        print("test")
    }
    
    override func pickerDidResignFocus(_ picker: WKInterfacePicker) {
        super.pickerDidResignFocus(picker)
        crownSequencer.focus()
        print("resigned")
    }


    @IBAction func valueButtonTouchedUpInside() {
        self.picker.resignFocus()

    }

}
