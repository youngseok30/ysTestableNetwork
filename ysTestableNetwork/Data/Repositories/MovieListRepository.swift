//
//  MovieListRepository.swift
//  ysTestableNetwork
//
//  Created by Ethan Lee on 2022/05/14.
//

import Foundation
import RxSwift

protocol MovieListRepository {
    @discardableResult
    func fetchMovieList(query: String?, page: Int) -> Single<MoviesPage>
    
}

class MovieListApiService: MovieListRepository {
    private let networkService: NetworkService!
    
    required init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func fetchMovieList(query: String?, page: Int) -> Single<MoviesPage> {
        return networkService.request(type: MoviesPage.self, target: .movieList(query ?? "", page))
    }
    
}
