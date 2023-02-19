//
//  BDJobTarget.swift
//  BMDJ
//
//  Created by 김진우 on 2023/02/19.
//

enum BDJobTarget {
    case danji(Danji?)
    case memo(Memo?)
}

extension BDJobTarget {
    var description: String {
        switch self {
        case .danji(let danji):
            if let danji {
                return "Danji: \(danji.id)"
            } else {
                return "Danji"
            }
        case .memo(let memo):
            if let memo {
                return "Memo: \(memo.id)"
            } else  {
                return "Memo"
            }
        }
    }
}
