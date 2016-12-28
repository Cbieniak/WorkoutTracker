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

class CreateExerciseViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource {

    @IBOutlet weak var nameTextField: UITextField!
    
    let orange =  UIColor(colorLiteralRed: 44.0/255.0, green: 62.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    
  
    @IBOutlet weak var collectionView: UICollectionView!
    
    var exercise: Exercise!
    
    var context: NSManagedObjectContext!
    
    var selectedDenominations: Array<Denomination> = []
    var unselectedDenominations: Array<Denomination> = []
    
    var exerciseAdded: ((Exercise) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = Datamodel.sharedInstance.container.viewContext
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
        
        exercise = Exercise(context: context)
        exercise.primaryKey = UUID().uuidString
        exercise.sessions = NSSet()
        exercise.trackedAttributes = NSArray()
        
        self.view.layer.cornerRadius = 10
        self.view.layer.borderWidth = 1
        self.view.layer.borderColor = orange.cgColor
        nameTextField.layer.cornerRadius = 10
        nameTextField.layer.borderWidth = 1
        nameTextField.textColor = orange
        nameTextField.layer.borderColor = orange.cgColor
        
        nameTextField.delegate = self
        
        self.unselectedDenominations = Datamodel.allDenominations()
        
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "SessionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
    }
    
    func reset() {
        exercise = Exercise(context: context)
        exercise.primaryKey = UUID().uuidString
        exercise.sessions = NSSet()
        exercise.trackedAttributes = NSArray()
        self.nameTextField.text = ""
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
            button.backgroundColor = orange
            button.setTitleColor(.white, for: .normal)
        } else {
            button.backgroundColor = .clear
            
            button.setTitleColor(orange, for: .normal)
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
    
    //MARK: Delegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.nameTextField.resignFirstResponder()
        return true
    }

}


extension CreateExerciseViewController {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.unselectedDenominations.count
        } else {
            return self.selectedDenominations.count
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SessionCollectionViewCell
        
        cell.titleLabel.text = self.unselectedDenominations[indexPath.row].name
        return cell
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.collectionView.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
                break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let item1 = self.unselectedDenominations[sourceIndexPath.row]
        self.unselectedDenominations.remove(at: sourceIndexPath.row)
        self.unselectedDenominations.insert(item1, at: destinationIndexPath.row)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       return 2
    }
}
