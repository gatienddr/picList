//
//  picListApp.swift
//  picList
//
//  Created by Gatien DIDRY on 06/04/2022.
//

import SwiftUI

@main
struct picListApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PicListView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
