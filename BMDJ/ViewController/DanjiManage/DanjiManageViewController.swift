//
//  DanjiSortViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/11.
//

import UIKit

import ReactorKit
import RxCocoa
import RxDataSources
import SnapKit

final class DanjiManageViewController: UIViewController, View {
    
    // MARK: - UI Component
    private lazy var topBar: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkClose, for: .normal)
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var barTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "장독대 순서 편짐"
        label.font = .regularBody2
        label.textColor = .font1
        topBar.addSubview(label)
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "장독대를 위 아래로 밀어서\n순서를 바꿔보세요 :)"
        label.font = .semiBoldH2
        label.textColor = .font1
        label.numberOfLines = 2
        view.addSubview(label)
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(DanjiSortTableCell.self, forCellReuseIdentifier: DanjiSortTableCell.identifier)
        tableView.delegate = self
        tableView.setEditing(true, animated: false)
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        return tableView
    }()
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    
    let danjiSortDataSource = RxTableViewSectionedReloadDataSource<DanjiSortSection>(
        configureCell: { _, tableView, indexPath, reactor in
            let cell = tableView.dequeueReusableCell(withIdentifier: DanjiSortTableCell.identifier, for: indexPath) as! DanjiSortTableCell
            cell.reactor = reactor
            return cell
    })

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setLayout()
    }
    
    // MARK: - Method
    func bind(reactor: DanjiSortViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        
        topBar.snp.makeConstraints {
            $0.height.equalTo(44 * AppService.shared.layoutScale)
            $0.left.top.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        barTitleLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.height.equalTo(64 * AppService.shared.layoutScale)
            $0.top.equalTo(topBar.snp.bottom).offset(32 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20 * AppService.shared.layoutScale)
            $0.left.bottom.right.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindAction(_ reactor: DanjiSortViewReactor) {
        closeButton.rx.tap
            .subscribe { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemMoved
            .map(Reactor.Action.move)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: DanjiSortViewReactor) {
        danjiSortDataSource.canEditRowAtIndexPath = { _, _ in true }
        danjiSortDataSource.canMoveRowAtIndexPath = { _, _ in true }
        
        reactor.state.asObservable().map { $0.danjiSortSections }
            .bind(to: tableView.rx.items(dataSource: danjiSortDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.dismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
    }
}

extension DanjiManageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66 * AppService.shared.layoutScale
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}
