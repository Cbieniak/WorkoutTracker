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
    
    @IBOutlet weak var attributeTableView: UITableView!
    @IBOutlet weak var nameTextField: UITextField!

    @IBOutlet weak var tableView: UITableView!
    
    var dictionary: [UIButton : String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = Datamodel.sharedInstance.container.viewContext
        if (exercise == nil) {
            exercise = Exercise(context: context)
            exercise.primaryKey = UUID().uuidString
            exercise.sessions = NSSet()
            exercise.trackedAttributes = NSArray()
        } else {
            exercise = context.object(with: exercise.objectID) as! Exercise
            self.nameTextField.text = exercise.name
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.attributeTableView.dataSource = self
        self.attributeTableView.delegate = self
        
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TEST")
        
    }

    
    @IBAction func saveTouchedUpInside(_ sender: AnyObject) {
        exercise.name = nameTextField.text
        let session = Session(context: context)
        
        session.date = NSDate()
        
        
        exercise.sessions.adding(session)
        session.exercise = exercise
        for i in 0...self.exercise.trackedAttributes.count - 1 {
            let attribute = self.exercise.trackedAttributes[i]
            let val = self.attributeTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AttributeCell
            
            session.setValue(Double(val.textField.text!), forKey: attribute as! String)
        }
        
        do {
            try self.context.save()
            self.tableView.reloadData()
        } catch {
            print("error\(error)")
        }
        
    }
    
}

extension ExerciseDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(tableView) {
        case attributeTableView:
            return self.exercise.trackedAttributes.count
        default:
            return self.exercise.sessions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(tableView) {
            case attributeTableView:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell", for: indexPath) as! AttributeCell
            
            cell.textField.placeholder = exercise.trackedAttributes[indexPath.row] as? String
            return cell
        default:
            break
            
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEST", for: indexPath)
        let session = self.exercise.sessions.allObjects[indexPath.row] as! Session
        cell.textLabel?.text =  self.exercise.trackedAttributes.reduce("", { $0! + " " + String(describing: (session.value(forKey: $1 as! String))!) + " " + Session.trackedAttributeSuffix(attr: $1 as! String) })
        return cell
    }
}

class AttributeCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
}

