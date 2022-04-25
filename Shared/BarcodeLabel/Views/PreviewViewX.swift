/*
Copyright 2022 barcoderesource.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

import SwiftUI

struct ActualRenderedPageView: View {
    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    @ObservedObject var previewViewModel: PreviewViewModel
    
    var body: some View {
      ZStack {
            ForEach(pageSettings.labelList) { iLabel in
                if iLabel.label >= previewViewModel.istartLabel //&& iLabel.label <= previewViewModel.inumLabels
                {
                    VStack {
                        LabelViewX()
                        .frame(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi, alignment: .center)
                    }
                    .frame(width: pageSettings.labelWidth*appSettings.dpi, height: pageSettings.labelHeight*appSettings.dpi, alignment: .center)
                    .border(Color.gray, width: previewViewModel.printBorder ? optionSettings.previewBorderWidth : 0)
                    .position(x: iLabel.x, y: iLabel.y)
                }
            }
        }
        .frame(width: pageSettings.pageWidth*appSettings.dpi, height: pageSettings.pageHeight*appSettings.dpi, alignment: .topLeading)
        .border(Color.gray, width: previewViewModel.printBorder ? optionSettings.previewBorderWidth : 0)
        .background(Color.white)
    }
}

struct PreviewViewX: View {

    @EnvironmentObject var optionSettings: OptionSettings
    @EnvironmentObject var appSettings: AppSettings
    @EnvironmentObject var pageSettings: PageSettings
    @EnvironmentObject var shapes: ShapesX
    @StateObject var previewViewModel: PreviewViewModel

    var body: some View {

        NavigationView {

            Form {
            
                Section(header: Text("Preview")){
                    HStack{
                        Spacer()
                        VStack
                        {
                            VStack {
                                ActualRenderedPageView(previewViewModel:previewViewModel)
                            }
                            .scaleEffect(previewViewModel.scaleFactor)
                            .padding()
                        }
                        .frame(width: pageSettings.pageWidth*appSettings.dpi * previewViewModel.scaleFactor,
                               height: pageSettings.pageHeight*appSettings.dpi * previewViewModel.scaleFactor,
                               alignment: .center)
                        .background(Color.white)
                        Spacer()

                    }.padding().disabled(true)
                }
                                                
                Section(header: Text("Options")){
                    HStack() {
                        Text("Start Label")
                        Spacer()
                        TextField("Start Label", text: $previewViewModel.startLabel)
                            .foregroundColor(Color.black).fixedSize().multilineTextAlignment(.trailing)
                            .onChange(of: previewViewModel.startLabel) { newValue in

                                if previewViewModel.startLabel.count > 2 {
                                    previewViewModel.startLabel = String(previewViewModel.startLabel.prefix(2))
                                }

                                previewViewModel.istartLabel = Int(previewViewModel.startLabel) ?? 1
                                
                                if  previewViewModel.istartLabel > pageSettings.numRows * pageSettings.numCols ||
                                        previewViewModel.istartLabel < 1
                                {
                                    previewViewModel.istartLabel = 1
                                    previewViewModel.startLabel = "1"
                                }
                            }
                            //auto selecting text field//requires a package so not used yet
                            //https://www.hackingwithswift.com/forums/100-days-of-swiftui/selecting-the-content-of-a-field-on-entering-a-textfield/5615
                    }

                    HStack() {
                        Text("Number of Pages")
                        Spacer()
                        TextField("Number of Pages", text: $previewViewModel.numPages)
                            .foregroundColor(Color.black).fixedSize().multilineTextAlignment(.trailing)
                            .onChange(of: previewViewModel.numPages) { newValue in
                                if previewViewModel.numPages.count > 2 {
                                    previewViewModel.numPages = String(previewViewModel.numPages.prefix(2))
                                }

                                previewViewModel.inumPages = Int(previewViewModel.numPages) ?? 1
                                if previewViewModel.inumPages < 1
                                {
                                    previewViewModel.inumPages = 1
                                }
           
                            }
                    }
                    
                    if pageSettings.type == "envelope-landscape"
                    {
                        Picker("Orientation", selection: $previewViewModel.orientation) {
                            ForEach(orientation, id: \.self) {
                                Text($0)
                            }
                        }
                        /*
                        .onChange(of: previewViewModel.orientation) { newValue in
               
                        }
                        */
                        
                    }
                    
                }
              
                
            }
            .navigationTitle("Page Preview")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                        Button("Printer") {
                            printLabel()
                            //optionSettings.showPropertiesView=0 //set back to 0
                        }
                }
                ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            optionSettings.showPropertiesView=0 //set back to 0
                            optionSettings.showPropertiesSheet=false
                        }
                }
                
   
            }
        } //For,
        .onAppear(perform: populateForm)
                    
    }
   
    
    func printLabel()
    {
        
        print("saving")
        
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let outputFileURL = documentDirectory.appendingPathComponent("Label.pdf")

        //Normal with
        let pdfwidth: CGFloat = CGFloat(pageSettings.pageWidth*72.0)
        let pdfheight: CGFloat = CGFloat(pageSettings.pageHeight*72.0)
              

        print(pageSettings.description)
        var pw=pdfwidth
        var ph=pdfheight
        //if pageSettings.type == "envelope-landscape"
        if pageSettings.type == "envelope-landscape" && previewViewModel.orientation == "Portrait"
        {
            pw = pdfheight
            ph = pdfwidth
        }
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: pw, height: ph))
        
        DispatchQueue.main.async {
             do {

                                  
                 try pdfRenderer.writePDF(to: outputFileURL, withActions: { (context) in

                     let pageSize = CGSize(width: pageSettings.pageWidth*appSettings.dpi, height: pageSettings.pageHeight*appSettings.dpi)
                     let origin = CGPoint(x:0,y:0)
                     let rootVC = UIApplication.shared.windows.first?.rootViewController
                     previewViewModel.printBorder=false;
                     for x in 1...previewViewModel.inumPages
                     {
                         if x > 1
                         {
                             previewViewModel.istartLabel = 1
                         }

                         let pdfVC = UIHostingController(rootView: ActualRenderedPageView(previewViewModel:previewViewModel)
                                                            .environmentObject(shapes)
                                                            .environmentObject(appSettings)
                                                            .environmentObject(optionSettings)
                                                            .environmentObject(pageSettings), ignoreSafeArea:true )
                         pdfVC.view.frame = CGRect(origin: origin, size: pageSize * appSettings.dpiScale)
                         pdfVC.view.frame = CGRect(origin: .zero, size: pageSize)
                         rootVC?.addChild(pdfVC)
                         rootVC?.view.insertSubview(pdfVC.view, at: 0)
                         context.beginPage()
 
                         //if pageSettings.type == "envelope-landscape"
                         if pageSettings.type == "envelope-landscape" && previewViewModel.orientation == "Portrait"
                         {
                             context.cgContext.rotate(by: 90.0 * CGFloat.pi / 180.0)
                             context.cgContext.translateBy(x: 0, y: -pageSize.height*72/300)
                         }
                         print(pageSize.width)
                         print(pageSize.height)
                         
                         context.cgContext.scaleBy(x: 1 / appSettings.dpiScale, y: 1 / appSettings.dpiScale)
                        
                         pdfVC.view.layer.render(in: context.cgContext)
                         pdfVC.view.removeFromSuperview()
                         pdfVC.removeFromParent()
                     }
                     previewViewModel.printBorder=true;
                 })
                 print("wrote file to: \(outputFileURL.path)")

                 
                 
                 let printInfo = UIPrintInfo(dictionary: nil)
                 printInfo.jobName = "Label"
                 printInfo.outputType = .general

                 
                 let printController = UIPrintInteractionController.shared
                 printController.printInfo = printInfo
                 printController.showsNumberOfCopies = true
                 
                 printController.printingItem = outputFileURL
                
                 printController.present(animated: true) { (controller, success, error) -> Void in
                         if success {
                             optionSettings.showPropertiesView=0
                             optionSettings.showPropertiesSheet=false
 
                             previewViewModel.istartLabel = 1
                             previewViewModel.inumPages = 1
                             previewViewModel.startLabel = "1"
                             previewViewModel.numPages = "1"

                         } else {
  
                             previewViewModel.istartLabel = 1
                             previewViewModel.inumPages = 1
                             previewViewModel.startLabel = "1"
                             previewViewModel.numPages = "1"

                         }
                     }
                
              
             } catch {
                 print("Could not create PDF file: \(error.localizedDescription)")
             }
         }
        
        
    }
    
    func populateForm()
    {
        print("populateForm")


    }
    
}

