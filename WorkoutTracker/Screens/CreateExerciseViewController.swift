//
//  CreateExerciseViewController.swift
//  WorkoutTracker
//
//  Created by Christian Bieniak on 20/11/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit
import CoreData

enum updateStatus {
    case added
    case removed
}

class CreateExerciseViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var repsButton: UIButton!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var timeButton: UIButton!
    
    var exercise: Exercise!
    
    var context: NSManagedObjectContext!
    
    var exerciseAdded: ((Exercise) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = Datamodel.sharedInstance.container.viewContext
        
        exercise = Exercise(context: context)
        exercise.primaryKey = UUID().uuidString
        exercise.sessions = NSSet()
        exercise.trackedAttributes = NSArray()
        
        self.view.layer.cornerRadius = 10
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = UIColor.black.cgColor
        
        buttonStyling()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func repsButtonTouchedUpInside(_ sender: UIButton) {
        let status = updateTrackStatus(attribute: "reps")
        toggleButtonStyle(button: sender, state: status == .added)
    }

    @IBAction func weightButtonTouchedUpInside(_ sender: UIButton) {
        let status = updateTrackStatus(attribute: "weight")
        toggleButtonStyle(button: sender, state: status == .added)
    }
    
    @IBAction func distanceButtonTouchedUpInside(_ sender: UIButton) {
        let status = updateTrackStatus(attribute: "distance")
        toggleButtonStyle(button: sender, state: status == .added)
    }
    
    @IBAction func timeButtonTouchedUpInside(_ sender: UIButton) {
        let status = updateTrackStatus(attribute: "time")
        toggleButtonStyle(button: sender, state: status == .added)
    }


    @IBAction func saveButtonTouchedUpInside(_ sender: UIButton) {
        //create exercise
        //save things
        
        exercise.name = nameTextField.text
        do {
            try self.context.save()
            exerciseAdded?(exercise)
        } catch {
            print("error\(error)")
        }
    }
    
    func toggleButtonStyle(button: UIButton, state: Bool) {
        if state {
            button.backgroundColor = .black
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .clear
            button.setTitleColor(.black, for: .normal)
        }
    }
    
    func buttonStyling() {
        for button in [repsButton, weightButton, distanceButton, timeButton] {
            button!.layer.cornerRadius = 10
            button!.layer.borderWidth = 1
            button!.layer.borderColor = UIColor.black.cgColor
            toggleButtonStyle(button: button!, state: false)
        }
    }
    
    func updateTrackStatus(attribute: String) -> updateStatus {
        let mutableArray: NSMutableArray = self.exercise.trackedAttributes.mutableCopy() as! NSMutableArray
        if self.exercise.trackedAttributes.contains(attribute) {
            mutableArray.remove(attribute)
            self.exercise.trackedAttributes = mutableArray
            return .removed
        } else {
            mutableArray.add(attribute)
            self.exercise.trackedAttributes = mutableArray
            return .added
        }
    }

}
