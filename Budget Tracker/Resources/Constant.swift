//
//  Constant.swift
//  Budget Tracker
//
//  Created by Spemai-Macbook on 2021-05-07.
//

import Foundation
import UIKit

struct Constant {
    
    static let ADD_NEW_CATEGORY_SEGUE_IDENTIFY = "add_new_category"
    
    static let PRIMARY_COLOR_THEMES = [#colorLiteral(red: 0.6666666667, green: 0.6666666667, blue: 0.6666666667, alpha: 1),#colorLiteral(red: 0.4235294118, green: 0.7450980392, blue: 0.4509803922, alpha: 1),#colorLiteral(red: 0.8431372549, green: 0.2980392157, blue: 0.2, alpha: 1),#colorLiteral(red: 0.9490196078, green: 0.737254902, blue: 0.2666666667, alpha: 1),#colorLiteral(red: 0.6901960784, green: 0.3098039216, blue: 0.8705882353, alpha: 1),#colorLiteral(red: 0.2784313725, green: 0.6039215686, blue: 1, alpha: 1)]
    
    static let SECONDARY_COLOR_THEMES = [#colorLiteral(red: 0.9647058824, green: 0.9607843137, blue: 0.968627451, alpha: 1),#colorLiteral(red: 0.8117647059, green: 1, blue: 0.7921568627, alpha: 1),#colorLiteral(red: 1, green: 0.8509803922, blue: 0.8705882353, alpha: 1),#colorLiteral(red: 1, green: 0.9725490196, blue: 0.7019607843, alpha: 1),#colorLiteral(red: 0.9411764706, green: 0.8549019608, blue: 1, alpha: 1),#colorLiteral(red: 0.7450980392, green: 0.9058823529, blue: 1, alpha: 1)]
    
    static let EXPENSES_OCCURRENCE = ["One off", "Daily", "Weekly", "Monthly"]

    static let ALERT_HEADER = "Budget Tracker"

    static let PIE_CHART_COLOR =  [#colorLiteral(red: 0.9479869008, green: 0.7266349196, blue: 0.341771096, alpha: 1),#colorLiteral(red: 0.8810942769, green: 0.4196403325, blue: 0.2382574379, alpha: 1),#colorLiteral(red: 0.4055999517, green: 0.7631344199, blue: 0.6749764085, alpha: 1),#colorLiteral(red: 0.3019607843, green: 0.662745098, blue: 0.7411764706, alpha: 1),#colorLiteral(red: 0.5201322436, green: 0.5854018331, blue: 0.6253080964, alpha: 1),#colorLiteral(red: 0.8202931285, green: 0.8469770551, blue: 0.8538480401, alpha: 1)]
}

enum CategoryOrder {
    case alphabetically, tap
}

