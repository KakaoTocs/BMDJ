//
//  BMDJImage.swift
//  BMDJ
//
//  Created by 김진우 on 2021/04/25.
//

import UIKit

enum BMDJImage: String {
    // Logo
    case logo = "logo"
    case appleLogo = "appleLogo"
    case googleLogo = "googleLogo"
    case kakaotalkLogo = "kakaotalkLogo"
    case naverLogo = "naverLogo"
    
    // Button icon
    case ic24BkHamburger = "ic24BkHamburger"
    case ic24BkNotification = "ic24BkNotification"
    case ic24BkShare = "ic24BkShare"
    case ic24GrAdd = "ic24GrAdd"
    case ic24GrMemo = "ic24GrMemo"
    case ic24GrPot = "ic24GrPot"
    case ic24GrSetting = "ic24GrSetting"
    case ic24BkBack = "ic24BkBack"
    case ic24GrSearch = "ic24GrSearch"
    
    case icRefresh = "icRefresh"

    case icSelectCheck = "icSelectCheck"
    
    case ic24BkClose = "ic24BkClose"
    
    case ic40ActiveArrowLeft = "ic40ActiveArrowLeft"
    case ic40InactiveArrowLeft = "ic40InactiveArrowLeft"
    case ic40ActiveArrowRight = "ic40ActiveArrowRight"
    case ic40InactiveArrowRight = "ic40InactiveArrowRight"
    case ic16BkDetailRight = "ic16BkDetailRight"
    
    case ic20Delete = "ic20Delete"
    
    case icBkImg = "icBkImg"
    case detailRight = "detailRight"
    
    case icEdit = "moreIc"
    
    // MARK: - Mood
    case happy = "happy"
    case sad = "sad"
    
    case happy48 = "happy48"
    case sad48 = "sad48"
    case normal48 = "normal48"
    
    // MARK: - Danji
    case potLPurpleWhole = "potLPurpleWhole"
    case potLBlueWhole = "potLBlueWhole"
    case potLRedWhole = "potLRedWhole"
    case potLYellowWhole = "potLYellowWhole"
    case potLGreenWhole = "potLGreenWhole"
    case potGrayWhole = "potGrayWhole"
    
    // MARK: - Weather
    case happyCloud = "happyCloud"
    case happySun = "happySun"
    case sadCloud = "sadCloud"
    case sadRain = "waterDropGroup"
    case emptyTopCloud = "emptyTopCloud"
    case emptyBottomCloud = "emptyBottomCloud"
    
    // MARK: - Pot
    case potBlue = "potSBlue"
    case potGreen = "potSGreen"
    case potPurple = "potSPurple"
    case potRed = "potSRed"
    case potYellow = "potSYellow"
    case potEmtpy = "potEmpty"
    
    // MARK: - Soil
    case emptySoil = "emptySoil"
    
    var image: UIImage? {
        return UIImage(named: self.rawValue)
    }
}

extension UIImage {
    // Logo
    class var logo: UIImage? {
        return BMDJImage.logo.image
    }
    
    class var appleLogo: UIImage? {
        return BMDJImage.appleLogo.image
    }
    
    class var googleLogo: UIImage? {
        return BMDJImage.googleLogo.image
    }
    
    class var kakaotalkLogo: UIImage? {
        return BMDJImage.kakaotalkLogo.image
    }
    
    class var naverLogo: UIImage? {
        return BMDJImage.naverLogo.image
    }
    
    // Button icon
    class var ic24BkHamburger: UIImage? {
        return BMDJImage.ic24BkHamburger.image
    }
    
    class var ic24BkNotification: UIImage? {
        return BMDJImage.ic24BkNotification.image
    }
    
    class var ic24BkShare: UIImage? {
        return BMDJImage.ic24BkShare.image
    }
    
    class var ic24GrAdd: UIImage? {
        return BMDJImage.ic24GrAdd.image
    }
    
    class var ic24GrMemo: UIImage? {
        return BMDJImage.ic24GrMemo.image
    }
    
    class var ic24GrPot: UIImage? {
        return BMDJImage.ic24GrPot.image
    }
    
    class var ic24GrSetting: UIImage? {
        return BMDJImage.ic24GrSetting.image
    }
    
    class var ic24BkClose: UIImage? {
        return BMDJImage.ic24BkClose.image
    }
    
    class var ic24BkBack: UIImage? {
        return BMDJImage.ic24BkBack.image
    }
    
    class var ic40InactiveArrowLeft: UIImage? {
        return BMDJImage.ic40InactiveArrowLeft.image
    }
    
    class var ic40ActiveArrowLeft: UIImage? {
        return BMDJImage.ic40ActiveArrowLeft.image
    }
    
    class var ic40InactiveArrowRight: UIImage? {
        return BMDJImage.ic40InactiveArrowRight.image
    }
    
    class var ic40ActiveArrowRight: UIImage? {
        return BMDJImage.ic40ActiveArrowRight.image
    }
    
    class var ic16BkDetailRight: UIImage? {
        return BMDJImage.ic16BkDetailRight.image
    }
    
    class var ic20Delete: UIImage? {
        return BMDJImage.ic20Delete.image
    }
    
    // MARK: - Mood
    class var happy: UIImage? {
        return BMDJImage.happy.image
    }
    
    class var sad: UIImage? {
        return BMDJImage.sad.image
    }
    
    class var happy48: UIImage? {
        return BMDJImage.happy48.image
    }
    
    class var sad48: UIImage? {
        return BMDJImage.sad48.image
    }
    
    class var normal48: UIImage? {
        return BMDJImage.normal48.image
    }
    // MARK: - Danji
    class var potLPurpleWhole: UIImage? {
        return BMDJImage.potLPurpleWhole.image
    }
    
    class var potLBlueWhole: UIImage? {
        return BMDJImage.potLBlueWhole.image
    }
    
    class var potLRedWhole: UIImage? {
        return BMDJImage.potLRedWhole.image
    }
    
    class var potLYellowWhole: UIImage? {
        return BMDJImage.potLYellowWhole.image
    }
    
    class var potLGreenWhole: UIImage? {
        return BMDJImage.potLGreenWhole.image
    }
    
    class var potGrayWhole: UIImage? {
        return BMDJImage.potGrayWhole.image
    }
    
    // MARK: - Weather
    class var happySun: UIImage? {
        return BMDJImage.happySun.image
    }
    
    class var happyCloud: UIImage? {
        return BMDJImage.happyCloud.image
    }
    
    class var sadCloud: UIImage? {
        return BMDJImage.sadCloud.image
    }
    
    class var sadRain: UIImage? {
        return BMDJImage.sadRain.image
    }
    
    class var emptyTopCloud: UIImage? {
        return BMDJImage.emptyTopCloud.image
    }
    
    class var emptyBottomCloud: UIImage? {
        return BMDJImage.emptyBottomCloud.image
    }
    
    // MARK: - Icon
    class var icBkImg: UIImage? {
        return BMDJImage.icBkImg.image
    }
    
    class var icSelectCheck: UIImage? {
        return BMDJImage.icSelectCheck.image
    }
    
    class var detailRight: UIImage? {
        return BMDJImage.detailRight.image
    }

    class var potBlue: UIImage? {
        return BMDJImage.potBlue.image
    }
    
    class var potGreen: UIImage? {
        return BMDJImage.potGreen.image
    }
    
    class var potPurple: UIImage? {
        return BMDJImage.potPurple.image
    }
    
    class var potRed: UIImage? {
        return BMDJImage.potRed.image
    }
    
    class var potYellow: UIImage? {
        return BMDJImage.potYellow.image
    }
    
    class var potEmpty: UIImage? {
        return BMDJImage.potEmtpy.image
    }
    
    class var icEdit: UIImage? {
        return BMDJImage.icEdit.image
    }
    
    class var search: UIImage? {
        return BMDJImage.ic24GrSearch.image
    }
    
    class var emptySoil: UIImage? {
        return BMDJImage.emptySoil.image
    }
    
    class var refresh: UIImage? {
        return BMDJImage.icRefresh.image
    }
}
