//
//  GifCellView.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/26/22.
//

import UIKit
import AVKit
import WebKit
import SnapKit

class GifCellView: UICollectionViewCell, CellConfigurable {
  
  var model                  : GifObject?
  static let reuseIdentifier = "GifCellView"
  private let padding        : CGFloat = 20
  private var isLoaded       = false
  
  private var gifView: WKWebView = {
    let webConfiguration = WKWebViewConfiguration()
    webConfiguration.allowsInlineMediaPlayback = true
    webConfiguration.mediaTypesRequiringUserActionForPlayback = []
    let view = WKWebView(frame: .zero, configuration: webConfiguration)
    return view
  }()
  
  private var titleLabel: UILabel = {
    let label             = UILabel()
    label.backgroundColor = .clear
    label.textColor       = .systemBlack
    label.textAlignment   = .left
//    label.numberOfLines   = 0
    label.font            = UIFont.systemFont(ofSize: 32, weight: .regular)
    label.lineBreakMode = .byTruncatingTail
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    loadSubviews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    loadSubviews()
  }
  
  func setUp<T>(data: T) {
    DispatchQueue.main.async {
      if self.isLoaded {
        return
      }
      guard let data = data as? GifObject else { return }
      self.model = data
      self.titleLabel.text = data.title
      let html = "<img src=\"\(data.images.fixed_height.url)\" width=\"100%\">"
      self.gifView.loadHTMLString(html, baseURL: nil)
      self.isLoaded = true
    }
  }
  
  private func loadSubviews() {
    addSubview(gifView)
    addSubview(titleLabel)
    addAllConstaints()
  }
  
  private func addAllConstaints() {
    gifView.snp.makeConstraints { make in
      make.leading.equalTo(contentView).offset(padding)
      make.top.equalTo(contentView)
      make.bottom.equalTo(contentView)
      make.height.equalTo(contentView.frame.height)
      make.width.equalTo(contentView.frame.height)
    }
    
    titleLabel.snp.updateConstraints { make in
      make.left.equalTo(gifView.snp_rightMargin).offset(padding)
//      make.width.equalTo(contentView)
      make.trailing.equalTo(contentView)//.offset(20)//.offset(-\padding)
      make.bottom.equalTo(contentView)
      make.top.equalTo(contentView)
    }
  }
  
    
}
