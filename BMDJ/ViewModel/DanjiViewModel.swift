//
//  DanjiViewModel.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/20.
//

import Foundation

import RxSwift
import RxCocoa

final class DanjiViewModel {

    let id: String
    let createDate: Date

    let userID: Observable<String?>
    let color: Observable<Danji.Color?>
    let name: Observable<String?>
    let stock: Observable<Stock?>
    let volume: Observable<String?>
    let mood: Observable<Danji.Mood?>
    let endDate: Observable<Date?>
    let dDay: Observable<Date?>

    let disposeBag = DisposeBag()

    init(danji: Danji) {
        id = danji.id
        createDate = danji.createDate

        DanjiProvider.shared.add(danji)

        let danjiObserver = DanjiProvider.shared.danji(danji)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)

        userID = danjiObserver
            .map { $0.userID }

        color = danjiObserver
            .map { $0.color }

        name = danjiObserver
            .map { $0.name }

        stock = danjiObserver
            .map { $0.stock }

        volume = danjiObserver
            .map { $0.volume }

        mood = danjiObserver
            .map { $0.mood }
        
        endDate = danjiObserver
            .map { $0.endDate }
        
        dDay = danjiObserver
            .map { $0.dDay }
    }
}

