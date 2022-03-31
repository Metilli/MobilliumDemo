//
//  MovieDetailViewModel.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

class MovieDetailViewModel{
    
    private var movieDetailResponse: MovieDetailResponse!
    
    private let tmdbService = TMDBService()
    private let params: [String : Any] = [Constant.TMDBParameters.language : "en-US"]
    
    let errorMessage: ObservableObject<String?> = ObservableObject(nil)
    
    let moviePosterURL: ObservableObject<URL?> = ObservableObject(nil)
    let movieTitle: ObservableObject<String> = ObservableObject("")
    let movieDescription: ObservableObject<String> = ObservableObject("")
    let movieRate: ObservableObject<String> = ObservableObject("")
    let movieReleaseDate: ObservableObject<String> = ObservableObject("")
    let movieimdbID: ObservableObject<String> = ObservableObject("")
    
    init(movieID: String){
        fetchMovieDetail(movieID: movieID)
    }
    
    private func fetchMovieDetail(movieID: String){
        guard !movieID.isEmpty else {
            errorMessage.value = "Movie ID could not found."
            return
        }
        
        tmdbService.fetchMovieDetail(movieID: movieID, params: params) { response in
            switch response.isSuccess(){
            case true:
                self.fillMovieDetails(data: response.data)
            default:
                self.errorMessage.value = response.errorMessage
            }
        }
    }
    
    private func fillMovieDetails(data: MovieDetailResponse?){
        guard let safeMovie = data else {
            errorMessage.value = "Error occured while reading movie data. Please be sure that this movie exist."
            return
        }
        
        movieDetailResponse = safeMovie
        if let safePosterPath = movieDetailResponse.backdropPath{
            moviePosterURL.value = URL(string: URLs.imageUrl + safePosterPath)
        }
        movieTitle.value = movieDetailResponse.originalTitle ?? "Title not found"
        movieDescription.value = movieDetailResponse.overview ?? "Overview not found"
        movieRate.value = (movieDetailResponse.voteAverage != nil) ? String(movieDetailResponse.voteAverage!) : "-"
        var releaseDate = "Unkown release date"
        
        if let safeDate = movieDetailResponse.releaseDate{
            let dateArray = safeDate.components(separatedBy: "-")
            let releaseYear = dateArray[0]
            movieTitle.value = "\(movieTitle.value) (\(releaseYear))"
            
            releaseDate = "\(dateArray[2]).\(dateArray[1]).\(dateArray[0])"
        }
        movieReleaseDate.value = releaseDate
        movieimdbID.value = safeMovie.imdbID ?? ""
    }
}
