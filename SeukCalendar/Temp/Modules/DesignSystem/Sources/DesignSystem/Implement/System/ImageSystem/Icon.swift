//
//  Icon.swift
//  DesignSystem
//
//  Created by yongbeomkwak on 9/23/25.
//

import SwiftUI

public enum Icon {
  public static let search = ImageResource(name: "ico-search")
  public static let searchFill = ImageResource(name: "ico-search-fill")
  public static let heart = ImageResource(name: "ico-heart")
  public static let heartFill = ImageResource(name: "ico-heart-fill")
  public static let close2 = ImageResource(name: "ico-close2")
  public static let close2Fill = ImageResource(name: "ico-close2-fill")
  public static let close = ImageResource(name: "ico-close")
  public static let closeFill = ImageResource(name: "ico-close-fill")
  public static let trash = ImageResource(name: "ico-trash")
  public static let trashFill = ImageResource(name: "ico-trash-fill")
  public static let flag = ImageResource(name: "ico-flag")
  public static let flagFill = ImageResource(name: "ico-flag-fill")
  public static let check2 = ImageResource(name: "ico-check2")
  public static let check2Fill = ImageResource(name: "ico-check2-fill")
  public static let check = ImageResource(name: "ico-check")
  public static let checkFill = ImageResource(name: "ico-check-fill")
  public static let chat = ImageResource(name: "ico-chat")
  public static let chatFill = ImageResource(name: "ico-chat-fill")
  public static let caution = ImageResource(name: "ico-caution")
  public static let cautionFill = ImageResource(name: "ico-caution-fill")
  public static let bookmark = ImageResource(name: "ico-bookmark")
  public static let bookmarkFill = ImageResource(name: "ico-bookmark-fill")
  public static let point = ImageResource(name: "ico-point")
  public static let pointFill = ImageResource(name: "ico-point-fill")
  public static let arrowLeft = ImageResource(name: "ico-arrow-left")
  public static let arrowLeftFill = ImageResource(name: "ico-arrow-left-fill")
  public static let arrowCircle = ImageResource(name: "ico-arrow-circle")
  public static let arrowCircleFill = ImageResource(name: "ico-arrow-circle-fill")
  public static let calendar = ImageResource(name: "ico-calendar")
  public static let calendarFill = ImageResource(name: "ico-calendar-fill")
  public static let camera = ImageResource(name: "ico-camera")
  public static let cameraFill = ImageResource(name: "ico-camera-fill")
  public static let gallery = ImageResource(name: "ico-gallery")
  public static let galleryFill = ImageResource(name: "ico-gallery-fill")
  public static let minus = ImageResource(name: "ico-minus")
  public static let mniusFill = ImageResource(name: "ico-minus-fill")
  public static let plus = ImageResource(name: "ico-plus")
  public static let plusFill = ImageResource(name: "ico-plus-fill")
  public static let plus2 = ImageResource(name: "ico-plus2")
  public static let chevronDown = ImageResource(name: "ico-chevron-down")
  public static let chevronDownFill = ImageResource(name: "ico-chevron-down-fill")
  public static let edit = ImageResource(name: "ico-edit")
  public static let editFill = ImageResource(name: "ico-edit-fill")
  public static let arrowUp = ImageResource(name: "ico-arrow-up")
  public static let arrowUpFill = ImageResource(name: "ico-arrow-up-fill")
  public static let ellipsis = ImageResource(name: "ico-ellipsis")
  public static let ellipsisFill = ImageResource(name: "ico-ellipsis-fill")
  public static let document = ImageResource(name: "ico-document")
  public static let play = ImageResource(name: "ico-play")
  public static let pause = ImageResource(name: "ico-pause")
  public static let comment = ImageResource(name: "ico-comment")
  public static let commentFill = ImageResource(name: "ico-comment-fill")
  public static let share = ImageResource(name: "ico-share")
  #warning("나중에 어디로 옮기지 고민")
  public static let logo = ImageResource(name: "logo")
}

public extension Icon {
  enum Family: String {
    case tab = "Tab"
    case sns = "SNS"
  }
}

public extension Icon {
  enum Tab {
    public static let home = ImageResource(.tab, name: "ico-home")
    public static let homeFill = ImageResource(.tab, name: "ico-home-fill")
    public static let plus2 = ImageResource(.tab, name: "ico-plus2")
    public static let plus2Fill = ImageResource(.tab, name: "ico-plus2-fill")
    public static let user = ImageResource(.tab, name: "ico-user")
    public static let userFill = ImageResource(.tab, name: "ico-user-fill")
  }

  enum SNS {
    public static let kakao = ImageResource(.sns, name: "ico-kakao")
    public static let naver = ImageResource(.sns, name: "ico-naver")
    public static let apple = ImageResource(.sns, name: "ico-apple")
    public static let google = ImageResource(.sns, name: "ico-google")
  }
}

// MARK: - fileprivate
fileprivate extension ImageResource {
  init(_ family: Icon.Family, name: String) {
    self.init(name: "\(family.rawValue)/\(name)", bundle: .designSystemBundle)
  }

  init(name: String) {
    self.init(name: name, bundle: .designSystemBundle)
  }
}
