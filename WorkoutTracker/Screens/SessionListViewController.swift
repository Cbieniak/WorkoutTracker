//
//  SessionListViewController.swift
//  WorkoutTracker
//
//  Created by ChristianBieniak on 25/10/16.
//  Copyright © 2016 Bieniapps. All rights reserved.
//

import UIKit
import CoreData

class SessionListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var context: NSManagedObjectContext!
    
    var bestOrMostRecentTouched: (() -> ())?
    
    var exercise: Exercise!
    
    @IBOutlet weak var bestSessionLabel: UILabel!
    @IBOutlet weak var recentSessionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        context = Datamodel.sharedInstance.container.viewContext
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "SessionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SessionCollectionViewCell")

        
    }
    @IBAction func headerTouchedUpInside(_ sender: Any) {
        self.bestOrMostRecentTouched?()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.reloadData()
        self.updateHeader()
    }
    
    func reload() {
        self.collectionView.reloadData()
        self.updateHeader()
    }
    
    func updateHeader() {
        let allSessions = (self.exercise.sessions.allObjects as! [Session]).sorted(by: { $0.date!.compare($1.date! as Date) == .orderedDescending })
        let sortedSessions = allSessions.sorted { $0.weight > $1.weight }
        let bestSession = sortedSessions.first
        let mostRecentSession = allSessions.first
        
        self.recentSessionLabel.text = mostRecentSession?.descriptiveString()
        self.bestSessionLabel.text = bestSession?.descriptiveString()
        
    }
}

extension SessionListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = exercise.sessions.count
        
        return count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SessionCollectionViewCell", for: indexPath) as! SessionCollectionViewCell
        let sessions = exercise.sessions.allObjects as! [Session]
        let session = sessions.sorted(by: { $0.date!.compare($1.date! as Date) == .orderedDescending })[indexPath.row]
        
        cell.backgroundColor = .clear

        cell.titleLabel?.text = session.descriptiveString()
        
        return cell
        
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}
