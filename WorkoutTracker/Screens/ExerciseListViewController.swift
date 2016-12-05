//
//  ExerciseListViewController.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 16/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit
import CoreData

class ExerciseListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    var createExerciseViewController: CreateExerciseViewController!
    var context: NSManagedObjectContext!
    
    var addBarButtonItem: UIBarButtonItem!
    
    var doneBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var backgroundView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        context = Datamodel.sharedInstance.container.viewContext
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ExerciseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExerciseCollectionViewCell")
        
        addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewExercise))
        
        doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(clearAddedExercise))
        
        self.navigationItem.rightBarButtonItem = addBarButtonItem

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    func clearAddedExercise() {
        //todo clear unmade exercises
        removeChildVC()
    }
    
    func addNewExercise() {
    
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1.0
            self.backgroundView.alpha = 1.0
            self.navigationItem.rightBarButtonItem = self.doneBarButtonItem
        }
        createExerciseViewController.exerciseAdded = { _ in
            self.removeChildVC()
        }
        
    }
    
    func removeChildVC() {
        self.collectionView.reloadData()
        self.navigationItem.rightBarButtonItem = self.addBarButtonItem
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 0.0
            self.backgroundView.alpha = 0.0
        }
        createExerciseViewController.reset()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "childVC" {
            createExerciseViewController = segue.destination as! CreateExerciseViewController
        }
    }

}

extension ExerciseListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Datamodel.allExercises().count
        
        return count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCollectionViewCell", for: indexPath) as! ExerciseCollectionViewCell
        
        
        
        cell.titleLabel.text = Datamodel.allExercises()[indexPath.row].name
        
        return cell
        
    }

    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        
        let edc = sb.instantiateViewController(withIdentifier: "ExerciseDetailViewController") as! ExerciseDetailViewController
        
        edc.exercise = Datamodel.allExercises()[indexPath.row]
        
        self.navigationController?.pushViewController(edc, animated: true)
        
       
    }
    
}
