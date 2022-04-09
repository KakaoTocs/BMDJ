//
//  DanjiSettingViewReactor.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/16.
//

import Foundation

import ReactorKit
import RxDataSources

typealias SettingSection = SectionModel<String, SettingTableCellReactor>

final class SettingViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        let settingSections: [SettingSection] = [
            SettingSection(model: "서비스 설정", items: [
                SettingTableCellReactor(state: .init(name: "알림", value: nil, isSwitch: true))
            ]),
//            SettingSection(model: "백업 설정", items: [
//                SettingTableCellReactor(state: .init(name: "백업하기", value: nil, isSwitch: false)),
//                SettingTableCellReactor(state: .init(name: "백업받기", value: nil, isSwitch: false))
//            ]),
            SettingSection(model: "고객지원", items: [
                SettingTableCellReactor(state: .init(name: "버전정보", value: AppService.shared.version, isSwitch: false)),
                SettingTableCellReactor(state: .init(name: "문의하기", value: nil, isSwitch: false))
            ]),
            SettingSection(model: "서비스 약관", items: [
                SettingTableCellReactor(state: .init(name: "개인정보 처리방침", value: nil, isSwitch: false))
            ]),
            SettingSection(model: "라이센스 정보", items: [
                SettingTableCellReactor(state: .init(name: "라이센스 목록", value: nil, isSwitch: false))
            ]),
            SettingSection(model: "계정", items: [
                SettingTableCellReactor(state: .init(name: "서비스 탈퇴", value: nil, isSwitch: false))
            ])
        ]
    }
    
    let initialState: State
    
    init() {
        initialState = State()
    }
}
