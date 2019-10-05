//
//  NoteViewController.swift
//  MemoNote
//
//  Created by Ahmed Khattab on 9/21/19.
//  Copyright © 2019 Ahmed Khattab. All rights reserved.
//

import UIKit


class NoteViewController: UIViewController,UITextViewDelegate ,UIImagePickerControllerDelegate , UINavigationControllerDelegate {
    
    var imageChanged = false
    var notDeleted = true
    var note : NoteData!
    @IBOutlet weak var titel: UINavigationBar!
    @IBOutlet weak var deleteNote: UIBarButtonItem!
    @IBOutlet weak var shareNote: UIBarButtonItem!
    @IBOutlet weak var addImage: UIBarButtonItem!

   
    @IBOutlet weak var NoteImage: UIImageView!
    @IBOutlet weak var noteText: UITextView!
    @IBOutlet weak var noteDate: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Check for Note or disable the share button
        if (note.noteTextData != nil)
        {
            self.noteText.text = note.noteTextData
        }else{
            self.shareNote.isEnabled = false
        }
        
        //set titel and image
        if ( note.noteImageData != nil)
        {
        let image = UIImage(data: note.noteImageData! as Data)
        if ( image != nil)
        {
             self.NoteImage.image = image
        }else
        {
            self.NoteImage.image = #imageLiteral(resourceName: "2")
        }
        }else
        {
            self.NoteImage.image = #imageLiteral(resourceName: "2")
        }
        
        self.titel.topItem?.title = note.titelData
        
        self.noteDate.text = "      Created On:    \(note.creatDate!) ."
        
        self.noteText.delegate = self
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if (self.isMovingFromParentViewController)
        {
        if ((imageChanged || note.noteTextData != self.noteText.text) && notDeleted)
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let moc = appDelegate.dataController.managedObjectContext
            moc.delete(self.note)
         
            if imageChanged
            {
                note.noteImageData = UIImagePNGRepresentation( self.NoteImage.image!)! as NSData
            }
            note.noteTextData = self.noteText.text
            
            appDelegate.dataController.saveNote(titel: note.titelData!, note: note.noteTextData , image: note.noteImageData, Date: note.creatDate!)
            
            
            }
            
        }
        
    }

    //Handle the text changes here
    func textViewDidEndEditing(_ textView: UITextView) {
        if (textView.text != "" || self.NoteImage.image != #imageLiteral(resourceName: "2") )
        {
            self.shareNote.isEnabled = true
        }
        else
        {
            self.shareNote.isEnabled = false
        }
    }
    
    
    @IBAction func newImage(_ sender: Any) {
        
        let actionSheet = UIAlertController(title: "New Image", message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default, handler: { action in
            let CameraPicker = UIImagePickerController()
            CameraPicker.delegate = self
            CameraPicker.sourceType = .camera
            self.present(CameraPicker, animated: true, completion: nil)
        })
        let album = UIAlertAction(title: "Photos", style: .default, handler: { action in
            let CameraPicker = UIImagePickerController()
            CameraPicker.delegate = self
            CameraPicker.sourceType = .photoLibrary
            self.present(CameraPicker, animated: true, completion: nil)
            
        })
        let delete = UIAlertAction(title: "Delete", style: .destructive, handler: { action in
           self.NoteImage.image = #imageLiteral(resourceName: "2")
           self.imageChanged = true
        if (self.noteText.text != nil)
        {
            self.shareNote.isEnabled = false
            
        }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(album)
        if (self.NoteImage.image != #imageLiteral(resourceName: "2"))
        {
            actionSheet.addAction(delete)
        }
        actionSheet.addAction(cancel)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    //Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        {
            self.NoteImage.image = image
            self.NoteImage.alpha = 0
            self.imageChanged = true
            UIView.animate(withDuration: 2)
            {
                self.NoteImage.alpha = 1
                self.shareNote.isEnabled = true
            }
        }
        
    }
    
    @IBAction func deleteNote(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete", message:"Delete note!", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Confirm", style: .default) { (action) -> Void in
        
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let moc = appDelegate.dataController.managedObjectContext
            moc.delete(self.note)
            do
            {
                try   moc.save()
            }
            catch {
                print("Error saving...")
            }
            
            self.notDeleted = false
            self.navigationController?.popViewController(animated: true)

        }
        alertController.addAction(defaultAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    //Share
    
    @IBAction func share(_ sender: Any) {
        let activity = UIActivityViewController(activityItems: [(self.titel.topItem?.title!)!,NoteImage.image!,noteText.text], applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    
    
}
    

   


