//
//  MovieDetailViewModel.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation

class MovieDetailViewModel{
    
    private var movieDetail: MovieDetail!
    
    private let tmdbService = TMDBService()
    private let params: [String : Any] = [Constant.TMDBParameters.language : "en-US"]
    
    let errorMessage: ObservableObject<String?> = ObservableObject(nil)
    
    let moviePosterURL: ObservableObject<URL?> = ObservableObject(nil)
    let movieTitle: ObservableObject<String?> = ObservableObject(nil)
    let movieDescription: ObservableObject<String?> = ObservableObject(nil)
    let movieRate: ObservableObject<String?> = ObservableObject(nil)
    let movieReleaseDate: ObservableObject<String?> = ObservableObject(nil)
    
    init(movieID: String){
        fetchMovieDetail(movieID: movieID)
    }
    
    private func fetchMovieDetail(movieID: String){
        guard movieID.isEmpty else {
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
    
    private func fillMovieDetails(data: MovieDetail?){
        guard let safeMovie = data else {
            errorMessage.value = "Error occured while reading movie data. Please be sure that this movie exist."
            return
        }
        
        movieDetail = safeMovie
        if let safePosterPath = movieDetail.posterPath{
            moviePosterURL.value = URL(string: safePosterPath)
        }
        movieTitle.value = movieDetail.originalTitle ?? "Title not found"
        movieDescription.value = movieDetail.overview ?? "Overview not found"
        movieRate.value = (movieDetail.voteAverage != nil) ? String(movieDetail.voteAverage!) : "-"
        movieReleaseDate.value = movieDetail.releaseDate ?? "Unkown release date"
        
    }
}
