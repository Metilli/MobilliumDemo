//
//  MovieService.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation
import Alamofire

struct TMDBService:TMDBProtocol{
    
    func fetchMovieDetail(movieID: String, params: [String : Any]? = nil, completionHandler: @escaping (NetworkResponseModel<MovieDetailResponse>) -> ()) {
        let urlString = URLs.movieDetail + movieID + "?api_key=" + URLs.apiKey
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, parameters: params).responseData { response in
                let networkResponse = NetworkResponseModel<MovieNowPlayingResponse>(statusCode: response.response?.statusCode ?? 0)
                switch response.result{
                case .success(let data):
                    if networkResponse.isSuccess(){
                        do{
                            let decoder = JSONDecoder()
                            let movieDetail = try decoder.decode(MovieDetailResponse.self, from: data)
                            completionHandler(NetworkResponseModel<MovieDetailResponse>(statusCode: networkResponse.statusCode, data: movieDetail))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieDetailResponse>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }else{
                        do{
                            let decoder = JSONDecoder()
                            let errorData = try decoder.decode(NetworkErrorModel.self, from: data)
                            completionHandler(NetworkResponseModel<MovieDetailResponse>(statusCode: networkResponse.statusCode, errorData: errorData))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieDetailResponse>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }
                case .failure(let error):
                    completionHandler(NetworkResponseModel<MovieDetailResponse>(statusCode: 0, errorMessage: error.errorDescription))
                    break
                }
            }
        }
    }
    
    func fetchMovieNowPlaying(params: [String : Any]? = nil, completionHandler: @escaping (NetworkResponseModel<MovieNowPlayingResponse>) -> ()) {
        let urlString = URLs.nowPlaying
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, parameters: params).responseData { response in
                let networkResponse = NetworkResponseModel<MovieNowPlayingResponse>(statusCode: response.response?.statusCode ?? 0)
                switch response.result{
                case .success(let data):
                    if networkResponse.isSuccess(){
                        do{
                            let decoder = JSONDecoder()
                            let moviewNowPlaying = try decoder.decode(MovieNowPlayingResponse.self, from: data)
                            completionHandler(NetworkResponseModel<MovieNowPlayingResponse>(statusCode: networkResponse.statusCode, data: moviewNowPlaying))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieNowPlayingResponse>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }else{
                        do{
                            let decoder = JSONDecoder()
                            let errorData = try decoder.decode(NetworkErrorModel.self, from: data)
                            completionHandler(NetworkResponseModel<MovieNowPlayingResponse>(statusCode: networkResponse.statusCode, errorData: errorData))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieNowPlayingResponse>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }
                case .failure(let error):
                    completionHandler(NetworkResponseModel<MovieNowPlayingResponse>(statusCode: 0, errorMessage: error.errorDescription))
                    break
                }
            }
        }
    }
    
    func fetchUpcoming(params: [String : Any]? = nil, completionHandler: @escaping (NetworkResponseModel<MovieUpcomingResponse>) -> ()) {
        let urlString = URLs.upcoming
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, parameters: params).responseData { response in
                let networkResponse = NetworkResponseModel<MovieNowPlayingResponse>(statusCode: response.response?.statusCode ?? 0)
                switch response.result{
                case .success(let data):
                    if networkResponse.isSuccess(){
                        do{
                            let decoder = JSONDecoder()
                            let movieUpcoming = try decoder.decode(MovieUpcomingResponse.self, from: data)
                            completionHandler(NetworkResponseModel<MovieUpcomingResponse>(statusCode: networkResponse.statusCode, data: movieUpcoming))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieUpcomingResponse>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }else{
                        do{
                            let decoder = JSONDecoder()
                            let errorData = try decoder.decode(NetworkErrorModel.self, from: data)
                            completionHandler(NetworkResponseModel<MovieUpcomingResponse>(statusCode: networkResponse.statusCode, errorData: errorData))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieUpcomingResponse>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }
                case .failure(let error):
                    completionHandler(NetworkResponseModel<MovieUpcomingResponse>(statusCode: 0, errorMessage: error.errorDescription))
                    break
                }
            }
        }
    }
    
}

