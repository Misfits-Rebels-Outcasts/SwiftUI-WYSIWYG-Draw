//
//  MessageDocument.swift
//  ImportExport
//
//  Created by Aaron Wright on 8/27/20.
//

import SwiftUI
import UniformTypeIdentifiers

struct LabelDocument: FileDocument {
    
    static var readableContentTypes: [UTType] { [.json] }

    var message: String

    init(message: String) {
        self.message = message
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        message = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: message.data(using: .utf8)!)
    }
    
}
