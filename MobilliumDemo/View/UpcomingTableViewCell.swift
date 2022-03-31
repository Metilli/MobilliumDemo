//
//  UpcomingTableViewCell.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import UIKit
import Kingfisher

class UpcomingTableViewCell: UITableViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupView()
    }
    
    func setupView(){
        posterImageView.layer.cornerRadius = 8
    }
    
    func configureCell(imageURL: URL?, title: String, description: String, date:String){
        
        titleLabel.text = title
        descriptionLabel.text = description
        dateLabel.text = date
        
        if let safeImageUrl = imageURL{
            let processor = DownsamplingImageProcessor(size: posterImageView.bounds.size)
            posterImageView.kf.indicatorType = .activity
            posterImageView.kf.setImage(
                with: safeImageUrl,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .loadDiskFileSynchronously,
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
        }
        
    }
}
