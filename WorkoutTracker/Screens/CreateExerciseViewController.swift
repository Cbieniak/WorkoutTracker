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
    
    let defaultHeight: CGFloat = 40
    
    @IBOutlet weak var selectedSectionHeightConstraint: NSLayoutConstraint!
  
    @IBOutlet weak var selectedAttributesCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var exercise: Exercise!
    
    var context: NSManagedObjectContext!
    
    var selectedDenominations: Array<Denomination> = []
    var unselectedDenominations: Array<Denomination> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        context = Datamodel.sharedInstance.container.viewContext
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        self.collectionView.addGestureRecognizer(longPressGesture)
        let longPressAttributesGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongGesture(gesture:)))
        self.selectedAttributesCollectionView.addGestureRecognizer(longPressAttributesGesture)
        
        exercise = Exercise(context: context)
        exercise.primaryKey = UUID().uuidString
        exercise.sessions = NSSet()
        exercise.trackedAttributes = NSArray()
        
        nameTextField.delegate = self
        
        self.unselectedDenominations = Datamodel.allDenominations()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "SessionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        
        selectedAttributesCollectionView.dataSource = self
        selectedAttributesCollectionView.delegate = self
        selectedAttributesCollectionView.register(UINib(nibName: "AttributeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AttributeCollectionViewCell")
    }
    
    func reset() {
        exercise = Exercise(context: context)
        exercise.primaryKey = UUID().uuidString
        exercise.sessions = NSSet()
        exercise.trackedAttributes = NSArray()
        self.nameTextField.text = ""
    }

    @IBAction func cancelButtonTouchedUpInside(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTouchedUpInside(_ sender: UIButton) {
        //create exercise
        //save things
        
        exercise.name = nameTextField.text
        exercise.denominations = NSOrderedSet(array: self.selectedDenominations)
        do {
            try self.context.save()
            self.dismiss(animated: true, completion: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "exerciseCreated"), object: nil)
            _ = self.navigationController?.popToRootViewController(animated: false)
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


extension CreateExerciseViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch collectionView {
        case self.collectionView:
            return self.unselectedDenominations.count
        case self.selectedAttributesCollectionView:
            return self.selectedDenominations.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch collectionView {
        case self.collectionView:
            if section == 1 {
                return CGSize(width: self.collectionView.frame.width, height: 50)
            }
            break
        case self.selectedAttributesCollectionView:
            break
        default:
            break
        }
       
        
        return CGSize(width: 0, height: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "headerView", for: indexPath)
        
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var collection: [Denomination] = []
        switch collectionView {
        case self.collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! SessionCollectionViewCell
            collection = self.unselectedDenominations
            cell.titleLabel.text = collection[indexPath.row].name
            return cell
        case self.selectedAttributesCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AttributeCollectionViewCell", for: indexPath) as! AttributeCollectionViewCell
            collection = self.selectedDenominations
            cell.setup(collection[indexPath.row])
            return cell
        default:
            break
        }
    
       
        return collectionView.dequeueReusableCell(withReuseIdentifier: "invalid", for: indexPath)
    }
    
    func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        let selectedCollectionView = gesture.view as! UICollectionView
        switch(gesture.state) {
            
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = selectedCollectionView.indexPathForItem(at: gesture.location(in: selectedCollectionView)) else {
                break
            }
            selectedCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            selectedCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            selectedCollectionView.endInteractiveMovement()
        default:
            selectedCollectionView.cancelInteractiveMovement()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        switch collectionView {
        case self.collectionView:
            let item1 = self.unselectedDenominations[sourceIndexPath.row]
            self.unselectedDenominations.remove(at: sourceIndexPath.row)
            self.unselectedDenominations.insert(item1, at: destinationIndexPath.row)
            break
        case self.selectedAttributesCollectionView:
            let item1 = self.selectedDenominations[sourceIndexPath.row]
            self.selectedDenominations.remove(at: sourceIndexPath.row)
            self.selectedDenominations.insert(item1, at: destinationIndexPath.row)
            break
        default:break
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch collectionView {
        case self.collectionView:
            return CGSize(width: 100, height: 50)
        case self.selectedAttributesCollectionView:
            return CGSize(width: self.selectedAttributesCollectionView.frame.width, height: 50)
        default:
            return CGSize.zero
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case self.collectionView:
            let item = self.unselectedDenominations[indexPath.row]
            self.unselectedDenominations.remove(at: indexPath.row)
            self.selectedDenominations.append(item)

            break
        case self.selectedAttributesCollectionView:
            let item = self.selectedDenominations[indexPath.row]
            self.selectedDenominations.remove(at: indexPath.row)
            self.unselectedDenominations.append(item)
            break
        default:
            break
        }
        
        self.collectionView.reloadData()
        self.selectedAttributesCollectionView.reloadData()
        self.selectedSectionHeightConstraint.constant = self.defaultHeight + CGFloat(80 * self.selectedDenominations.count)
        self.view.layoutIfNeeded()
    }
}

class CreateExerciseCollectionViewHeader: UICollectionReusableView {
    
    
}
