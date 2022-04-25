//
//  MainSheetViewX.swift
//
//
//  Created by  on 21/4/22.
//

import SwiftUI

@available(iOS 15.0, *)
struct MainSheetViewX: View {
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    
    var body: some View {
        if optionSettings.action == "NewLabel"
        {
                    
            TemplateViewX(templateViewModel: TemplateViewModel(units: appSettings.units, pageSettings: self.pageSettings))
                .environmentObject(appSettings)
                .environmentObject(optionSettings)
                .environmentObject(pageSettings)
                .environmentObject(shapes)
             
        }
        else if optionSettings.action == "OpenLabel"
        {
            FilesViewX(filesViewModel: FilesViewModel())
                .environmentObject(optionSettings)
        }
        else if optionSettings.action == "Preview"
        {
            PreviewViewX(previewViewModel: PreviewViewModel(dpi: appSettings.dpi,pageType: pageSettings.type))
                .environmentObject(appSettings)
                .environmentObject(optionSettings)
                .environmentObject(pageSettings)
                .environmentObject(appSettings)
                .environmentObject(shapes)
        }
        else if optionSettings.action == "NewImage" || optionSettings.action == "EditImage" {

            ImagePickerX()
                .environmentObject(optionSettings)
                .environmentObject(shapes)
        }

    }
}
