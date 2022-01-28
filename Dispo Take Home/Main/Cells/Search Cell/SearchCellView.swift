//
//  SearchCellView.swift
//  Dispo Take Home
//
//  Created by Daniel Phiri on 1/27/22.
//

import UIKit
import WebKit

class SearchCellView: CellConfigurable {
  
  var model                  : SearchResult?
  static let reuseIdentifier = "SearchCellView"
  private let padding        : CGFloat = 20
  private var isLoaded       = false
  
  private var gifView: WKWebView    = {
    let view                        = WKWebView()
    view.isOpaque                   = false
    view.backgroundColor            = UIColor.clear
    view.scrollView.backgroundColor = UIColor.clear
    return view
  }()
  
  private var titleLabel  : UILabel = {
    let label             = UILabel()
    label.backgroundColor = .clear
    label.textColor       = .systemBlack
    label.textAlignment   = .left
    //    label.numberOfLines   = 0
    label.font            = UIFont.systemFont(ofSize: 32, weight: .regular)
    label.lineBreakMode   = .byTruncatingTail
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
  
  override func setUp<T>(data: T) {
    DispatchQueue.main.async {
      guard let data       = data as? SearchResult else { return }
      self.model           = data
      self.titleLabel.text = data.title
      let html             = "<img src=\"\(data.gifUrl)\" width=\"100%\">"
      self.gifView.loadHTMLString(html, baseURL: nil)
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
      make.trailing.equalTo(contentView)//.offset(-\padding)
      make.bottom.equalTo(contentView)
      make.top.equalTo(contentView)
    }
  }
  
  
}

