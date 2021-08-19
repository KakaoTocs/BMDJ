//
//  BaseService.swift
//  BMDJ
//
//  Created by 김진우 on 2021/06/29.
//

class BaseService {
    unowned let provider: ServiceProviderType
    
    init(provider: ServiceProviderType) {
        self.provider = provider
    }
}
