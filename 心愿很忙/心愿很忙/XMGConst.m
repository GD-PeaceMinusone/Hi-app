#import <UIKit/UIKit.h>

/** 通用的间距值 */
CGFloat const XMGMargin = 10;
/** 通用的小间距值 */
CGFloat const XMGSmallMargin = XMGMargin * 0.5;

/** 公共的URL */
NSString * const XMGCommonURL = @"http://api.budejie.com/api/api_open.php";

/** XMGUser - sex - male */
NSString * const XMGUserSexMale = @"m";

/** XMGUser - sex - female */
NSString * const XMGUserSexFemale = @"f";

/*** 通知 ***/
/** TabBar按钮被重复点击的通知 */
NSString * const XMGTabBarButtonDidRepeatClickNotification = @"XMGTabBarButtonDidRepeatClickNotification";
/** 标题按钮被重复点击的通知 */
NSString * const XMGTitleButtonDidRepeatClickNotification = @"XMGTitleButtonDidRepeatClickNotification";