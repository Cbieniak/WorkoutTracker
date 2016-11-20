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
    
    var context: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = Datamodel.sharedInstance.container.viewContext
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "ExerciseCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ExerciseCollectionViewCell")
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewExercise))

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
    }
    
    func addNewExercise() {
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        
        self.navigationController?.pushViewController(sb.instantiateViewController(withIdentifier: "ExerciseDetailViewController"), animated: true)
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
