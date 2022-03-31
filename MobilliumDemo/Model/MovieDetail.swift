//
//  MovieDetail.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation
import UIKit

class MovieDetail{
    var id:String
    var imdb_id:String?
    var imageURL:URL?
    var title:String
    var description:String
    var releaseDate:String
    
    init(id:String, imageURL: URL?, title: String, description: String, releaseDate: String, imdb_id:String = ""){
        self.imdb_id = imdb_id
        self.id = id
        self.imageURL = imageURL
        self.title = title
        self.description = description
        self.releaseDate = releaseDate
    }
}
