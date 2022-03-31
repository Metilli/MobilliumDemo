//
//  Constants.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation
import UIKit

struct Constant{
    
    struct TMDBParameters{
        static let page = "page"
        static let language = "language"
        static let adult = "adult"
    }
    
    struct TableViewIdentifier{
        static let upcomingTableViewCell = "upcomingTableViewCell"
    }
    
    struct TableViewNib{
        static let upcomingTableViewCell = "UpcomingTableViewCell"
    }
    
    struct Segue{
        static let movieDetailSegue = "movieDetailSegue"
    }
    
    struct Color{
        static let textBlack = UIColor(named: "TextBlack")
        static let textGray = UIColor(named: "TextGray")
        static let gradientStart = UIColor(named: "GradientStart")
        static let gradientEnd = UIColor(named: "GradientEnd")
    }
    
    struct CollectionViewIdentifier{
        static let nowPlayingCollectionCell = "NowPlayingCollectionCellIdentifier"
    }
    
    struct CollectionViewNib{
        static let nowPlayingCollectionCell = "NowPlayingCollectionViewCell"
    }
}

