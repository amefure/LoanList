//
//  AdMobViewModel.swift
//  LoanList
//
//  Created by t&a on 2022/12/28.
//

import UIKit
import GoogleMobileAds


class AdMobViewModel: NSObject {
    // MARK: - Admob
    var bannerView: GADBannerView!
    var AdMobBannerId: String {
        return Bundle.main.object(forInfoDictionaryKey: "AdMobBannerId") as! String
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView,view:UIView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
            [NSLayoutConstraint(item: bannerView,
                                attribute: .bottom,
                                relatedBy: .equal,
                                toItem:  view.safeAreaLayoutGuide,
                                attribute: .bottom,
                                multiplier: 1,
                                constant: 0),
             NSLayoutConstraint(item: bannerView,
                                attribute: .centerX,
                                relatedBy: .equal,
                                toItem: view,
                                attribute: .centerX,
                                multiplier: 1,
                                constant: 0)
            ])
    }
    // MARK: - Admob
    func admobInit(vc: UIViewController) {
        // MARK: - Admob
        bannerView = GADBannerView(adSize: GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(vc.view.frame.size.width))
        addBannerViewToView(bannerView, view: vc.view)
        bannerView.adUnitID = AdMobBannerId
        bannerView.rootViewController = vc
        bannerView.load(GADRequest())
        // MARK: - Admob
    }

}
