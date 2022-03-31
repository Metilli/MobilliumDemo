//
//  HomeViewModel.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

class HomeViewModel{
    
    let collectionViewData: ObservableObject<[MovieDetail]> = ObservableObject([])
    let tableViewData: ObservableObject<[MovieDetail]> = ObservableObject([])
    let isFetchingTableViewData:ObservableObject<Bool> = ObservableObject(false)
    let isFetchingCollectionViewData:ObservableObject<Bool> = ObservableObject(false)
    let errorMessage: ObservableObject<String?> = ObservableObject(nil)
    
    private let tmdbService = TMDBService()
    private let params: [String : Any] = [Constant.TMDBParameters.language : "en-US",
                                 Constant.TMDBParameters.adult : false]
    
    private var upcomingMoviePageNumber = 1
    private var nowPlayingMoviePageNumber = 1
    
    private var upcomingTotalPageNumber = 0
    private var nowPlayingTotalPageNumber = 0
    
    init(){
        fetchMovieUpcoming()
        fetchMovieNowPlaying()
    }
    
    func refreshPage(){
        collectionViewData.value.removeAll()
        tableViewData.value.removeAll()
        upcomingMoviePageNumber = 1
        nowPlayingMoviePageNumber = 1
        
        fetchMovieUpcoming()
        fetchMovieNowPlaying()
    }
    
    func fetchMoreUpcomingMovie(){
        guard !isFetchingTableViewData.value else { return }
        
        guard upcomingMoviePageNumber < upcomingTotalPageNumber else {
            isFetchingTableViewData.value = false
            return
        }
        
        upcomingMoviePageNumber += 1
        
        fetchMovieUpcoming(pageNumber: upcomingMoviePageNumber)
    }
    
    private func fetchMovieUpcoming(pageNumber: Int = 1){
        guard !isFetchingTableViewData.value else { return }
        
        isFetchingTableViewData.value = true
        
        var upcomingParams = params
        upcomingParams.updateValue(pageNumber, forKey: Constant.TMDBParameters.page)
        
        tmdbService.fetchUpcoming(params: upcomingParams) { response in
            switch response.isSuccess(){
            case true:
                self.updateTableViewData(data: response.data?.results)
                self.upcomingTotalPageNumber = response.data?.totalPages ?? 1
                self.isFetchingTableViewData.value = false
            default:
                self.errorMessage.value = response.errorMessage
                self.isFetchingTableViewData.value = false
            }
        }
    }
    
    func fetchMoreMovieNowPlaying(){
        guard !isFetchingCollectionViewData.value else { return }
        
        guard nowPlayingMoviePageNumber < nowPlayingTotalPageNumber else {
            isFetchingCollectionViewData.value = false
            return
        }
        
        nowPlayingMoviePageNumber += 1
        
        fetchMovieNowPlaying(pageNumber: nowPlayingMoviePageNumber)
    }

    private func fetchMovieNowPlaying(pageNumber: Int = 1){
        guard !isFetchingCollectionViewData.value else { return }
        
        self.isFetchingCollectionViewData.value = true
        
        var upcomingParams = params
        upcomingParams.updateValue(pageNumber, forKey: Constant.TMDBParameters.page)
        print(params)
        
        tmdbService.fetchMovieNowPlaying(params: upcomingParams) { response in
            switch response.isSuccess(){
            case true:
                self.updateSliderData(data: response.data?.results)
                self.nowPlayingTotalPageNumber = response.data?.totalPages ?? 1
                self.isFetchingCollectionViewData.value = false
            default:
                self.errorMessage.value = response.errorMessage
                self.isFetchingCollectionViewData.value = false
            }
        }
    }
    
    private func updateTableViewData(data: [MovieResult]?){
        guard let safeResults = data else {
            errorMessage.value = "Error occured while reading movie data. Please be sure that this movie exist."
            return
        }
        
        let newResults = decodeMovieResult(results: safeResults)
        tableViewData.value += newResults
    }
    
    private func updateSliderData(data: [MovieResult]?){
        guard let safeResults = data else {
            errorMessage.value = "Error occured while reading movie data. Please be sure that this movie exist."
            return
        }
        
        let newResults = decodeMovieResult(results: safeResults, isPosterImage: false)
        collectionViewData.value += newResults
    }
    
    private func decodeMovieResult(results: [MovieResult], isPosterImage:Bool = true) -> [MovieDetail]{
        var movieArray:[MovieDetail] = []
        
        for movie in results{
            var imageURL:URL?
            if isPosterImage{
                if let safePosterPath = movie.posterPath{
                    imageURL = URL(string: URLs.imageUrl + safePosterPath)
                }
            }else{
                if let safePosterPath = movie.backdropPath{
                    imageURL = URL(string: URLs.imageUrl + safePosterPath)
                }
            }
            var title = movie.originalTitle ?? "Title not found"
            let description = movie.overview ?? "Overview not found"
            var releaseDate = "Unkown release date"
            
            if let safeDate = movie.releaseDate{
                let dateArray = safeDate.components(separatedBy: "-")
                let releaseYear = dateArray[0]
                title = "\(title) (\(releaseYear))"
                
                releaseDate = "\(dateArray[2]).\(dateArray[1]).\(dateArray[0])"
            }
            
            let movie = MovieDetail(id: String(movie.id!),imageURL: imageURL, title: title, description: description, releaseDate: releaseDate)
            movieArray.append(movie)
        }
        
        return movieArray
    }
}
