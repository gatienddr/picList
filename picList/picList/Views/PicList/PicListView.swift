//
//  ContentView.swift
//  picList
//
//  Created by Gatien DIDRY on 06/04/2022.
//

import SwiftUI

struct PicListView: View {
    
    @ObservedObject var viewModel: PicListViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ImageCamera.title, ascending: true)],
        animation: .default)
    var pics: FetchedResults<ImageCamera>
    
    
    init(_ viewModel: PicListViewModel){
        self.viewModel = viewModel
    }
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(self.pics) { pics in
                    NavigationLink {
                        VStack{
                            Text(pics.title!)
                            Image(uiImage: UIImage(data: pics.storedImage!)!)
                                .resizable()
                                .padding()
                        }
                        
                    } label: {
                        Text(pics.title!)
                    }
                }
                
            }
            .navigationTitle("My pics")
            .toolbar {
                ToolbarItem {
                    Button(action: viewModel.displayCamera) {
                        Label("Add Item", systemImage: "camera")
                    }
                    .sheet(isPresented: self.$viewModel.isImagePickerDisplay, onDismiss: {
                        self.viewModel.addItem()
                    }) {
                        ImagePickerView(selectedImage: self.$viewModel.selectedImage, sourceType:.camera)
                    }
                    
                }
            }
            Text("Select an item")
        }
    }
    
    
    
    
}


