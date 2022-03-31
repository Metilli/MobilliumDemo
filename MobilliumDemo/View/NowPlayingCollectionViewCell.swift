//
//  NowPlayingCollectionViewCell.swift
//  MobilliumDemo
//
//  Created by Metilli on 31.03.2022.
//

import UIKit
import Kingfisher

class NowPlayingCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(imageURL: URL?, title: String, description: String){
        titleLabel.text = title
        descriptionLabel.text = description
        
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
