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
        session.amounts = NSSet()
        
        exercise.sessions.adding(session)
        session.exercise = exercise
        
        for i in 0...self.exercise.denominations.count - 1 {
            let denom = self.exercise.denominations.array[i] as! Denomination
            let newAmount = Amount(context: context)
            newAmount.denomination = denom
            newAmount.amountValue = Double((self.attributeTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! AttributeCell).textField.text!)!
            var newSessionAmounts = session.amounts!.allObjects
            newSessionAmounts.append(newAmount)
            session.amounts = NSSet(array: newSessionAmounts)
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
 
        return self.exercise.denominations.count
   
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AttributeCell", for: indexPath) as! AttributeCell
        cell.textField.text = nil
        cell.textField.placeholder = (exercise.denominations.array[indexPath.row] as! Denomination).name
        return cell
     
    }
}

class AttributeCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
}

