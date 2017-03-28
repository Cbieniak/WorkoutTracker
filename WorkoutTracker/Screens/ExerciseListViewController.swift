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
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(createDenomFinished), name: NSNotification.Name(rawValue: "denominationCreated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(createExerciseFinished), name: NSNotification.Name(rawValue: "exerciseCreated"), object: nil)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    func clearAddedExercise() {
        //todo clear unmade exercises
        self.removeChildVC()
    }
    
    func createDenomFinished() {
        self.removeChildVC()
    }
    
    func createExerciseFinished() {
        self.collectionView.reloadData()
        self.removeChildVC()
    }
    
    func addNewExercise() {
    
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 1.0
            self.backgroundView.alpha = 1.0
            self.navigationItem.rightBarButtonItem = self.doneBarButtonItem
        }
        
    }
    
    func removeChildVC() {
        self.collectionView.reloadData()
        self.navigationItem.rightBarButtonItem = self.addBarButtonItem
        UIView.animate(withDuration: 0.3) {
            self.containerView.alpha = 0.0
            self.backgroundView.alpha = 0.0
        }
        
    }

}

extension ExerciseListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = Datamodel.allExercises().count
        
        return count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ExerciseCollectionViewCell", for: indexPath) as! ExerciseCollectionViewCell
        
        
        let exercise = Datamodel.allExercises()[indexPath.row]
        cell.titleLabel.text = exercise.name
        
        let allSessions = (exercise.sessions.allObjects as! [Session]).sorted(by: { $0.date!.compare($1.date! as Date) == .orderedDescending })
        //how to sort
        //exercise -> session
        //session has amounts
        //exercise has denominations
        let denom: Denomination = exercise.denominations.firstObject as! Denomination
        
        let sortedSessions = allSessions.sorted {
            $0.valueForDeonomination(denom: denom) > $1.valueForDeonomination(denom: denom)
        }
        
        if let mostRecentSession = allSessions.first {
            cell.latestValueLabel.text = "\(mostRecentSession.valueForDeonomination(denom: denom))"
            cell.latestDateLabel.text = self.formatter.string(from: mostRecentSession.date as! Date)
        }
    
        if let bestSession = sortedSessions.first {
            cell.topValueLabel.text = "\(bestSession.valueForDeonomination(denom: denom))"
            cell.topDateLabel.text = self.formatter.string(from: bestSession.date as! Date)
        }
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize  {
        return CGSize(width: self.collectionView.frame.width, height: 132)
    }
    
}
