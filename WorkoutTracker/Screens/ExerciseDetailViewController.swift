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
        exercise = Exercise(context: context)
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func saveTouchedUpInside(_ sender: AnyObject) {
        exercise.name = nameTextField.text
        if let timeText = timeTextField.text, !timeText.isEmpty {
            exercise.time = NSNumber(value:Int(timeText)!)
        }
        if let distanceText = distanceTextField.text, !distanceText.isEmpty {
            exercise.distance =  NSNumber(value:Int(distanceText)!)
        }
        if let weightText = weightTextField.text, !weightText.isEmpty {
            exercise.weight = NSNumber(value:Int(weightText)!)
        }
        if let repsText = repsTextField.text, !repsText.isEmpty {
            exercise.reps = NSNumber(value:Int(repsText)!)
        }
       
        do {
            try self.context.save()
        } catch {
            print("error\(error)")
        }
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }

}

