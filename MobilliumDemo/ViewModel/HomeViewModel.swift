//
//  HomeViewModel.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

class HomeViewModel{
    
    let sliderData: ObservableObject<MovieNowPlaying?> = ObservableObject(nil)
    let tableViewData: ObservableObject<MovieUpcoming?> = ObservableObject(nil)
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
                self.tableViewData.value = response.data
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
                self.sliderData.value = response.data
            default:
                self.errorMessage.value = response.errorMessage
            }
        }
    }
}
