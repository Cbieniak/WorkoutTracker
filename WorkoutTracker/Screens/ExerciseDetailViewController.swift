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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = Datamodel().container.viewContext
        if (exercise == nil) {
            exercise = Exercise(context: context)
            exercise.sessions = NSSet()
        } else {
            exercise = context.object(with: exercise.objectID) as! Exercise
            self.nameTextField.text = exercise.name
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TEST")

        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @IBAction func saveTouchedUpInside(_ sender: AnyObject) {
        exercise.name = nameTextField.text
        let session = Session(context: context)
        
        session.date = NSDate()
        
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
        session.exercise = exercise
        do {
            try self.context.save()
            self.tableView.reloadData()
        } catch {
            print("error\(error)")
        }
        
        //_ = self.navigationController?.popViewController(animated: true)
        
    }

}

extension ExerciseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.exercise.sessions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEST", for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }

    
    
    
}

