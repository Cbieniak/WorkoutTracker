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

    var sessionVC: SessionListViewController!
    
    var dictionary: [UIButton : String]!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var containerViewHeightConstraint: NSLayoutConstraint!
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

        self.attributeTableView.dataSource = self
        self.attributeTableView.delegate = self
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "SessionList" {
            if let vc = segue.destination as? SessionListViewController {
                vc.exercise = self.exercise
                sessionVC = vc
                sessionVC.bestOrMostRecentTouched = {
                    let currentConstant = self.containerViewHeightConstraint.constant
                    self.containerViewHeightConstraint.constant = currentConstant == 100 ? 400 : 100
                    
                    UIView.animate(withDuration: 0.3) {
                       self.view.layoutIfNeeded()
                    }
                    
                }
            }
        }
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
            self.attributeTableView.reloadData()
            self.sessionVC.reload()
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
                cell.textField.text = nil
                cell.textField.placeholder = exercise.trackedAttributes[indexPath.row] as? String
                return cell
            default:
                break
            
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TEST", for: indexPath)
        let sessions = self.exercise.sessions.allObjects as! [Session]
    
        let session = sessions.sorted(by: { $0.date!.compare($1.date! as Date) == .orderedDescending })[indexPath.row]
        
        //DateFormatter
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        cell.backgroundColor = .clear
        let dateStr = formatter.string(from: session.date as! Date)
        let sessionInfo: String =  self.exercise.trackedAttributes.reduce("", { $0 + " " + String(describing: (session.value(forKey: $1 as! String)) ?? "") + " " + Session.trackedAttributeSuffix(attr: $1 as! String) })
        cell.textLabel?.text = sessionInfo + " - " + dateStr
        return cell
    }
}

class AttributeCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
}

