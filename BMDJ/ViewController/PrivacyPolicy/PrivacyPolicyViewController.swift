//
//  PrivacyPolicyViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/08/01.
//

import UIKit

import ReactorKit
import SnapKit

final class PrivacyPolicyViewController: UIViewController, View {
    
    typealias Reactor = PrivacyPolicyReactor
    
    // MARK: - UI Component
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .background2
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보 처리방침"
        label.font = .regularBody2
        topBar.addSubview(label)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkClose, for: .normal)
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .regularBody3
        textView.text = text
        textView.backgroundColor = .background2
        textView.isEditable = false
        view.addSubview(textView)
        return textView
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    init(reactor: PrivacyPolicyReactor) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .background2
        setLayout()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: PrivacyPolicyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        topBar.snp.makeConstraints {
            $0.height.equalTo(44 * AppService.shared.layoutScale)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.right.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom).offset(20 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.bottom.right.equalTo(view.safeAreaLayoutGuide).offset(-20 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: PrivacyPolicyReactor) {
        closeButton.rx.tap
            .subscribe(onNext: { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: PrivacyPolicyReactor) {
        
    }
}

extension PrivacyPolicyViewController {
    private var text: String {
        return """
        보물단지 은(는) 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다.

        보물단지 은(는) 개인정보처리방침을 개정하는 경우 수집된 이메일 주소에 개별공지를 통하여 공지할 것입니다.

        ○ 본 방침은부터 2021년 8월 1일부터 시행됩니다.

        제1조 (개인정보의 처리 목적)

        보물단지 은(는) 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를 구할 예정입니다.

        어플리케이션 회원가입 및 관리: 회원 가입의사 확인, 어플리케이션 내 서비스 제공에 따른 본인 식별·인증 등을 목적으로 개인정보를 처리합니다.

        공유 서비스 제공: 공유 서비스 제공 등을 목적으로 개인정보를 처리합니다.

        제2조 (개인정보 파일 현황)

        개인정보 항목 : 이메일

        수집방법 : 생성정보 수집 툴을 통한 수집

        보유근거 : 회원정보식별

        보유기간 : 서비스 탈퇴 이전

        제3조 (개인정보의 처리 및 보유 기간)

        ① 보물단지 은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집시에 동의 받은 개인정보 보유,이용기간 내에서 개인정보를 처리,보유합니다.

        ② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.

        (어플리케이션 회원가입 및 관리)

        어플리케이션 회원가입 및 관리와 관련한 개인정보는 수집.이용에 관한 동의일로부터<서비스 탈퇴 이전>까지 회원정보 식별을 위하여 보유.이용됩니다.

        (재화 또는 서비스 제공)

        재화 또는 서비스 제공과 관련한 개인정보는 수집.이용에 관한 동의일로부터<서비스 탈퇴 이전>까지 공유 서비스 제공 목적을 위하여 보유.이용됩니다.

        제4조 (권리)

        정보주체와 법정대리인의 권리·의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.

        개인정보 열람요구

        오류 등이 있을 경우 정정 요구

        삭제요구

        처리정지 요구

        제5조 (처리하는 개인정보의 항목 작성)

        ① 보물단지 은(는) 다음의 개인정보 항목을 처리하고 있습니다.

        (어플리케이션 회원가입 및 관리)

        필수항목 : 이메일
        (재화 또는 서비스 제공)

        필수항목 : 이메일
        제6조 (파기)

        보물단지 은(는) 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

        -파기절차

        이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.

        -파기기한

        이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.

        제7조 (개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항)

        보물단지 은(는) 정보주체의 이용정보를 저장하고 수시로 불러오는 ‘쿠키’를 사용하지 않습니다.

        제8조 (개인정보 보호책임자)

        ① 보물단지 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

        개인정보 보호책임자 연락처 : stockdanji@gmail.com

        ② 정보주체께서는 보물단지의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 보물단지 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.

        제9조 (개인정보 처리방침 변경)

        ①이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.

        추가 문의사항 연락처 : stockdanji@gmail.com
        """
    }
}