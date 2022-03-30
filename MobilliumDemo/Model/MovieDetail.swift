//
//  MovieDetail.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation
import UIKit

class MovieDetail{
    var imageURL:URL?
    var title:String
    var description:String
    var releaseDate:String
    
    init(imageURL: URL?, title: String, description: String, releaseDate: String){
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.releaseDate = releaseDate
    }
}
