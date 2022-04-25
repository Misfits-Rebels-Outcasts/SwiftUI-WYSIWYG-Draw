//
//  LaeblToolbarView.swift
//
//
//  Created by  on 17/3/22.
//

import SwiftUI
@available(iOS 15.0, *)
struct OptionsPrintToolbarViewX: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    @State private var showingAlert = false

    @State var measurementUnit : String = "Inches"
    
    var body: some View {
            
        Button(action: {
            
            shapes.deSelectAll();

            optionSettings.action = "Preview"
            //come back and change the name to showSheet
            optionSettings.showPropertiesSheet = true

        }, label: {
            Label("Print", systemImage: "printer")
                //.font(.system(size: 16))
        }).foregroundColor(.black)
        
    }

}
