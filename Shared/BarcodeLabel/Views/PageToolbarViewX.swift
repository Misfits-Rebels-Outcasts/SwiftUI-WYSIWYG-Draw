//
//  LaeblToolbarView.swift
//
//
//  Created by  on 17/3/22.
//

import SwiftUI
import MobileCoreServices
@available(iOS 15.0, *)
       
@available(iOS 15.0, *)
struct PageToolbarViewX: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    @State private var showingAlert = false

    @State var measurementUnit : String = "Inches"
    
  
    
    var body: some View {
            
        Menu {

            Button(action: {
                
                shapes.deSelectAll();

            }, label: {
                Label("Labels", systemImage: "folder")


            })
                .contextMenu {
                    Button(action: {
                        shapes.deSelectAll();
                        optionSettings.action = "NewLabel"
                       
                        optionSettings.showPropertiesSheet = true
                        
            
             
                    }) {
                        Label("New", systemImage: "doc.badge.plus")
                    }
                    
                    Button(action: {
                        shapes.deSelectAll();
                        optionSettings.action = "OpenLabel"
                        /*
                        pageSettings.dpi=72.0
                        //pageSettings.generateLabels()
                         */
                        optionSettings.showPropertiesSheet = true
                        

                    }) {
                        //Label("Open Label", systemImage: "doc.badge.gearshape")
                        Label("My Labels", systemImage: "arrow.up.doc")
                    }
                    
            

                    Button(action: {
                        shapes.deSelectAll();
                        optionSettings.action = "SaveLabel"
                        
                        let labelAction = LabelAction(shapes: shapes, pageSettings: pageSettings)
                        optionSettings.jsonLabelStringForSave = labelAction.generate()                        
                        optionSettings.showAlert = true
                        

                    }) {
                        Label("Save", systemImage: "arrow.down.doc")
                    }
                    
                    Button(action: {
                        print("importing")
                        shapes.deSelectAll();
                        optionSettings.action = "Import"
                        optionSettings.isImporting = true
                    }) {
                        Label("Import", systemImage: "square.and.arrow.down")
                    }
                    
                    Button(action: {
                        print("exporting")
                        
                        let labelAction = LabelAction(shapes: shapes, pageSettings: pageSettings)
                        optionSettings.labelDocument.message = labelAction.generate()

                        
                        optionSettings.action = "Export"
                        optionSettings.isExporting = true
                    }) {
                        Label("Export", systemImage: "square.and.arrow.up")
                    }


                }

            Button(action: {
                
                shapes.deSelectAll();

            }, label: {
                Label("Options", systemImage: "doc.badge.gearshape")


            })
                .contextMenu {
 
                    Menu("Measurements") {
                        Picker("Units", selection: $appSettings.units) {
                            ForEach(measurementUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .onChange(of: appSettings.units) { newValue in
                            let defaults = UserDefaults.standard
                            print("Setting:",appSettings.units)
                            defaults.set(appSettings.units, forKey: "units")
                            
                        }
                    }
                    
                    Menu("Help") {
                        Link("Help", destination: URL(string: "https://www.barcoderesource.com/barcodelabelappleapp.shtml")!)
                            .font(.title)
                            //.foregroundColor(.red)
                        Link("Open Source", destination: URL(string: "https://www.barcoderesource.com/swiftui_view_vector_draw_wysiwyg.shtml")!)
                            .font(.title)
                            //.foregroundColor(.red)
                    }

                }
    
          
            

        }
        label: {
            VStack {
                
                Image(systemName: "doc")
                    .foregroundColor(colorScheme == .dark ? Color(UIColor(red: 0.9569, green: 0.9569, blue: 0.9569, alpha: 0.5) ) : Color.black)
            }
        }
    }

}
