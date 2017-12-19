//
//  College.swift
//  CollegeProfileBuilder
//
//  Created by Wade Sellers on 7/22/16.
//  Copyright © 2016 MobileMakers. All rights reserved.
//

import UIKit

class College
{
    var name: String
    var location: String
    var numberOfStudents: String
    var image: UIImage
    var webPage: String
    var crest: UIImage
    
    init(Name n:String, Location l:String, NumberOfStudents s:String, Image i:UIImage, Webpage w:String, Crest c:UIImage)
    {
        name = n
        location = l
        numberOfStudents = s
        image = i
        webPage = w
        crest = c
    }
}




