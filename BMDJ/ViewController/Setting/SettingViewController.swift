//
//  Danji=ViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/16.
//

import UIKit
import MessageUI

import ReactorKit
import RxCocoa
import RxDataSources
import SnapKit

final class SettingViewController: UIViewController, View {
    
    // MARK: - UI Component
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .background2
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "설정"
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
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .background2
        tableView.separatorColor = .init(hex: 0xEFEFEF)
        tableView.delegate = self
        tableView.register(SettingTitleHeader.self, forHeaderFooterViewReuseIdentifier: SettingTitleHeader.identifier)
        tableView.register(SettingTableCell.self, forCellReuseIdentifier: SettingTableCell.identifier)
        view.addSubview(tableView)
        return tableView
    }()
    
    var disposeBag = DisposeBag()
    let settingDataSource = RxTableViewSectionedReloadDataSource<SettingSection> { ( _, tableView, indexPath, reactor) -> UITableViewCell in
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableCell.identifier, for: indexPath) as! SettingTableCell
        cell.reactor = reactor
        return cell
    }
    
    // MARK: - LifeCycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setLayout()
    }
    
    func bind(reactor: SettingViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // MARK: - Private Method
    private func setLayout() {
        view.backgroundColor = .background2
        
        topBar.snp.makeConstraints {
            $0.height.height.equalTo(44 * AppService.shared.layoutScale)
            $0.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    private func bindAction(_ reactor: SettingViewReactor) {
        closeButton.rx.tap
            .subscribe { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: SettingViewReactor) {
        reactor.state.asObservable().map { $0.settingSections }
            .bind(to: tableView.rx.items(dataSource: settingDataSource))
            .disposed(by: disposeBag)
    }
    
    private func showPrivacyPolicy() {
        let vc = PrivacyPolicyViewController(reactor: .init())
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
    
    private func showLicenseList() {
        let vc = LicenseListViewController(reactor: .init())
        vc.modalPresentationStyle = .fullScreen
        DispatchQueue.main.async {
            self.present(vc, animated: true)
        }
    }
    
    private func withdrawal() {
        AuthClient.shared.withdrawal(token: "")
            .subscribe(onNext: { result in
                if result {
                    print("탈퇴 완료")
                    UserDefaultService.shared.removeToken()
                    let loginVC = LoginViewController()
                    loginVC.reactor = AppDependency.resolve().loginViewReactor
                    UIApplication.shared.keyWindow?.rootViewController = loginVC
                } else {
                    print("탈퇴 실패")
                }
            })
            .disposed(by: disposeBag)
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingTitleHeader.identifier) as! SettingTitleHeader
        let title = reactor?.currentState.settingSections[section].model ?? ""
        header.reactor = .init(dependency: .init(), payload: .init(title: title))
        return header
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case 0, 1 where indexPath.item == 0:
            return false
        default:
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1 where indexPath.item == 1:
            let mailComposeVC = configuredMailComposeViewController()
            if MFMailComposeViewController.canSendMail() {
                present(mailComposeVC, animated: true, completion: nil)
            } else {
                self.showSendMailErrorAlert()
            }
        case 2 where indexPath.item == 0:
            showPrivacyPolicy()
        case 3:
            showLicenseList()
        case 4:
            withdrawal()
        default:
            return
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53 * AppService.shared.layoutScale
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 67 * AppService.shared.layoutScale
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate {
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["stockdanji@gmail.com"])
        mailVC.setSubject("단지에 대해 궁금한게 있어요")
        mailVC.setMessageBody("단지를 깨고 싶으신가요??", isHTML: false)
        
        return mailVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "메일 전송 실패", message: "Mail 앱의 계정 상태를 확인 해주세요.", delegate: self, cancelButtonTitle: "확인")
        sendMailErrorAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
