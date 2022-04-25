//
//  LabelMainViewModel.swift
//
//
//  Created by  on 23/3/22.
//
import SwiftUI

class PreviewViewModel: BaseViewModel {

    @Published var startLabel: String = "1"
    @Published var numPages: String = "1"
    @Published var orientation: String = "Landscape"
    
    @Published var istartLabel : Int = 1
    @Published var inumPages : Int = 1
    @Published var scaleFactor : Double = 0.11
    @Published var printBorder : Bool = true

    init(dpi : Double, pageType: String)
    {
        super.init()
        let dpiFactor = 300.0/dpi
        scaleFactor = pageType == "envelope-landscape" ? 0.05 : 0.11
        scaleFactor = scaleFactor*dpiFactor
    }
}

