
#import <Foundation/Foundation.h>
#import <QMUIKit.h>
#import "YoCommonUI.h"

//#import "JSCategory.h"
//#import "MBProgressHUD+MP.h"
//#import <UIKit/UIKit.h>

#import "MyFileLogger.h"
#import "JSTool.h"
#import "YoTool.h"

#import "GVUserDefaults+JSProperties.h"
#import <MJExtension/MJExtension.h>

//#import "QJConstants.h"
//#import "QJUserEntityManager.h"


//#ifdef DEBUG
//#define JSLog(...) printf("%s 第%d行: %s\n\n",__func__,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
//#else
//#define JSLog(...)
//#endif

#define IPHONE6_SCREEN_RATE (375/[UIScreen mainScreen].bounds.size.width)
#define RatioZoom(x)                   ((x)/IPHONE6_SCREEN_RATE)


#pragma mark -----Localizable
#define Localized(key) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]] ofType:@"lproj"]] localizedStringForKey:(key) value:nil table:@"Localizable"]
#define JSLocalizedString(key) [NSBundle.mainBundle localizedStringForKey:(key) value:nil table:nil]

#pragma mark ----- Color
#define     JSCOLOR(r, g, b)                 [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define     RGBCOLOR(r, g, b, a)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define     DEFAULT_NAVBAR_COLOR             JSCOLOR(47, 47, 47)
//#define     DEFAULT_BACKGROUND_COLOR         JSCOLOR(239, 239, 244)
//
//#define     DEFAULT_CHAT_BACKGROUND_COLOR    JSCOLOR(235, 235, 235)
#define     DEFAULT_CHATBOX_COLOR            JSCOLOR(244, 244, 246)
//#define     DEFAULT_SEARCHBAR_COLOR          JSCOLOR(239, 239, 244)
//#define     DEFAULT_GREEN_COLOR              JSCOLOR(2, 187, 0)
//#define     DEFAULT_TEXT_GRAY_COLOR          [UIColor grayColor]
#define     DEFAULT_LINE_GRAY_COLOR          RGBCOLOR(188, 188, 188, 0.6f)

#define DEFAULT_CONTENT_COLOR               JSCOLOR(51, 51, 51)
#define DEFAULT_SUBTITLE_COLOR               JSCOLOR(102, 102, 102)


#define     DEFAULT_ALL_YELLOW_COLOR         JSCOLOR(246, 196, 76)
#define     DEFAULT_ALL_GRAY_COLOR           JSCOLOR(238, 238, 238)
#define     DEFAULT_BUTTON_BLACK_COLOR       JSCOLOR(88, 88, 88)

#define     MOMENT_UESRNAME_COLOR            JSCOLOR(153, 104, 0)



#pragma mark ----- Size
//#define     SCREEN_WIDTH                     [UIScreen mainScreen].bounds.size.width
//#define     SCREEN_HEIGHT                    [UIScreen mainScreen].bounds.size.height
#define     STATUSBAR_HEIGHT	             [UIApplication sharedApplication].statusBarFrame.size.height
#define     TABBAR_HEIGHT                    49
#define     NAVBAR_HEIGHT                    44
#define CHAT_HEADIMAGE_WIDTH  60
#define CHAT_HEADIMAGE_HEIGHT 60

#define     HEIGHT_TABBAR              49


#define NORMAL_Y  ((STATUSBAR_HEIGHT == 20.0) ? 64 : 88)
#define NORMAL_Bottom  ((STATUSBAR_HEIGHT == 20.0) ? 0 : 20)

static NSString* const Reachability_Test_Url=@"www.baidu.com";

#pragma mark ----- Font
#define     CUSTOMFONT @"JXiYuan"


#pragma mark ----- Path
#define     PATH_DOCUMENT             [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
#define     PATH_CHATREC_IMAGE        [PATH_DOCUMENT stringByAppendingPathComponent:@"video"]


#define StatuSign @"staus"         //状态标识
#define UserStatus [JGAccountTool account].staus  //状态
#define UserToken [JGAccountTool account].token    //用户token


///  外网地址
static NSString* const RootBaseURL = @"http://moyue.pv.cm88.wang/api";
//static NSString* const RootBaseURL = @"http://moyue.dev.cm88.wang/api";
// 上传图片的地址
//static NSString* const UploadRootBaseURL = @"http://apps.cm88.wang:8083/api/1.0.0/aliyun/upload/image";
static NSString* const UploadRootBaseURL = @"http://47.104.184.154:8083/aliyun/upload/images";

/// 倒计时秒数
static int countDownSeconds = 10;






//内部事件
#define ET_HBERROR @"心跳异常"
#define ET_LOGOUT @"logout"
#define ET_LOGIN @"login"
#define ET_UPDATEHEAD @"UpdateHead"
//外部事件
#define ET_FMDISCUSS @"足迹评论"
#define ET_NFAPPLICATION @"好友申请"
#define ET_NEWCHAT @"新的聊天信息"


//字符串是否为空
#define StringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define ArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define DictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys.count == 0)


#define VersionNumber_iOS_7  [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0
#define VersionNumber_iOS_8  [[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0
#define softVersionKey @"CFBundleShortVersionString"
#define softBundleKey @"CFBundleVersion"

#define isInch_40            (SCREEN_HEIGHT == 568)
#define isInch_47            (SCREEN_HEIGHT == 667)
#define isInch_55            (SCREEN_HEIGHT == 736)

#if __has_feature(objc_arc)
#define IMP_WEAK_SELF(type) __weak type *weak_self=self;
#else
#define IMP_WEAK_SELF(type) __block type *weak_self=self;
#endif

#pragma mark - Notification
#define JSNSNotificationCenter [NSNotificationCenter defaultCenter]

//#pragma mark - NSUserDefatults
//#define JSNSUserDefaults [NSUserDefaults standardUserDefaults]



//跳转事件
extern NSString *const LG_SelectAddressCompleteNotification;
extern NSString *const LG_OrderSelectAddressCompleteNotification;
extern NSString *const LG_OrderAddressRefreshNotification;


/// 购物车
extern NSString *const LG_ShopCarChangeCompleteNotification;
/// 订单提交成功
extern NSString *const LG_OrderCommitCompleteNotification;
/// 登录成功通知
extern NSString *const LGET_LoginNotification;
extern NSString *const LGET_LogoutNotification;
// mjrefresh 刷新通知
extern NSString *const LG_JSRefreshHeaderNotification;









extern NSString *const QJ_goToLoginViewControllerNotification;
extern NSString *const QJ_goToTabbarControllerNotification;
//提交事件
extern NSString *const QJ_SubmitDeviceTokenNotification;
extern NSString *const QJ_ConnectChatNotification;
extern NSString *const QJ_NewChatNotification;

//内部事件通知
extern NSString *const QJET_HbErrorNotification;
extern NSString *const QJET_LogoutNotification;
extern NSString *const QJET_LoginNotification;
extern NSString *const QJET_UpdateHeadNotification;
//外部事件通知
extern NSString *const QJET_FmDiscussNotification;
extern NSString *const QJET_NfApplicationNotification;
extern NSString *const QJET_NewChatNotification;

/** 点击朋友圈全文的通知 */
extern NSString * const LZMoreButtonClickedNotification;
extern NSString * const LZMoreButtonClickedNotificationKey;

