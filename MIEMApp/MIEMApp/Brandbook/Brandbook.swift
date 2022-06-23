//
//  Brandbook.swift
//  MIEMApp
//
//  Created by Тимофей Фёдоров on 16.11.2020.
//

import UIKit

enum Brandbook {
  enum Colors {
    static let tint = UIColor(red: 0.30, green: 0.69, blue: 0.31, alpha: 1.00)
    static let darkTint = UIColor(red: 0.30, green: 0.4, blue: 0.31, alpha: 1.00)
    static let dimming = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.00)
    static let redColor = UIColor(red: 255/255, green: 31/255, blue: 34/255, alpha: 1.00)
    static let yellowColor = UIColor(red: 255/255, green: 135/255, blue: 0.255, alpha: 1.00)
    static let greenColor = UIColor(red: 0/255, green: 168/255, blue: 52/255, alpha: 1.00)
    static let blueColor = UIColor(red: 0/255, green: 131/255, blue: 244/255, alpha: 1.00)
    static let redColorInactive = UIColor(red: 255/255, green: 31/255, blue: 34/255, alpha: 0.50)
    static let yellowColorInactive = UIColor(red: 255/255, green: 135/255, blue: 0.255, alpha: 0.50)
    static let greenColorInactive = UIColor(red: 0/255, green: 168/255, blue: 52/255, alpha: 0.50)
    static let blueColorInactive = UIColor(red: 0/255, green: 131/255, blue: 244/255, alpha: 0.50)
    static let lightGray = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
    static let grey = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.00)
    static let blueStatus = UIColor(red: 65/255, green: 129/255, blue: 230/255, alpha: 1.00)
    static let lightBlueStatus = UIColor(red: 74/255, green: 188/255, blue: 237/255, alpha: 1.00)
    static let greenStatus = UIColor(red: 0.30, green: 0.69, blue: 0.31, alpha: 0.50)
    static let turquoiseStatus = UIColor(red: 74/255, green: 237/255, blue: 237/255, alpha: 0.5)
    static let orangeStatus = UIColor(red: 74/255, green: 237/255, blue: 237/255, alpha: 0.5)
    static let greenBackround = UIColor(red: 237/255, green: 136/255, blue: 74/255, alpha: 1.00)
    static let darkGreen = UIColor(red: 49/255, green: 87/255, blue: 52/255, alpha: 1)
    static let system_gray3 = UIColor(red: 199/255, green: 199/255, blue: 204/255, alpha: 1)
    @available(iOS 13.0, *)
    static let dark_light = UIColor { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 0.3, alpha: 1.0)
      default:
        return UIColor(white: 1.0, alpha: 1.0)
      }
    }
    
    @available(iOS 13.0, *)
    static let dark_light_text = UIColor { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 1.0, alpha: 1.0)
      default:
        return UIColor(white: 0.0, alpha: 1.0)
      }
    }
    
    @available(iOS 13.0, *)
    static let dark_light_text_gray = UIColor { traitCollection in
      switch traitCollection.userInterfaceStyle {
      case .dark:
        return UIColor(white: 1.0, alpha: 1.0)
      default:
        return UIColor(white: 0.4, alpha: 1.0)
      }
    }
    static let lightBlue = UIColor(red: 26/255, green: 131/255, blue: 157/255, alpha: 1)
    static let beige = UIColor(red: 243/255, green: 259/255, blue: 250/255, alpha: 1)

 

    
  }
  
  enum Images {
    enum Icons {
      static let recordTabBarIcon = UIImage(imageLiteralResourceName: "RecordTabBarIcon")
      static let timetabelTabBarIcon = UIImage(imageLiteralResourceName: "TimetableTabBarIcon")
      static let menuTabBarIcon = UIImage(imageLiteralResourceName: "MenuTabBarIcon")
      static let addIcon = UIImage(imageLiteralResourceName: "AddIcon")
      static let deleteIcon = UIImage(imageLiteralResourceName: "DeleteIcon")
      static let filterIcon = UIImage(imageLiteralResourceName: "filtericon")
      static let filterIcon1 = UIImage(imageLiteralResourceName: "filtericon1")
      
      static let zoomOutIcon = UIImage(imageLiteralResourceName: "ZoomOutIcon").withRenderingMode(.alwaysTemplate)
      static let zoomInIcon = UIImage(imageLiteralResourceName: "ZoomInIcon").withRenderingMode(.alwaysTemplate)
      
      static let controlMenuIcon = UIImage(imageLiteralResourceName: "AppLogo")
      static let aboutMenuIcon = UIImage(imageLiteralResourceName: "AboutMenuIcon")
      static let userMenuIcon = UIImage(imageLiteralResourceName: "UserMenuIcon")
      static let projectsMenuIcon = UIImage(imageLiteralResourceName: "ProjectsMenuIcon")
      
      static let closeIcon = UIImage(imageLiteralResourceName: "CloseIcon").withRenderingMode(.alwaysTemplate)
      
      static let userProfileIcon = UIImage(imageLiteralResourceName: "UserProfileIcon")
      static let emailIcon = UIImage(imageLiteralResourceName: "EmailIcon").withRenderingMode(.alwaysTemplate)
      static let departIcon = UIImage(imageLiteralResourceName: "DepartmentIcon").withRenderingMode(.alwaysTemplate)
      
      static let profileTabBarIcon = UIImage(imageLiteralResourceName: "ProfileTabBarIcon")
      static let sandboxProjectIcon = UIImage(imageLiteralResourceName: "SandboxProjecticon")
      
      static let navigationIcon = UIImage(imageLiteralResourceName: "NavigationIcon")
      
      static let tinderBackground2 = UIImage(imageLiteralResourceName: "tinder-back-2")
    }
    
    enum CameraTutorial {
      
      static let page1 = UIImage(imageLiteralResourceName: "page1")
      static let page2 = UIImage(imageLiteralResourceName: "page2")
      static let page3 = UIImage(imageLiteralResourceName: "page3")
      static let page4 = UIImage(imageLiteralResourceName: "page4")
      static let page5 = UIImage(imageLiteralResourceName: "page5")
      static let page67 = UIImage(imageLiteralResourceName: "page67")
    }
    
    static let appLogo = UIImage(imageLiteralResourceName: "AppLogo")
  }
  
  enum Durations {
    static let short: Double = 0.15
    static let normal: Double = 0.3
  }
  
  enum Paddings {
    static let small: CGFloat = 4
    static let light: CGFloat = 8
    static let normal: CGFloat = 16
  }
  
  enum TextSize {
    static let small: CGFloat = 12
    static let normal: CGFloat = 14
    static let largeNormal: CGFloat = 16
    static let large: CGFloat = 18
    static let enormous: CGFloat = 25
  }
  
  enum LineSize {
    static let normal: CGFloat = 2
  }
  
  enum Heights {
    static let awardCell: CGFloat = 250
    static let gitCell: CGFloat = 100
    static let defaultHeight: CGFloat = 300
  }
}
