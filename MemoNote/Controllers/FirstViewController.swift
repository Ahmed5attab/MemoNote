//
//  FirstViewController.swift
//  MemoNote
//
//  Created by Ahmed Khattab on 9/17/19.
//  Copyright © 2019 Ahmed Khattab. All rights reserved.
//

import UIKit
import CoreData

class FirstViewController: UIViewController , UICollectionViewDataSource , UICollectionViewDelegate , UIGestureRecognizerDelegate {
    
    
    var selectFlag = false
    
    //Array of selected cells
    var removeD : [IndexPath] = []
    var dataa = [1]
    var data : NSFetchedResultsController<NSFetchRequestResult>!
    
    @IBOutlet weak var Delete: UIBarButtonItem!
    @IBOutlet weak var notesCollection: UICollectionView!
    @IBOutlet weak var Notesnum: UILabel!

    override func viewWillAppear(_ animated: Bool) {
        
        self.Delete.isEnabled = false
        
        //Rigester The Long Press Gesture Recognizer To the Collection View
        let lpgr:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector (longPressHandle))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        self.notesCollection.addGestureRecognizer(lpgr)
    
        //Load Notes From CoreData
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let moc = appDelegate.dataController.managedObjectContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NoteData")
        request.sortDescriptors = [NSSortDescriptor(key: "creatDate", ascending: true)]
        data = NSFetchedResultsController(fetchRequest: request, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try self.data.performFetch()
        } catch {
            fatalError("tags fetch failed")
        }
        
        
        if (1 >= self.data.sections![0].numberOfObjects )
        {
            self.Notesnum.text = "\(self.data.sections![0].numberOfObjects) Note"
        }else
        {
            self.Notesnum.text = "\(self.data.sections![0].numberOfObjects) Notes"
        }
        self.notesCollection.reloadData()
    }
    
    
    
    
    //Notes Collection View Confgration
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.data.sections![0].numberOfObjects
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as? CollectionViewCell
        let cellData = self.data.object(at: indexPath) as! NoteData
        cell?.titel.text = cellData.titelData
        cell?.note = cellData.noteTextData
        //let image = UIImageJPEGRepresentation(cellData.noteImageData, 1)
        
        if (cellData.noteImageData != nil )
        {
        let image = UIImage(data: cellData.noteImageData! as Data)
        if ( image != nil)
        {
            cell?.img.image = image
        }else
        {
            cell?.img.image = #imageLiteral(resourceName: "2")
        }
            
        }else
        {
            cell?.img.image = #imageLiteral(resourceName: "2")
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        if selectFlag{
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 2
            cell?.alpha = 0.8

            //check if cell already selected and deselected
            if (removeD.contains(indexPath))
            {
                if let index = self.removeD.index(of:indexPath)
                {
                    self.removeD.remove(at: index)
                    cell?.layer.borderWidth = 0
                    cell?.alpha = 1
                    
                    //cancel selecting action when no cells is selected
                    if self.removeD.count == 0
                    {
                        self.Delete.isEnabled = false
                        self.selectFlag = false
                    }
                }
            }else {
                self.removeD.append(indexPath)
            }
        }else
        {
            let cellData = self.data.object(at: indexPath) as! NoteData
            performSegue(withIdentifier: "viewCell", sender: cellData)
        }
        
    }
    
    //Gesture long press function
    @objc func longPressHandle(gestureRecognzer:UILongPressGestureRecognizer)
    {
        //if it's not long press or selecting action already enabled
        if (gestureRecognzer.state != .ended || selectFlag ){
            return
        }
        
        let postion = gestureRecognzer.location(in: self.notesCollection)
        
        if let indexPath = self.notesCollection.indexPathForItem(at: postion){
            let cell = self.notesCollection.cellForItem(at: indexPath)
            //select cell
            cell?.layer.borderColor = UIColor.gray.cgColor
            cell?.layer.borderWidth = 2
            cell?.alpha = 0.8
            
            selectFlag = true
            self.Delete.isEnabled = true
            
            // add cell to the array of selected cells
            self.removeD.append(indexPath)
        }
        
    }
    
    
    
    // Delete Selected Cells
    @IBAction func deleteSelectedNotes(_ sender: Any) {
        
        
        let alertController = UIAlertController(title: "Delete", message:"Delete \(self.removeD.count) notes.. ", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Confirm", style: .default) { (action) -> Void in
           
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let moc = appDelegate.dataController.managedObjectContext
            for note in self.removeD
            {
                let cellData = self.data.object(at: note) as! NoteData
                moc.delete(cellData)
                
            }
            do
            {
                try   moc.save()
            }
            catch {
                print("Error saving...")
            }
            self.removeD.removeAll()
            self.Delete.isEnabled = false
            self.selectFlag = false
            self.viewWillAppear(true)
            
            UIView.animate(withDuration: 5.5)
            {
                self.notesCollection.reloadData()
            }
            
        }
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    // Segue for View Notes Controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewCell" {
            
            let vc = segue.destination as! NoteViewController
            let cell = sender as! NoteData
            vc.note = cell
        }
    }

}

