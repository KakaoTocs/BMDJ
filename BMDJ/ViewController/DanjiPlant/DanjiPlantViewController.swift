//
//  DanjiPlantViewController.swift
//  BMDJ
//
//  Created by 김진우 on 2021/05/12.
//

import UIKit

import ReactorKit
import RxCocoa
import RxOptional
import RxDataSources
import SnapKit


final class DanjiPlantViewController: UIViewController, View {
    
    private let DANJI_WIDTH_SCALE: CGFloat = 1.26
    
    weak var delegate: MenuViewController?
    
    // MARK: - UI Component
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        return scrollView
    }()
    
    private lazy var contentsView: UIView = {
        let view = UIView()
        scrollView.addSubview(view)
        return view
    }()
    
    private lazy var topBar: UIView = {
        let view = UIView()
        self.view.addSubview(view)
        return view
    }()
    
    private lazy var barTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBody2
        label.text = "장독대 심기"
        topBar.addSubview(label)
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(.ic24BkClose, for: .normal)
        topBar.addSubview(button)
        return button
    }()
    
    private lazy var danjiView: UIView = {
        let view = UIView()
        contentsView.addSubview(view)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semiBoldH2
        label.text = "내 장독대를 원하는 칼라로 Pick!"
        label.sizeToFit()
        danjiView.addSubview(label)
        return label
    }()
    
    private lazy var danjiImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .potLPurpleWhole
        danjiView.addSubview(imageView)
        return imageView
    }()
    
    private lazy var colorLabel: UILabel = {
        let label = UILabel()
        label.text = "색상"
        label.font = .semiBoldBody2
        danjiView.addSubview(label)
        return label
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 24 * AppService.shared.layoutScale
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = .init(width: 40 * AppService.shared.layoutScale, height: 40 * AppService.shared.layoutScale)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(ColorCollectionCell.self, forCellWithReuseIdentifier: ColorCollectionCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        danjiView.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var infoView: UIView = {
        let view = UIView()
        contentsView.addSubview(view)
        return view
    }()
    
    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "장독대 애칭"
        label.font = .semiBoldBody2
        infoView.addSubview(label)
        return label
    }()
    
    private lazy var nicknameTextField: BMDJTextField = {
        let textField = BMDJTextField()
        textField.placeholder = "나만의 장독대 애칭을 입력해주세요"
        infoView.addSubview(textField)
        return textField
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "보유 주식명"
        label.font = .semiBoldBody2
        infoView.addSubview(label)
        return label
    }()
    
    private lazy var nameTextField: BMDJTextField = {
        let textField = BMDJTextField()
        textField.placeholder = "ex) 삼성전자"
        infoView.addSubview(textField)
        return textField
    }()
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = "보유 수량"
        label.font = .semiBoldBody2
        infoView.addSubview(label)
        return label
    }()
    
    private lazy var countField: BMDJTextField = {
        let textField = BMDJTextField()
        textField.keyboardType = .decimalPad
        textField.placeholder = "소수점 둘째자리까지 입력이 가능합니다"
        infoView.addSubview(textField)
        return textField
    }()
    
    private lazy var moodView: UIView = {
        let view = UIView()
        contentsView.addSubview(view)
        return view
    }()
    
    private lazy var moodTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "기분 설정"
        label.font = .semiBoldBody2
        moodView.addSubview(label)
        return label
    }()
    
    private lazy var moodDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "주식의 장에 따라 기분을 바꿀 수 있어요"
        label.font = .regularBody2
        moodView.addSubview(label)
        return label
    }()
    
    private lazy var moodSwitch: BMDJMoodSwitch = {
        let `switch` = BMDJMoodSwitch()
        `switch`.isOn = true
        moodView.addSubview(`switch`)
        return `switch`
    }()
    
    private lazy var moodLabel: UILabel = {
        let label = UILabel()
        label.text = "맑음"
        label.font = .boldH2
        label.textColor = .font1
        moodView.addSubview(label)
        return label
    }()
    
    private lazy var dDayView: UIView = {
        let view = UIView()
        contentsView.addSubview(view)
        return view
    }()
    
    private lazy var ddayLabel: UILabel = {
        let label = UILabel()
        label.text = "D-Day 설정"
        label.font = .semiBoldBody2
        dDayView.addSubview(label)
        return label
    }()

    private lazy var ddayCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .init(top: 0, left: 20 * AppService.shared.layoutScale, bottom: 0, right: 20 * AppService.shared.layoutScale)
        flowLayout.minimumLineSpacing = 16 * AppService.shared.layoutScale
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = .init(width: 90 * AppService.shared.layoutScale, height: 50 * AppService.shared.layoutScale)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.register(DayCollectionCell.self, forCellWithReuseIdentifier: DayCollectionCell.identifier)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        dDayView.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 4 * AppService.shared.layoutScale
        button.backgroundColor = .font5
        button.setTitle("저장하기", for: .normal)
        button.setTitleColor(.font2, for: .disabled)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldBody2
        button.isEnabled = false
        dDayView.addSubview(button)
        return button
    }()
    
    private lazy var colorDataSource = RxCollectionViewSectionedReloadDataSource<ColorSection>(
        configureCell: { _, collectionView, indexPath, reactor in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCollectionCell.identifier, for: indexPath) as! ColorCollectionCell
            cell.reactor = reactor
            if self.defaultSelectColorIsFirst,
               indexPath.item == self.defaultSelectColorIndex {
                cell.isSelected = true
            }
            return cell
        })
    
    private lazy var dayDataSource = RxCollectionViewSectionedReloadDataSource<DaySection>(
        configureCell: { _, collectionView, indexPath, reactor in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayCollectionCell.identifier, for: indexPath) as! DayCollectionCell
            cell.reactor = reactor
            if self.defaultSelectDayIsFirst,
               indexPath.item == self.defaultSelectDayIndex {
                cell.isSelected = true
            }
            return cell
        })
    
    // MARK: - Property
    var disposeBag = DisposeBag()
    let defaultSelectColorIndex = 4
    var defaultSelectColorIsFirst = true
    let defaultSelectDayIndex = 0
    var defaultSelectDayIsFirst = true

    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        colorCollectionView.selectItem(at: IndexPath(item: 4, section: 0), animated: false, scrollPosition: .top)
    }

    // MARK: - Method
    func bind(reactor: DanjiPlantViewReactor) {
        setLayout()
        
        bindAction(reactor)
        bindState(reactor)
    }
    
    private func setLayout() {
        view.backgroundColor = .white
        danjiView.backgroundColor = .white
        contentsView.backgroundColor = .line
        infoView.backgroundColor = .white
        moodView.backgroundColor = .white
        dDayView.backgroundColor = .white
        
        topBar.snp.makeConstraints {
            $0.height.equalTo(44 * AppService.shared.layoutScale)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }

        barTitleLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.center.equalToSuperview()
        }

        closeButton.snp.makeConstraints {
            $0.width.height.equalTo(40 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-12 * AppService.shared.layoutScale)
            $0.centerY.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(topBar.snp.bottom)
            $0.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            $0.right.equalTo(view.safeAreaLayoutGuide.snp.right)
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.left.bottom.right.equalToSuperview()
        }

        danjiView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(451 * AppService.shared.layoutScale)
            $0.top.left.right.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.height.equalTo(32 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(24 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }

        danjiImageView.snp.makeConstraints {
            $0.width.equalTo(danjiImageView.snp.height).multipliedBy(DANJI_WIDTH_SCALE)
            $0.height.equalTo(200 * AppService.shared.layoutScale)
            $0.top.equalTo(titleLabel.snp.bottom).offset(32 * AppService.shared.layoutScale)
            $0.centerX.equalToSuperview()
        }

        colorLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalTo(danjiImageView.snp.bottom).offset(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }

        colorCollectionView.snp.makeConstraints {
            $0.height.equalTo(54 * AppService.shared.layoutScale)
            $0.top.equalTo(colorLabel.snp.bottom).offset(10 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-40 * AppService.shared.layoutScale)
        }

        infoView.snp.makeConstraints {
            $0.height.equalTo(353 * AppService.shared.layoutScale)
            $0.top.equalTo(danjiView.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.right.equalToSuperview()
        }

        nicknameLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }

        nicknameTextField.snp.makeConstraints {
            $0.height.equalTo(48 * AppService.shared.layoutScale)
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }

        nameLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalTo(nicknameTextField.snp.bottom).offset(24 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }

        nameTextField.snp.makeConstraints {
            $0.height.equalTo(48 * AppService.shared.layoutScale)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
        }

        countLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalTo(nameTextField.snp.bottom).offset(24 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }

        countField.snp.makeConstraints {
            $0.height.equalTo(48 * AppService.shared.layoutScale)
            $0.top.equalTo(countLabel.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-40 * AppService.shared.layoutScale)
        }

        moodView.snp.makeConstraints {
            $0.height.equalTo(172 * AppService.shared.layoutScale)
            $0.top.equalTo(infoView.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.right.equalToSuperview()
        }

        moodTitleLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }

        moodDescriptionLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalTo(moodTitleLabel.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }

        moodSwitch.snp.makeConstraints {
            $0.width.equalTo(60 * AppService.shared.layoutScale)
            $0.height.equalTo(30 * AppService.shared.layoutScale)
            $0.top.equalTo(moodDescriptionLabel.snp.bottom).offset(24 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-32 * AppService.shared.layoutScale)
        }

        moodLabel.snp.makeConstraints {
            $0.height.equalTo(29 * AppService.shared.layoutScale)
            $0.left.equalTo(moodSwitch.snp.right).offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.centerY.equalTo(moodSwitch)
        }

        dDayView.snp.makeConstraints {
            $0.height.equalTo(257 * AppService.shared.layoutScale)
            $0.top.equalTo(moodView.snp.bottom).offset(8 * AppService.shared.layoutScale)
            $0.left.bottom.right.equalToSuperview()
        }

        ddayLabel.snp.makeConstraints {
            $0.height.equalTo(19 * AppService.shared.layoutScale)
            $0.top.equalToSuperview().offset(40 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
        }

        ddayCollectionView.snp.makeConstraints {
            $0.height.equalTo(74 * AppService.shared.layoutScale)
            $0.top.equalTo(ddayLabel.snp.bottom).offset(12 * AppService.shared.layoutScale)
            $0.left.right.equalToSuperview()
        }

        saveButton.snp.makeConstraints {
            $0.height.equalTo(60 * AppService.shared.layoutScale)
            $0.top.equalTo(ddayCollectionView.snp.bottom).offset(28 * AppService.shared.layoutScale)
            $0.left.equalToSuperview().offset(20 * AppService.shared.layoutScale)
            $0.right.equalToSuperview().offset(-20 * AppService.shared.layoutScale)
            $0.bottom.equalToSuperview().offset(-24 * AppService.shared.layoutScale)
        }
    }
    
    private func bindAction(_ reactor: DanjiPlantViewReactor) {
        closeButton.rx.tap
            .subscribe { _ in
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            .disposed(by: disposeBag)
        
        colorCollectionView.rx.modelSelected(ColorCollectionCellReactor.self)
            .map { $0.currentState.color }
            .map { Reactor.Action.selectColor($0) }
            .do(onNext: { _ in
                print("SSelect: ")
                self.defaultSelectColorIsFirst = false
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        colorCollectionView.rx.itemSelected
//            .subscribe(onNext: { indexPath in
//                print("Select: \(indexPath.item)")
//                self.colorCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
//            })
//            .disposed(by: disposeBag)
        
        nicknameTextField.rx.text
            .filterNil()
            .skip(1)
            .map(Reactor.Action.updateDanjiName)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nameTextField.rx.text
            .filterNil()
            .skip(1)
            .map(Reactor.Action.updateStockName)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        countField.rx.text
            .filterNil()
            .skip(1)
            .map(Reactor.Action.updateStockQuantity)
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        moodSwitch.rx.controlEvent(.valueChanged)
            .map { self.moodSwitch.isOn ? Danji.Mood.happy : Danji.Mood.sad }
            .map { Reactor.Action.changeMood($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ddayCollectionView.rx.modelSelected(DayCollectionCellReactor.self)
            .map { $0.currentState.day }
            .map { Reactor.Action.selectDday($0) }
            .do(onNext: { _ in
                self.defaultSelectDayIsFirst = false
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        ddayCollectionView.rx.itemSelected
            .subscribe(onNext: { indexPath in
                self.ddayCollectionView.selectItem(at: indexPath, animated: false, scrollPosition: .top)
            })
            .disposed(by: disposeBag)
        
        saveButton.rx.tap
            .do(onNext: { _ in
                let vc = IndicatorViewController()
                self.view.addSubview(vc.view)
            })
            .map { Reactor.Action.plant }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(_ reactor: DanjiPlantViewReactor) {
        reactor.state.asObservable().map { $0.colorSections }
            .filter { _ in self.defaultSelectColorIsFirst }
            .bind(to: colorCollectionView.rx.items(dataSource: colorDataSource))
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.daySections }
            .bind(to: ddayCollectionView.rx.items(dataSource: dayDataSource))
            .disposed(by: disposeBag)
        
        
        reactor.state.asObservable().map { $0.danjiCreate.color }
            .map { $0.image }
            .bind(to: danjiImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.danjiCreate.mood }
            .map { $0.descriptin }
            .bind(to: moodLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.canPlant }
            .do(onNext: { canPlant in
                if canPlant {
                    self.saveButton.backgroundColor = .primary
                } else {
                    self.saveButton.backgroundColor = .font5
                }
            })
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.asObservable().map { $0.dismiss }
            .distinctUntilChanged()
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.delegate?.isDismiss = true
                self?.dismiss(animated: false)
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        let topOffset = infoView.frame.minY + nicknameLabel.frame.minY
        scrollView.setContentOffset(.init(x: 0, y: topOffset), animated: true)
    }
}
