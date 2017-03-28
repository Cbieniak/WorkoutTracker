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
        self.collectionView.register(UINib(nibName: "TrackedSessionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TrackedSessionCollectionViewCell")

        
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
        //how to sort
        //exercise -> session
        //session has amounts
        //exercise has denominations
        let denom = self.exercise.denominations.firstObject as! Denomination
        
        let sortedSessions = allSessions.sorted {
            $0.valueForDeonomination(denom: denom) > $1.valueForDeonomination(denom: denom)
        }
        let bestSession = sortedSessions.first
        let mostRecentSession = allSessions.first
        
        self.recentSessionLabel.text = mostRecentSession?.descriptiveString()
        self.bestSessionLabel.text = bestSession?.descriptiveString()
        
    }
}

extension SessionListViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = exercise.sessions.count
        
        return count
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrackedSessionCollectionViewCell", for: indexPath) as! TrackedSessionCollectionViewCell
        let sessions = exercise.sessions.allObjects as! [Session]
        let session = sessions.sorted(by: { $0.date!.compare($1.date! as Date) == .orderedDescending })[indexPath.row]

        cell.titleLabel?.text = session.descriptiveString()
        
        let green = UIColor(colorLiteralRed: 126/255, green: 211/255, blue: 33/255, alpha: 1)
        
        let red = UIColor(colorLiteralRed: 168/255, green: 47/255, blue: 57/255, alpha: 1)
        
        let denom = self.exercise.denominations.firstObject as! Denomination
        
        var prev: Session? = nil
        let current: Session = sessions[indexPath.row]
        var next: Session? = nil
        
        if indexPath.row == 0 {
            cell.upperTrackView.alpha = 0
            
        } else {
            prev = sessions[indexPath.row - 1]
        }
        
        if indexPath.row == self.exercise.sessions.count - 1 {
            cell.lowerTrackView.alpha = 0.0
        } else {
            next = sessions[indexPath.row + 1]
        }
        
        if let safePrev = prev {
            let color = safePrev.valueForDeonomination(denom: denom) > current.valueForDeonomination(denom: denom) ? green : red
            cell.upperTrackView.backgroundColor = color
            
        }
        
        if let safeNext = next {
            let color = safeNext.valueForDeonomination(denom: denom) < current.valueForDeonomination(denom: denom) ? green : red
            cell.lowerTrackView.backgroundColor = color
            cell.centerTrackView.backgroundColor = color
            
        }
        
        return cell
        
    }
    
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 100)
    }
    
}
