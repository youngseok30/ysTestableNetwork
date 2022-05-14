//
//  ysTestableNetworkTests.swift
//  ysTestableNetworkTests
//
//  Created by Ethan Lee on 2022/05/13.
//

import XCTest
@testable import ysTestableNetwork

class ysTestableNetworkTests: XCTestCase {
    
    var sut: MovieListApiService!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = MovieListApiService(networkService: NetworkService(isStub: true))
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    func test_fetchMovieList() {
        let expectation = XCTestExpectation()
        
        let query = "Meet the Maker: Umberto Lenzi on Almost Human"
        let page = 1
        let expectedMovieList = APIEndpoints.movieList(query, page)
            .sampleData.decoded(type: MoviesPage.self)
        
        XCTAssertTrue(expectedMovieList != nil)
        
        sut.fetchMovieList(query: query, page: page)
            .subscribe({ result in
                switch result {
                case .success(let result):
                    XCTAssertEqual(expectedMovieList?.movies, result.movies)
                case .failure(let error):
                    print(error)
                    XCTAssertTrue(false)
                }
                                
                expectation.fulfill()
            })
            .dispose()

        wait(for: [expectation], timeout: 5.0)
    }

}
