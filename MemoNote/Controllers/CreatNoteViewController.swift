//
//  CreatNoteViewController.swift
//  MemoNote
//
//  Created by Ahmed Khattab on 9/20/19.
//  Copyright © 2019 Ahmed Khattab. All rights reserved.
//

import UIKit

class CreatNoteViewController: UIViewController ,UIImagePickerControllerDelegate , UINavigationControllerDelegate , UITextViewDelegate,UITextFieldDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var note: UITextView!
    @IBOutlet weak var titel: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.image.image = #imageLiteral(resourceName: "2")
    }
    
    
    
    // Add Image
    @IBAction func noteImage(_ sender: Any) {
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
            self.image.alpha = 0
            self.image.image = #imageLiteral(resourceName: "2")
            UIView.animate(withDuration: 2)
            {
                self.image.alpha = 1
            }
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(camera)
        actionSheet.addAction(album)
        if (self.image.image != #imageLiteral(resourceName: "2"))
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
            
            self.image.alpha = 0
            self.image.image = image
            UIView.animate(withDuration: 2)
            {
                self.image.alpha = 1
            }
            
        }
        
    }
    
    @IBAction func createNote(_ sender: Any) {
        if self.titel.text == ""{
            let alertController = UIAlertController(title: "No Title", message: "Pleas add title for your note..", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let date = NSDate()
            var img = NSData()
            if image.image != #imageLiteral(resourceName: "2")
            {
                img = UIImagePNGRepresentation(image.image!)! as NSData
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
           
            appDelegate.dataController.saveNote(titel: self.titel.text!, note: self.note.text! , image: img, Date: date)
            navigationController?.popViewController(animated: true)
        }
    }
    

    

}

