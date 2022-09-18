//
//  BDErrorScenario.swift
//  BMDJ
//
//  Created by 김진우 on 2022/07/03.
//

struct BDErrorNetworkStatus: BDErrorProtocol {
    let code: Int = 408
    let description: String = "인터넷 연결 상태"
    let message: String = "인터넷 연결 상태를 확인해주세요."
    let type: BDErrorType = .network
    let target: BDErrorTarget = .app
}

struct BDErrorAPIRequest: BDErrorProtocol {
    let code: Int = 408
    let description: String = "서버 요청 실패"
    let message: String = "잠시후 다시 시도해 주세요."
    let type: BDErrorType = .request
    let target: BDErrorTarget = .app
}

struct BDErrorAPIResponse: BDErrorProtocol {
    let code: Int = 408
    let description: String = "서버 응답 실패"
    let message: String = "현재 서비스가 원할하지 않습니다."
    let type: BDErrorType = .response
    let target: BDErrorTarget = .server
}

struct BDErrorAPIScheme: BDErrorProtocol {
    let code: Int = 404
    let description: String = "서버 응답 포멧 에러"
    let message: String = "현재 서비스가 원할하지 않습니다."
    let type: BDErrorType = .scheme
    let target: BDErrorTarget = .server
}

struct BDErrorResult: BDErrorProtocol {
    let code: Int = 404
    let description: String = "동작 실패"
    let message: String = "잠시후 다시 시도해 주세요."
    let type: BDErrorType = .scheme
    let target: BDErrorTarget = .server
}

struct BDErrorServer: BDErrorProtocol {
    let code: Int = 500
    let description: String = "서버 응답 없음"
    let message: String = "현재 서비스가 원할하지 않습니다."
    let type: BDErrorType = .server
    let target: BDErrorTarget = .server
}

struct BDErrorETC: BDErrorProtocol {
    let code: Int = 900
    let description: String = "기타 에러"
    let message: String = "앱을 재실행 해주세요."
    let type: BDErrorType = .etc
    let target: BDErrorTarget = .app
}
