//
//  Handler.swift
//  CalTest
//
//  Created by Andrew McAllister on 19/07/2021.
//  Copyright © 2021 MakeItForTheWeb Ltd. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift



 class Handler{
    let db: Firestore
    let storage: Storage
    
    
    init(){
        db = Firestore.firestore()
        storage = Storage.storage()
    }
    
}

