import UIKit
import WebKit

class DetailViewController: UIViewController {
  
  private let padding       : CGFloat = 30
  private let searchResult  : SearchResult
  private let edgeInsets    : UIEdgeInsets?
                            = UIApplication.shared.windows.first?.safeAreaInsets
  private let gifViewHeight : CGFloat = 300
  private var viewModel     : DetailViewModel?
  
  private var gifView: WKWebView = {
    let view                        = WKWebView()
    view.isOpaque                   = false
    view.backgroundColor            = UIColor.clear
    view.scrollView.backgroundColor = UIColor.clear
    return view
  }()
  
  private var titleLabel: UILabel = {
    let label             = UILabel()
    label.backgroundColor = .clear
    label.textColor       = .systemBlack
    label.textAlignment   = .center
    label.numberOfLines   = 0
    label.font            = UIFont.systemFont(ofSize: 32, weight: .regular)
    label.lineBreakMode   = .byTruncatingTail
    return label
  }()
  
  private var sourceLabel: UILabel = {
    let label             = UILabel()
    label.backgroundColor = .clear
    label.textColor       = .systemBlack
    label.textAlignment   = .center
    label.numberOfLines   = 0
    label.font            = UIFont.systemFont(ofSize: 32, weight: .regular)
    label.lineBreakMode   = .byTruncatingTail
    return label
  }()
  
  private var ratingLabel: UILabel = {
    let label             = UILabel()
    label.backgroundColor = .clear
    label.textColor       = .systemBlack
    label.textAlignment   = .center
    label.numberOfLines   = 0
    label.font            = UIFont.systemFont(ofSize: 32, weight: .regular)
    label.lineBreakMode   = .byTruncatingTail
    return label
  }()
  
  init(searchResult: SearchResult) {
    self.searchResult = searchResult
    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .systemBackground
    addSubviews()
    addGestures()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func loadViewModel(searchResult: SearchResult) {
    let client = GifAPIClient<GifDetails>()
    let model  = Observable<GifDetails> { [weak self] info in
                  self?.updateData(with: info)
                }
    viewModel  = DetailViewModel(searchResult: searchResult, client: client, model: model)
  }
  
  private func updateData(with info: GifDetails?) {
    DispatchQueue.main.async {
      guard let info = info else {
        return
      }
      self.titleLabel.text  = "Title: \(info.data.title)"
      self.sourceLabel.text = "Source: \(info.data.source_tld)"
      self.ratingLabel.text = "Rating: \(info.data.rating)"
      let html              = "<img src=\"\(info.data.images.fixed_height.url)\" width=\"100%\" height=\"100%\">"
      self.gifView.loadHTMLString(html, baseURL: nil)
    }
  }
  
  private func addSubviews() {
    view.addSubview(gifView)
    view.addSubview(titleLabel)
    view.addSubview(sourceLabel)
    view.addSubview(ratingLabel)
    setUpConstraints()
    loadViewModel(searchResult: searchResult)
  }
  
  private func setUpConstraints() {
    gifView.snp.makeConstraints { make in
      make.top.equalTo(view).offset(padding * 2 + (edgeInsets?.top ?? 0))
      make.leading.equalTo(view).offset(padding)
      make.trailing.equalTo(view).offset(-padding)
      make.height.equalTo(gifViewHeight)
    }
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(gifView.snp.bottom).offset(padding/2)
      make.leading.equalTo(view).offset(padding)
      make.trailing.equalTo(view).offset(-padding)
    }
    sourceLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(padding/2)
      make.leading.equalTo(view).offset(padding)
      make.trailing.equalTo(view).offset(-padding)
    }
    ratingLabel.snp.makeConstraints { make in
      make.top.equalTo(sourceLabel.snp.bottom).offset(padding/2)
      make.leading.equalTo(view).offset(padding)
      make.trailing.equalTo(view).offset(-padding)
    }
  }
  
  private func addGestures() {
    let rightSwipe                = UISwipeGestureRecognizer(
                                      target : self,
                                      action : #selector(popController)
                                    )
    rightSwipe.direction          = .right
    view.isUserInteractionEnabled = true
    view.addGestureRecognizer(rightSwipe)
  }
  
  @objc func popController() {
    navigationController?.popViewController(animated: true)
  }
  
}
