//
//  LabelTemplatesModel.swift
//
//
//  Created by  on 23/3/22.
//


var labelTemplatesAll = [

       ["Standard SA4001","Labels","Standard","Address Label (A4) - 8x3","iso-a4","8.268","11.693","2.520","1.333","0.104","0.000","8","3","0.250","0.541"],
       ["Standard SA4002","Labels","Standard","Address Label (A4) - 7x3","iso-a4","8.268","11.693","2.500","1.500","0.100","0.000","7","3","0.283","0.625"],
       ["Standard SA4003","Labels","Standard","Address Label (A4) - 6x3","iso-a4","8.268","11.693","2.500","1.833","0.100","0.000","6","3","0.283","0.375"],
       ["Standard SA4004","Labels","Standard","Address Label (A4) - 8x2","iso-a4","8.268","11.693","3.900","1.333","0.100","0.000","8","2","0.184","0.541"],
       ["Standard SA4005","Labels","Standard","Address Label (A4) - 7x2","iso-a4","8.268","11.693","3.900","1.500","0.100","0.000","7","2","0.184","0.625"],
       ["Standard SA4006","Labels","Standard","Address Label (A4) - 4x2","iso-a4","8.268","11.693","3.900","2.667","0.100","0.000","4","2","0.184","0.542"],

       ["Standard SLE001","Labels","Standard","Address Label (Letter) - 10x2","iso-letter","8.500","11.000","4.000","1.000","0.189","0.000","10","2","0.156","0.500"],
       ["Standard SLE002","Labels","Standard","Address/Shipping (Letter) - 3x2","iso-letter","8.500","11.000","4.000","3.333","0.188","0.000","3","2","0.156","0.500"],
       ["Standard SLE003","Labels","Standard","Address/Shipping (Letter) - 5x2","iso-letter","8.500","11.000","4.000","2.000","0.188","0.000","5","2","0.156","0.500"],
       ["Standard SLE004","Labels","Standard","Address Label (Letter) - 7x2","iso-letter","8.500","11.000","4.000","1.333","0.188","0.000","7","2","0.156","0.833"],
       ["Standard SLE005","Labels","Standard","Address Label (Letter) - 10x3","iso-letter","8.500","11.000","2.625","1.000","0.125","0.000","10","3","0.188","0.500"],

        ]
var labelTemplates = labelTemplatesAll.filter {
    $0[1].contains("Labels") && $0[2].contains("Standard")
}

var labelTemplatesCount = 11

var categories = ["Labels"]
//var categories = ["Labels","Envelopes","Cards & Tags","Papers"]

var vendorsCards = ["Standard"]

var vendorsLabels = ["Standard"]

var vendors = vendorsLabels

var fontNames = ["Helvetica","Helvetica Bold","American Typewriter Bold","Arial","Arial Bold","Arial Italic"]

var barcodeFontNames = ["CCode39_S3","CCodeIPostnet","CCodeIND2of5_S3", "Arial"]

var barcodeNames = ["Code 39","Industrial 2 of 5","POSTNET"]

var measurementUnits = ["Inches","Centimeters"]

var orientation = ["Portrait","Landscape"]
