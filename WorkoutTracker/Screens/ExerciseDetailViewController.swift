//
//  ViewController.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 16/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit
import CoreData

class ExerciseDetailViewController: UIViewController {
    
    var exercise: Exercise!
    
    var context: NSManagedObjectContext!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var repsTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = Datamodel().container.viewContext
        if (exercise == nil) {
            exercise = Exercise(context: context)
            exercise.sessions = NSSet()
        } else {
            self.nameTextField.text = exercise.name
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func saveTouchedUpInside(_ sender: AnyObject) {
        exercise.name = nameTextField.text
        let session = Session(context: context)
        
        if let timeText = timeTextField.text, !timeText.isEmpty {
            session.time = Double(timeText)!
        }
        if let distanceText = distanceTextField.text, !distanceText.isEmpty {
            session.distance =  Double(distanceText)!
        }
        if let weightText = weightTextField.text, !weightText.isEmpty {
            session.weight = Int32(weightText)!
        }
        if let repsText = repsTextField.text, !repsText.isEmpty {
            session.reps = Int32(repsText)!
        }
        exercise.sessions.adding(session)
        do {
            try self.context.save()
        } catch {
            print("error\(error)")
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

}

