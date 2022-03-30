//
//  MovieService.swift
//  MobilliumDemo
//
//  Created by Metilli on 30.03.2022.
//

import Foundation
import Alamofire

struct TMDBService:TMDBProtocol{
    
    func fetchMovieDetail(movieID: String, params: [String : Any]? = nil, completionHandler: @escaping (NetworkResponseModel<MovieDetail>) -> ()) {
        let urlString = URLs.movieDetail + movieID + "?api_key=" + URLs.apiKey
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, parameters: params).responseData { response in
                let networkResponse = NetworkResponseModel<MovieNowPlaying>(statusCode: response.response?.statusCode ?? 0)
                switch response.result{
                case .success(let data):
                    if networkResponse.isSuccess(){
                        do{
                            let decoder = JSONDecoder()
                            let moviewNowPlaying = try decoder.decode(MovieDetail.self, from: data)
                            completionHandler(NetworkResponseModel<MovieDetail>(statusCode: networkResponse.statusCode, data: moviewNowPlaying))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieDetail>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }else{
                        do{
                            let decoder = JSONDecoder()
                            let errorData = try decoder.decode(NetworkErrorModel.self, from: data)
                            completionHandler(NetworkResponseModel<MovieDetail>(statusCode: networkResponse.statusCode, errorData: errorData))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieDetail>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }
                case .failure(let error):
                    completionHandler(NetworkResponseModel<MovieDetail>(statusCode: 0, errorMessage: error.errorDescription))
                    break
                }
            }
        }
    }
    
    func fetchMovieNowPlaying(params: [String : Any]? = nil, completionHandler: @escaping (NetworkResponseModel<MovieNowPlaying>) -> ()) {
        let urlString = URLs.nowPlaying
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, parameters: params).responseData { response in
                let networkResponse = NetworkResponseModel<MovieNowPlaying>(statusCode: response.response?.statusCode ?? 0)
                switch response.result{
                case .success(let data):
                    if networkResponse.isSuccess(){
                        do{
                            let decoder = JSONDecoder()
                            let moviewNowPlaying = try decoder.decode(MovieNowPlaying.self, from: data)
                            completionHandler(NetworkResponseModel<MovieNowPlaying>(statusCode: networkResponse.statusCode, data: moviewNowPlaying))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieNowPlaying>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }else{
                        do{
                            let decoder = JSONDecoder()
                            let errorData = try decoder.decode(NetworkErrorModel.self, from: data)
                            completionHandler(NetworkResponseModel<MovieNowPlaying>(statusCode: networkResponse.statusCode, errorData: errorData))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieNowPlaying>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }
                case .failure(let error):
                    completionHandler(NetworkResponseModel<MovieNowPlaying>(statusCode: 0, errorMessage: error.errorDescription))
                    break
                }
            }
        }
    }
    
    func fetchUpcoming(params: [String : Any]? = nil, completionHandler: @escaping (NetworkResponseModel<MovieUpcoming>) -> ()) {
        let urlString = URLs.upcoming
        guard let url = URL(string: urlString) else {return}
        
        DispatchQueue.global(qos: .background).async {
            AF.request(url, method: .get, parameters: params).responseData { response in
                let networkResponse = NetworkResponseModel<MovieNowPlaying>(statusCode: response.response?.statusCode ?? 0)
                switch response.result{
                case .success(let data):
                    if networkResponse.isSuccess(){
                        do{
                            let decoder = JSONDecoder()
                            let moviewNowPlaying = try decoder.decode(MovieUpcoming.self, from: data)
                            completionHandler(NetworkResponseModel<MovieUpcoming>(statusCode: networkResponse.statusCode, data: moviewNowPlaying))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieUpcoming>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }else{
                        do{
                            let decoder = JSONDecoder()
                            let errorData = try decoder.decode(NetworkErrorModel.self, from: data)
                            completionHandler(NetworkResponseModel<MovieUpcoming>(statusCode: networkResponse.statusCode, errorData: errorData))
                        }catch{
                            completionHandler(NetworkResponseModel<MovieUpcoming>(statusCode: 0, errorMessage: error.localizedDescription))
                        }
                    }
                case .failure(let error):
                    completionHandler(NetworkResponseModel<MovieUpcoming>(statusCode: 0, errorMessage: error.errorDescription))
                    break
                }
            }
        }
    }
    
}

