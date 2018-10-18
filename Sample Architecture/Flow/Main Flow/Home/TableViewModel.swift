//
//  TableViewModel.swift
//  Sample Architecture
//
//  Created by Fathony Teguh Irawan on 17/10/18.
//  Copyright © 2018 Fathony Teguh Irawan. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

class TableViewModel: ViewModel {
    
    struct Input {
        
    }
    
    struct Output {
        let posts: Driver<[Post]>
        let errorMessages: Driver<String>
    }
    
    private let postRepostory: PostRepository
    private let disposeBag = DisposeBag()
    
    init(_ postRepository: PostRepository) {
        self.postRepostory = postRepository
    }
    
    func transform(input: TableViewModel.Input) -> TableViewModel.Output {
        let posts = BehaviorRelay<[Post]>(value: [])
        let errorMessages = BehaviorRelay<String>(value: "")
        
        self.postRepostory.getAllPost()
            .subscribe { (result) in
                switch result {
                case .next(let model):
                    posts.accept(model)
                    break
                case .error(let error):
                    errorMessages.accept(error.localizedDescription)
                    break
                default:
                    break
                }
        }.disposed(by: disposeBag)
        
        return Output(posts: posts.asDriver(), errorMessages: errorMessages.asDriver().skip(1))
    }
}