//
//  PicListViewModel.swift
//  picList
//
//  Created by Gatien DIDRY on 06/04/2022.
//

import Foundation
import UIKit
import CoreData
import SwiftUI


class PicListViewModel : ObservableObject{
    
    //MARK: Camera attribut
    @Published var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Published var selectedImage: UIImage?
    @Published var isImagePickerDisplay = false
    
    
    var viewContext : NSManagedObjectContext
    
    
    
    init(_ viewContext : NSManagedObjectContext){
        self.viewContext = viewContext
        
    }
    
    
    func displayCamera(){
        self.isImagePickerDisplay.toggle()    }
    
    func addItem() {
        let jpegImageData = selectedImage?.jpegData(compressionQuality: 1.0)
        let entityName =  NSEntityDescription.entity(forEntityName: "ImageCamera", in: viewContext)!
        print(entityName)
        let imageToSave = ImageCamera(entity: entityName, insertInto: viewContext)
        imageToSave.title = itemFormatter.string(from: Date.now)
        imageToSave.storedImage = jpegImageData
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
}




