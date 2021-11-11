//
//  TestProjectApp.swift
//  TestProject
//
//  Created by Ru Nue on 07.11.2021.
//

import SwiftUI

@main
struct TestProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(ViewModel())
        }
    }
}
