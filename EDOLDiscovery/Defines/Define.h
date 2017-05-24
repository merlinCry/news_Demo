//
//  define.h
//  EDOLDiscovery
//
//  Created by song on 16/12/23.
//  Copyright © 2016年 song. All rights reserved.
//

#ifndef define_h
#define define_h

#pragma mark -
#pragma mark KEY ===============================================================
#define ED_LoginMark         @"ED_DRIVER_LOGIN_MARK"
#define ED_ISLogin          ([APPServant servant].user)

//缓存推荐
#define ED_CacheKey                   @"ED_CACHE_HOME_KEY"
//缓存频道分类(所有频道)
#define ED_CateGory_CacheKey          @"ED_CATEGORY_CACHE_KEY"
//缓存频道分类(未登录时,编辑缓存)
#define ED_CateGory_CacheKey_UN       @"ED_CATEGORY_CACHE_KEY_UN"

//用户信息更改(token激活)
#define ED_UserInfo_Change   @"ED_USERINFO_STUTA_CHANGE_KEY"
#define ED_Home_DataRefresh  @"ED_Home_Data_Refresh"

#define ED_DayNight_Changed  @"ED_DayNight_Changed"
//本地存储夜间模式  night / day
#define ED_SkinStyle         @"ED_Skin_Style"

#define ClientCode      (2)


#pragma mark -
#pragma mark FONT ===============================================================

#define ICONFONT(num)                   [UIFont fontWithName:@"bsi" size:num]

#define FONT(num)                   [UIFont fontWithName:@"HelveticaNeue" size:num]
#define FONT_Light(num)                   [UIFont fontWithName:@"HelveticaNeue-light" size:num]

#define FONT_Medium(num)              [UIFont fontWithName:@"HelveticaNeue-Medium" size:num]
#define SYS_FONT(num)               [UIFont systemFontOfSize:num]
#define SYS_Bold_FONT(num)          [UIFont boldSystemFontOfSize:num]

#pragma mark -
#pragma mark SETTINGS ===========================================================
//系统版本号,用于运行时判断
#define SYS_VERSION  ([[[UIDevice currentDevice] systemVersion] floatValue])
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define NavigationBar_HEIGHT  (64)
#define ControllerView_HEIGHT (SCREEN_HEIGHT - NavigationBar_HEIGHT)

#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
#define IOS10_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] !=NSOrderedAscending )

#define IOS7_OR_LATER               ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] !=NSOrderedAscending )


#pragma mark -
#pragma mark COLOR ==============================================================

#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define COLOR(R, G, B, A)           [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define BACKGROUND_COLOR            [UIColor colorWithWhite:1.0 alpha:1]
#define BLACKMASK_COLOR             [UIColor colorWithWhite:0 alpha:0.4]

#define SELECT_MAINCOLOR            UIColorFromRGB(0xAF3E23)
#define LINECOLOR                   UIColorFromRGB(0xE9E9E9)
#define TEXT_COLOR                  [UIColor lightGrayColor]


#define MAINCOLOR                   UIColorFromRGB(0xFFE500)
#define CLEARCOLOR                  [UIColor clearColor]
#define WHITECOLOR                 UIColorFromRGB(0xffffff)
#define BLACKCOLOR                 UIColorFromRGB(0x000000)
#define RANDOMCOLOR                [UIColor randomColor]
#define COLOR_999                  UIColorFromRGB(0x999999)
#define COLOR_333                  UIColorFromRGB(0x333333)
#define COLOR_36                   UIColorFromRGB(0x363636)

#define COLOR_555                  UIColorFromRGB(0x555555)
#define COLOR_666                  UIColorFromRGB(0x666666)
#define COLOR_8080                 UIColorFromRGB(0x808080)
#define COLOR_EEE                  UIColorFromRGB(0xEEEEEE)
#define COLOR_DDD                  UIColorFromRGB(0xDDDDDD)
#define COLOR_BBB                  UIColorFromRGB(0xBBBBBB)
#define COLOR_2F                   UIColorFromRGB(0x2F2F2F)
#define COLOR_A9                   UIColorFromRGB(0xA9A9A9)
#define COLOR_C1                   UIColorFromRGB(0xC1C1C1)
#define COLOR_C7                   UIColorFromRGB(0xC7C7C7)

#pragma mark -
#pragma mark 不同主题下的color ============================================================

#define THEME_COLOR(night,day) ({\
UIColor *color = [APPServant servant].nightShift?night:day;\
color;\
})

#define View_BACKGROUND_COLOR_day       UIColorFromRGB(0xFAFAFA)

//controller背景颜色
#define View_BACKGROUND_COLOR_night     UIColorFromRGB(0x212023)
#define View_BACKGROUND_COLOR           THEME_COLOR(View_BACKGROUND_COLOR_night,View_BACKGROUND_COLOR_day)
//半透明背景颜色
#define View_BACKGROUND_COLOR_Blur      THEME_COLOR(UIColorFromRGBA(0x2E2E2E,0.7),COLOR(250, 250, 250, 0.6))


//cell颜色
#define Cell_BACKGROUND_COLOR           View_BACKGROUND_COLOR
#define Cell_CONTENT_COLOR              THEME_COLOR(UIColorFromRGB(0x262626),WHITECOLOR)


//菜单文字
#define  T_MENU_COLOR         THEME_COLOR(COLOR_C1,COLOR_999)
#define  T_MENU_COLOR_LIGHT   THEME_COLOR(COLOR_C7,BLACKCOLOR)
//标题
#define  T_TITLE_COLOR        THEME_COLOR(COLOR_A9,COLOR_333)
//内容
#define  T_CONTENT_TEXT_COLOR THEME_COLOR(COLOR_999,COLOR_666)
//小字说明
#define  T_SMALL_TEXT_COLOR   THEME_COLOR(UIColorFromRGB(0x5B5B5B),COLOR_999)
//iconFont图标
#define  T_ICON_COLOR         THEME_COLOR(COLOR_999,COLOR_333)


#pragma mark -
#pragma mark smartUI ============================================================

//label
#define LABEL(lfont,lcolor) ({\
UILabel  *aLabel = [UILabel new];\
aLabel.textColor = lcolor;\
aLabel.textAlignment = NSTextAlignmentLeft;\
aLabel.font = lfont;\
aLabel.backgroundColor = CLEARCOLOR;\
aLabel;\
})

#define KeyWindow ({\
UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;\
keyWindow;\
})


//用户基本信息模型
#define USER_BASEINFO_DIC(userId,mobile,nickname,verifyCode,headIcon,superAdmin,sex) ({\
NSDictionary *userBaseDic = @{\
@"userId":userId,\
@"mobile":mobile,\
@"nickname":nickname,\
@"verifyCode":verifyCode,\
@"headIcon":headIcon,\
@"superAdmin":@(superAdmin),\
@"sex":sex};\
userBaseDic;\
})

//登陆检查  没登录直接弹出登陆
#define APPLOGINCHECK ({\
if (![APPServant isLogin]) {\
    [APPServant popLoginVCWithInfo:@"请先登录哦!"];\
    return;\
}})

#define UMMobClick(eventId) [MobClick event:eventId]
#define UMMobClickAttributes(eventId,attName) [MobClick event:eventId attributes:@{@"name":attName}]



//#define NSLog(...) {}

#endif
