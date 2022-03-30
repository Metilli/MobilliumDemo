//
//  HomeViewModel.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

class HomeViewModel{
    
    let sliderData: ObservableObject<[MovieDetail]?> = ObservableObject(nil)
    let tableViewData: ObservableObject<[MovieDetail]?> = ObservableObject([])
    let errorMessage: ObservableObject<String?> = ObservableObject(nil)
    
    let tmdbService = TMDBService()
    let params: [String : Any] = [Constant.TMDBParameters.language : "en-US",
                                 Constant.TMDBParameters.adult : false]
    
    var isFetchingTableViewData = false
    var upcomingMoviePageNumber = 1
    
    init(){
        fetchMovieUpcoming()
        fetchMovieNowPlaying()
    }
    
    func refreshPage(){
        sliderData.value = nil
        tableViewData.value = nil
        upcomingMoviePageNumber = 1
        
        fetchMovieUpcoming()
        fetchMovieNowPlaying()
    }
    
    func fetchMoreUpcomingMovie(){
        upcomingMoviePageNumber += 1
        
        fetchMovieUpcoming(pageNumber: upcomingMoviePageNumber)
    }
    
    private func fetchMovieUpcoming(pageNumber: Int = 1){
        guard !isFetchingTableViewData else { return }
        
        isFetchingTableViewData = true
        
        var upcomingParams = params
        upcomingParams.updateValue(pageNumber, forKey: Constant.TMDBParameters.page)
        
        tmdbService.fetchUpcoming(params: upcomingParams) { response in
            switch response.isSuccess(){
            case true:
                self.updateTableViewData(data: response.data?.results)
                self.isFetchingTableViewData = false
            default:
                self.errorMessage.value = response.errorMessage
                self.isFetchingTableViewData = false
            }
        }
    }

    private func fetchMovieNowPlaying(){
        tmdbService.fetchMovieNowPlaying(params: params) { response in
            switch response.isSuccess(){
            case true:
                self.updateSliderData(data: response.data?.results)
            default:
                self.errorMessage.value = response.errorMessage
            }
        }
    }
    
    private func updateTableViewData(data: [MovieResult]?){
        guard let safeResults = data else {
            errorMessage.value = "Error occured while reading movie data. Please be sure that this movie exist."
            return
        }
        
        let newResults = decodeMovieResult(results: safeResults)
        tableViewData.value? += newResults
    }
    
    private func updateSliderData(data: [MovieResult]?){
        guard let safeResults = data else {
            errorMessage.value = "Error occured while reading movie data. Please be sure that this movie exist."
            return
        }
        
        sliderData.value = decodeMovieResult(results: safeResults)
    }
    
    private func decodeMovieResult(results: [MovieResult]) -> [MovieDetail]{
        var movieArray:[MovieDetail] = []
        
        for movie in results{
            var imageURL:URL?
            if let safePosterPath = movie.posterPath{
                imageURL = URL(string: URLs.imageUrl + safePosterPath)
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
            
            let movie = MovieDetail(imageURL: imageURL, title: title, description: description, releaseDate: releaseDate)
            movieArray.append(movie)
        }
        
        return movieArray
    }
}
