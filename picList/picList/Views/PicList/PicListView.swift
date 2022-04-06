//
//  ContentView.swift
//  picList
//
//  Created by Gatien DIDRY on 06/04/2022.
//

import SwiftUI
import CoreData

struct PicListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    
    
    //MARK: Camera attribut
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ImageCamera.title, ascending: true)],
        animation: .default)
    private var pics: FetchedResults<ImageCamera>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pics) { pics in
                    NavigationLink {
                        VStack{
                            Text(pics.title!)
                            Image(uiImage: UIImage(data: pics.storedImage!)!)
                        }
                        
                    } label: {
                        Text(pics.title!)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("My pics")
            .toolbar {
                ToolbarItem {
                    Button(action: displayCamera) {
                        Label("Add Item", systemImage: "camera")
                    }
                    .sheet(isPresented: self.$isImagePickerDisplay, onDismiss: {
                        self.addItem()
                    }) {
                        ImagePickerView(selectedImage: self.$selectedImage, sourceType:.camera)
                    }
                    
                }
            }
            Text("Select an item")
        }
    }
    
    private func displayCamera(){
        self.isImagePickerDisplay.toggle()    }
    
    private func addItem() {
        let jpegImageData = selectedImage?.jpegData(compressionQuality: 1.0)
        let entityName =  NSEntityDescription.entity(forEntityName: "ImageCamera", in: viewContext)!
        let imageToSave = ImageCamera(entity: entityName, insertInto: viewContext)
        imageToSave.title = "test"
        imageToSave.storedImage = jpegImageData
        do {
            try viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { pics[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

