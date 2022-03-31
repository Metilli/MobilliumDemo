//
//  MovieDetailViewController.swift
//  MobilliumDemo
//
//  Created by Metilli on 31.03.2022.
//

import UIKit
import Kingfisher

class MovieDetailViewController: MovieViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var imdbImageView: UIImageView!
    
    var imdbID = ""
    
    var posterURL:URL?{
        didSet{
            if let safeImageUrl = posterURL{
                posterImageView.kf.indicatorType = .activity
                posterImageView.kf.setImage(
                    with: safeImageUrl,
                    placeholder: UIImage(named: "placeholderImage"),
                    options: [
                        .scaleFactor(UIScreen.main.scale),
                        .loadDiskFileSynchronously,
                        .transition(.fade(1)),
                        .cacheOriginalImage
                    ])
            }
        }
    }
    
    var viewModel:MovieDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setupBindings()
    }
    
    func setupView(){
        navigationController?.navigationBar.isHidden = false
        
        descriptionLabel.textContainer.lineFragmentPadding = CGFloat(0.0)
        descriptionLabel.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        descriptionLabel.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        
        let imdbGesture = UITapGestureRecognizer(target: self, action: #selector(openIMDB))
        imdbImageView.addGestureRecognizer(imdbGesture)
    }
    
    func setupBindings(){
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
        viewModel.moviePosterURL.bind { [weak self] url in
            self?.posterURL = url
        }
        viewModel.movieTitle.bind { [weak self] title in
            self?.navigationItem.title = title
            self?.titleLabel.text = title
        }
        viewModel.movieReleaseDate.bind { [weak self] releaseDate in
            self?.releaseDateLabel.text = releaseDate
        }
        viewModel.movieRate.bind { [weak self] rate in
            self?.ratingLabel.text = rate
        }
        viewModel.movieDescription.bind { [weak self] text in
            self?.descriptionLabel.text = text
        }
        viewModel.movieimdbID.bind { [weak self] imdbID in
            self?.imdbID = imdbID
        }
    }
    
    @objc func openIMDB(){
        if !imdbID.isEmpty{
            if let url = URL(string: URLs.imdbUrl + imdbID) {
                UIApplication.shared.open(url)
            }
        }
    }
}
