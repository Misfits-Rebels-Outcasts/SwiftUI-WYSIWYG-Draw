/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import UniformTypeIdentifiers

@available(iOS 15.0, *)


struct LabelMainViewX: View {
    @Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
        
    //https://stackoverflow.com/questions/57577462/get-width-of-a-view-using-in-swiftui
    //https://developer.apple.com/forums/thread/123012

    private func binding(for shape: ShapeX) -> Binding<ShapeX> {
         guard let scrumIndex = shapes.shapeList.firstIndex(where: { $0.id == shape.id }) else {
             fatalError("Can't find scrum in array")
         }
         return $shapes.shapeList[scrumIndex]
     }
    
    var body: some View {
        NavigationView {
        VStack {
            LabelDesignViewX()
                .environmentObject(optionSettings)
                .environmentObject(pageSettings)
                .environmentObject(appSettings)
                .environmentObject(shapes)
            MainPropertiesViewX()
                .environmentObject(optionSettings)
                .environmentObject(pageSettings)
                .environmentObject(appSettings)
                .environmentObject(shapes)
        }
        .navigationTitle("Barcode & Label")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                PageToolbarViewX()
            }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                OptionsPrintToolbarViewX()
            }
        }
        .ignoresSafeArea(.container, edges: [.bottom])
        } //navigationview
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear(perform: initAll)
        .alert(isPresented: $optionSettings.showingAlertMessage) {
            Alert(title: Text("Status"), message: Text(optionSettings.alertMessage!), dismissButton: .default(Text("OK")))
        }
        .sheet(isPresented: $optionSettings.showPropertiesSheet, onDismiss: dismissSheet) {

            MainSheetViewX()
                .environmentObject(appSettings)
                .environmentObject(optionSettings)
                .environmentObject(pageSettings)
                .environmentObject(shapes)

                
        } //sheet
        .textFieldAlert(isPresented: $optionSettings.showAlert) { () -> TextFieldAlert in
            TextFieldAlert(title: "Saving Label",
                           message: "Please specify label name.",
                           labelContent:optionSettings.jsonLabelStringForSave,
                           text: $optionSettings.enteredSaveFileName,
                           saveSuccess: $optionSettings.showingAlertMessage,
                           existingLabelExist: $optionSettings.existingLabelExist,
                           alertMessage: $optionSettings.alertMessage)
        }
        .fileImporter(
            isPresented: $optionSettings.isImporting,
            allowedContentTypes: [UTType.json],
            allowsMultipleSelection: false
        ) { result in
            do {
                guard let selectedFile: URL = try result.get().first else { return }
                guard selectedFile.startAccessingSecurityScopedResource() else { return }
                guard let message = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                let labelAction = LabelAction(shapes: shapes, pageSettings: pageSettings)
                labelAction.load(jsonLabelStr: message)
                optionSettings.showAlert = false
                optionSettings.showPropertiesSheet = false
                appSettings.zoomFactor = horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.5 : 0.28

                selectedFile.stopAccessingSecurityScopedResource()
                optionSettings.showingAlertMessage = true
                optionSettings.alertMessage="Label imported successfully."
                //import and open appSettings.dpi use the pageSttings one which is the onve saved
                appSettings.dpi=pageSettings.dpi

            } catch {
                print(error.localizedDescription)
                optionSettings.showingAlertMessage = true
                optionSettings.alertMessage="An error has occured while importing label - Invalid Label File."
            }
        }        
        .fileExporter(
            isPresented: $optionSettings.isExporting,
            document: optionSettings.labelDocument,
            contentType: UTType.json,
            defaultFilename: "Label"
        ) { result in
            optionSettings.showingAlertMessage = true
            if case .success = result {
                optionSettings.alertMessage="Label exported successfully."
                print("Success!")
            } else {
                optionSettings.alertMessage="An error has occured while exporting label. Please try again or contact us."
                print("Something went wrong…")
            }
        }
        
    } //body

   
    func dismissSheet()
    {
        optionSettings.action = "Design"
    }
    
    func initLabel() {
        shapes.shapeList=[ShapeX]()
    }
    
    func initPage() {
        print("initPage:",labelTemplatesAll.count)

        //new and startup will use appSettings dpi
        pageSettings.dpi=appSettings.dpi
        
        pageSettings.name = labelTemplates[8][0]
        pageSettings.category = labelTemplates[8][1]
        pageSettings.vendor = labelTemplates[8][2]
        pageSettings.description = labelTemplates[8][3]
        pageSettings.type = labelTemplates[8][4]
        pageSettings.pageWidth = Double(labelTemplates[8][5]) ?? 1.0
        pageSettings.pageHeight = Double(labelTemplates[8][6]) ?? 1.0
        pageSettings.labelWidth = Double(labelTemplates[8][7]) ?? 1.0
        pageSettings.labelHeight = Double(labelTemplates[8][8]) ?? 1.0
        pageSettings.hSpace = Double(labelTemplates[8][9]) ?? 0.0
        pageSettings.vSpace = Double(labelTemplates[8][10]) ?? 0.0
        pageSettings.numRows = Int(labelTemplates[8][11]) ?? 1
        pageSettings.numCols = Int(labelTemplates[8][12]) ?? 1
        pageSettings.leftMargin = Double(labelTemplates[8][13]) ?? 0.0
        pageSettings.topMargin = Double(labelTemplates[8][14]) ?? 0.0
        pageSettings.generateLabels()

        let defaults = UserDefaults.standard
        if let unitstring = defaults.string(forKey: "units"), !unitstring.isEmpty {
            print("Getting:",unitstring)
            appSettings.units = unitstring
        }
        else{
            print("Setting:",appSettings.units)
            defaults.set(appSettings.units, forKey: "units")
        }
        

    }
    func convertStringToDictionary(text: String) -> [String:AnyObject]? {
       if let data = text.data(using: .utf8) {
           do {
               let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
               return json
           } catch {
               print("Something went wrong")
           }
       }
       return nil
   }
    
    func initAll()
    {
        initLabel()
        initPage()
        
        
        //let timer2 =
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { timer in
            print("Timer fired!")
            appSettings.zoomFactor = horizontalSizeClass == .regular && verticalSizeClass == .regular ? 0.5 : 0.28
            print(appSettings.zoomFactor)
        }
        
    }
}


