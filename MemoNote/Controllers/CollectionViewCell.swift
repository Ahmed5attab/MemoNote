//
//  CollectionViewCell.swift
//  MemoNote
//
//  Created by Ahmed Khattab on 9/17/19.
//  Copyright © 2019 Ahmed Khattab. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  
    @IBOutlet weak var titel: UILabel!
    
    @IBOutlet weak var img: UIImageView!

    var note : String!
}
