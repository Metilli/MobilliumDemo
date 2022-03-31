//
//  ViewController.swift
//  MobilliumDemo
//
//  Created by Metilli on 29.03.2022.
//

import UIKit
import Lottie

class HomeViewController: MovieViewController {

    @IBOutlet weak var topContainer: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nowPlayingCollectionView: UICollectionView!
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var upcomingTableView: UITableView!
    let refreshControl = UIRefreshControl()
    var animationView:AnimationView?
    
    var tableViewData:[MovieDetail] = []{
        didSet{
            upcomingTableView.reloadData()
        }
    }
    
    var collectionViewData:[MovieDetail] = []{
        didSet{
            nowPlayingCollectionView.reloadData()
            pageControl.numberOfPages = collectionViewData.count
        }
    }
    
    var isFetchingCollectionViewData = false{
        didSet{
            if !isFetchingCollectionViewData{
                stopLoadingAnimation()
                refreshControl.endRefreshing()
            }
        }
    }
    
    var isFetchingTableViewData = false{
        didSet{
            if !isFetchingTableViewData{
                stopLoadingAnimation()
                upcomingTableView.tableFooterView = nil
                refreshControl.endRefreshing()
            }
        }
    }
    
    var selectedMovieID = ""
    
    let viewModel = HomeViewModel()
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showLoadingAnimation()
        setupBindings()
        setupView()
    }
    
    func setupView(){
        navigationItem.title = " "
        
        mainScrollView.delegate = self
        upcomingTableView.isScrollEnabled = false
        
        nowPlayingCollectionView.register(UINib(nibName: Constant.CollectionViewNib.nowPlayingCollectionCell, bundle: nil), forCellWithReuseIdentifier: Constant.CollectionViewIdentifier.nowPlayingCollectionCell)
        nowPlayingCollectionView.dataSource = self
        nowPlayingCollectionView.delegate = self
        
        let frameHeight = UIScreen.main.bounds.height
        tableViewHeight.constant = frameHeight
        
        upcomingTableView.register(UINib(nibName: Constant.TableViewNib.upcomingTableViewCell, bundle: nil), forCellReuseIdentifier: Constant.TableViewIdentifier.upcomingTableViewCell)
        upcomingTableView.dataSource = self
        upcomingTableView.delegate = self
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        mainScrollView.refreshControl = refreshControl
    }
    
    @objc func refresh(){
        viewModel.refreshPage()
    }
    
    func setupBindings(){
        viewModel.errorMessage.bind { [weak self] error in
            self?.errorMessage = error
        }
        viewModel.tableViewData.bind { [weak self] data in
            self?.tableViewData = data
        }
        viewModel.collectionViewData.bind { [weak self] data in
            self?.collectionViewData = data
        }
        viewModel.isFetchingCollectionViewData.bind { [weak self] value in
            self?.isFetchingCollectionViewData = value
        }
        viewModel.isFetchingTableViewData.bind { [weak self] value in
            self?.isFetchingTableViewData = value
        }
    }
    
    func showLoadingAnimation(){
        mainScrollView.alpha = 0
        
        animationView = AnimationView.init(name: "loadingAnimation")
        animationView?.frame = view.bounds
        animationView?.center = view.center
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        animationView?.animationSpeed = 1.5
        
        view.addSubview(animationView!)
    }
    
    func stopLoadingAnimation(){
        mainScrollView.alpha = 1
        animationView?.removeFromSuperview()
        animationView = nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constant.Segue.movieDetailSegue{
            let vc = segue.destination as! MovieDetailViewController
            vc.viewModel = MovieDetailViewModel(movieID: selectedMovieID)
        }
    }
}

extension HomeViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constant.TableViewIdentifier.upcomingTableViewCell) as! UpcomingTableViewCell
        
        let movie = tableViewData[indexPath.row]
        
        cell.configureCell(imageURL: movie.imageURL, title: movie.title, description: movie.description, date: movie.releaseDate)
        
        return cell
    }
    
}

extension HomeViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMovieID = tableViewData[indexPath.row].id
        print(selectedMovieID)
        performSegue(withIdentifier: Constant.Segue.movieDetailSegue, sender: nil)
    }
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constant.CollectionViewIdentifier.nowPlayingCollectionCell, for: indexPath) as! NowPlayingCollectionViewCell
        
        let movie = collectionViewData[indexPath.row]
        
        cell.configureCell(imageURL: movie.imageURL, title: movie.title, description: movie.description)
        
        return cell
    }
    
    
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovieID = collectionViewData[indexPath.row].id
        performSegue(withIdentifier: Constant.Segue.movieDetailSegue, sender: nil)
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
}


extension HomeViewController{
    
    func createInditicatorFooterView() -> UIView{
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: upcomingTableView.bounds.width, height: upcomingTableView.rowHeight))
        
        let indicatorView = UIActivityIndicatorView()
        indicatorView.center = footerView.center
        footerView.addSubview(indicatorView)
        indicatorView.startAnimating()
        
        return footerView
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == mainScrollView {
            let position = mainScrollView.contentOffset.y
            mainScrollView.bounces = position < 100
            
            if position >= 256{
                mainScrollView.isScrollEnabled = false
                upcomingTableView.isScrollEnabled = true
            }
        }

        if scrollView == upcomingTableView {
            let position = upcomingTableView.contentOffset.y
            upcomingTableView.bounces = position > 200
            
            if position <= 0 {
                mainScrollView.isScrollEnabled = true
                upcomingTableView.isScrollEnabled = false
            }else if position > upcomingTableView.contentSize.height - upcomingTableView.rowHeight - tableViewHeight.constant{
                upcomingTableView.tableFooterView = createInditicatorFooterView()
                viewModel.fetchMoreUpcomingMovie()
            }
        }
        
        if scrollView == nowPlayingCollectionView{
            let position = nowPlayingCollectionView.contentOffset.x
            
            pageControl.currentPage = Int(position/nowPlayingCollectionView.bounds.width)
            
            if pageControl.currentPage >= pageControl.numberOfPages - 3{
                viewModel.fetchMoreMovieNowPlaying()
            }
        }
    }
}
