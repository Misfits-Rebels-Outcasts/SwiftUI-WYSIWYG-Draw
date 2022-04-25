//
//  FilesView.swift
//
//
//  Created by  on 8/4/22.
//

import SwiftUI

@available(iOS 15.0, *)
struct FilesViewX: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
  
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    @StateObject var filesViewModel: FilesViewModel
    @State var showFileAlert = false
    @State private var toBeDeleted: IndexSet?
    @State var showingDeleteAlert = false

    var body: some View {

        NavigationView {
            Form {
                Section(header: Text("Tap to Open or Swipe Left to Delete")){
                    List {
                        ForEach(filesViewModel.files, id: \.self) { filename in
                            Text(filename).onTapGesture {
                                showFileAlert = true
                                print(filename)
                                filesViewModel.selectedFileName=filename
                            }.swipeActions() {
                                Button(role: .destructive) {
                                    print("delete")
                                    self.showingDeleteAlert = true
                                    filesViewModel.selectedFileName=filename
                                } label: {
                                  Label("Delete", systemImage: "trash")
                                }
                              }.alert(isPresented: self.$showingDeleteAlert) {
                                  
                                  Alert(title: Text("Are you sure you want to delete this?"), message: Text("This label will be removed permanently."), primaryButton: .destructive(Text("Delete")) {
                                      let filename = filesViewModel.selectedFileName
                                      print(filename)
                                      if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

                                          let fileURL = dir.appendingPathComponent(filename)
                                          do {
                                              try FileManager.default.removeItem(at: fileURL)
                                          }
                                          catch {}
                                          
                                      }
                                      
                                      filesViewModel.files.remove(at: filesViewModel.files.firstIndex(of: filename)!)
                                      }, secondaryButton: .cancel() {
                                          //self.toBeDeleted = nil
                                      }
                                  )
                              }
                        }
                                   
                     }
                     .font(.subheadline)
                }
                
            }
            .navigationTitle("My Labels")
            .navigationBarTitleDisplayMode(.inline)
        }
        //.frame(height:290)
        .onAppear(perform: setupViewModel)
        .alert(isPresented: $showFileAlert) {
            Alert(
                 title: Text("Are you sure you want to open this?"),
                 message: Text("Your current label will be overwritten."),
                 primaryButton: .default(Text("Open")) {
                     //open label
                     do {
                         // Get the document directory url
                         let documentDirectory = try FileManager.default.url(
                             for: .documentDirectory,
                             in: .userDomainMask,
                             appropriateFor: nil,
                             create: true
                         )
                         print("documentDirectory", documentDirectory.path)
                         
                         let fileURL = documentDirectory.appendingPathComponent(filesViewModel.selectedFileName)
                         
                         let jsonStr = try String(contentsOf: fileURL, encoding: .utf8)
                         let labelAction = LabelAction(shapes: shapes, pageSettings: pageSettings)
                         labelAction.load(jsonLabelStr: jsonStr)
                         appSettings.dpi=pageSettings.dpi
                         optionSettings.showAlert = false
                         optionSettings.showPropertiesSheet = false                         
                         appSettings.zoomFactor = horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.5 : 0.28

                     }
                     catch {
                         print(error)
                     }
                 },
                 secondaryButton: .cancel()
             )
            
        }
    }
    func share()
    {
        
    }
    
    func delete(at offsets: IndexSet) {
        
        self.toBeDeleted = offsets
        self.showingDeleteAlert = true
    }
    
    func setupViewModel()
    {
        do {
            let documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            print("documentDirectory", documentDirectory.path)
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentDirectory,
                includingPropertiesForKeys: nil
            )
            for url in directoryContents {
                print(url.lastPathComponent)
                if (url.lastPathComponent != "Label.pdf")
                {
                    filesViewModel.files.append(url.lastPathComponent)
                }
            }
        }
        catch {
            print(error)
        }
    }
}

