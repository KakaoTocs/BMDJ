//
//  LicenseListViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/09/05.
//

import UIKit

import ReactorKit
import SnapKit

final class LicenseListViewController: UIViewController, View {
    
    typealias Reactor = LicenseListViewReactor
    
    // MARK: - UI Component
    private lazy var topBar: UIView = {
        let view = UIView()
        view.backgroundColor = .background2
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "라이센스 목록"
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
        let tableView = UITableView(frame: .zero, style: .plain)
//        tableView.register(DanjiSortTableCell.self, forCellReuseIdentifier: DanjiSortTableCell.identifier)
//        tableView.delegate = self
//        tableView.setEditing(true, animated: false)
//        tableView.separatorStyle = .none
        view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    // MARK: - LifeCycle
    init(reactor: LicenseListViewReactor) {
        super.init(nibName: nil, bundle: nil)
        
        setLayout()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(reactor: LicenseListViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        view.backgroundColor = .background2
        
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
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    private func bindAction(_ reactor: LicenseListViewReactor) {
        closeButton.rx.tap
            .subscribe { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self)
            .subscribe(onNext: { model in
                self.showLicenseInfo(model)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: LicenseListViewReactor) {
        let libraryList = Observable.of(reactor.currentState.licenses.keys)
        libraryList
            .bind(to: tableView.rx.items) { (tableView: UITableView, index: Int, element: String) in
                let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
                print(element)
                cell.textLabel?.text = element
                
                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func showLicenseInfo(_ text: String) {
        if let reactor = reactor?.reactorForLicenseDetailView(text) {
            let vc = LicenseDetailViewController(reactor: reactor)
            vc.modalPresentationStyle = .fullScreen
            DispatchQueue.main.async {
                self.present(vc, animated: true)
            }
        }
    }
}
