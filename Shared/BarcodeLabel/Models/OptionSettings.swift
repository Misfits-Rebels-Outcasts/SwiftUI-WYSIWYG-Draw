//
//  File.swift
//
//
//  Created by  on 17/3/22.
//

import Foundation
import SwiftUI

class OptionSettings: ObservableObject, Identifiable, Equatable {
    
    static func == (lhs: OptionSettings, rhs: OptionSettings) -> Bool {
        return lhs.id==rhs.id
    }
    
    var id = UUID()
    
    @Published var action: String = ""
    @Published var showPropertiesView: Int = 0
    @Published var showPropertiesSheet: Bool = false
    @Published var previewBorderWidth: Double = 4.0
    @Published var showAlert = false //display aleart for entering label name the textfield alert
    @Published var labelName: String = ""
    @Published var jsonLabelStringForSave: String = ""
    @Published var labelDocument: LabelDocument = LabelDocument(message: "")
    @Published var isExporting: Bool = false
    @Published var isImporting: Bool = false
    @Published var showingAlertMessage = false
    @Published var existingLabelExist = false
    @Published var enteredSaveFileName: String? // this is updated as the user types in the text field
    @Published var alertMessage: String? //"Label saved successfully." in AlertWrapper
    
    init(_ action: String) {
        self.action=action
    }
}
