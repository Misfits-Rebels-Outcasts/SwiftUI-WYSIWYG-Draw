//
//  imagePicker.swift
//
//
//  Created by  on 27/01/2021.
//

import Foundation
import SwiftUI

struct ImagePickerX: UIViewControllerRepresentable {
    
    @EnvironmentObject var shapes: ShapesX
    @EnvironmentObject var optionSettings: OptionSettings
    @Environment(\.presentationMode) var presentationMode

    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        var parent: ImagePickerX

        init(_ parent: ImagePickerX) {
            self.parent = parent
        }
        
 
        public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

            if parent.optionSettings.action == "NewImage"
            {
                var findshape: ShapeX? = nil
                parent.shapes.shapeList.forEach
                {
                    if $0.isSelected == true {
                        findshape = $0
                    }
                }
                if let x = parent.shapes.shapeList.firstIndex(of: findshape!)
                {
                    parent.shapes.shapeList.remove(at: x)
                }
            }

            print("dismis")
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            print("get")
            if let uiImage = info[.originalImage] as? UIImage {
                //parent.image = uiImage
                
                parent.shapes.shapeList.forEach
                {
                    if $0.isSelected == true {
                        if $0 is ImageX
                        {
                            let selectedImage = $0 as! ImageX
                            selectedImage.image = uiImage
                            //selectedImage.width
                        }

                    }
                }
                
            }
            
            parent.presentationMode.wrappedValue.dismiss()
        }
       
    }
   
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        
        picker.mediaTypes = ["public.image"]
        picker.delegate = context.coordinator
        return picker
                
        }
    
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    typealias UIViewControllerType = UIImagePickerController
}
