//
//  InterfaceDefine.h
//  EDOLDiscovery
//
//  Created by song on 16/12/23.
//  Copyright © 2016年 song. All rights reserved.
//

#ifndef InterfaceDefine_h
#define InterfaceDefine_h

//#define IP_ADDRESS_DEBUG
#define IP_ADDRESS_RELEASE

#ifdef IP_ADDRESS_RELEASE
#define    IP_PORT     @"m.8dol.com"
#define    URLADDRESS  [NSString stringWithFormat:@"https://%@/",IP_PORT]
#endif

#pragma mark-
#pragma mark =============================debugIP===========================================
#ifdef IP_ADDRESS_DEBUG
#define    IP_PORT    @"192.168.40.235:8082"

#define URLADDRESS    [NSString stringWithFormat:@"http://%@/",IP_PORT]
#endif


#pragma mark-
#pragma mark =============================Interface===========================================


//用户相关
/**
 *  登录
 */
#define Login_URL                      [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/user/login"]

/**
 *  激活token
 */
#define ActivateUserToken                      [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/user/activateUserToken"]

//注册
#define EDRegister_URL                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/user/register"]

//重置密码
#define EDResetPwd                   [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/user/resetPassword"]

/**
 *  type   1:注册;2:重置密码;3:短信验证码登录
 */
#define IdentifyCode_URL                 [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/user/smsCode"]

/**
 *  验证码登录
 */
#define SmsCodeLogin_URL                 [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/user/smsCodeLogin"]

//单项保存用户个人资料
#define SAVE_USERINFO   [NSString stringWithFormat:@"%@%@",URLADDRESS,@"user/modifyUserByUserId"]

//文章相关
/**
 *  频道列表
 */
#define HOMECategory_URL                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/channel/list"]

/**
 *  频道排序
 */
#define HOMECategory_sort                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/channel/changeChannel"]


/**
 *  文章列表
 */
#define HOMEAricl_List_URL                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/listInfo"]

/**
 *  文章详情
 */
#define HOMEAricl_Detail_URL                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/details"]

/**
 *   收藏文章
 */
#define Aricl_favoritesAdd                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/favorites/add"]
/**
 *   取消收藏
 */
#define Aricl_favoritesCancel                 [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/favorites/cancel"]

/**
*  删除收藏
*/
#define Aricl_favoritesDelete                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/favorites/delete"]

/**
*    收藏列表
*/
#define Aricl_favoritesList                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/favorites/list"]

//评论列表
#define EDListComment                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/listComment"]

//添加评论，或回复
#define EDListAddComment                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/comment"]

//赞评论
#define EDCommentZan                  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/vote"]

//用户反馈
#define EDAdvice_URL                 [NSString stringWithFormat:@"%@%@",URLADDRESS,@"v2/usercenter/provideFeedback"]

//分享
#define EDShare_URL  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"function/campusShare/news.html"]

//不喜欢
#define EDUnlike_URL  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/disLike"]

//管理员删除
#define EDAdminDelete_URL  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/deleteInfo"]
//查询指定评论信息
#define EDCommentInfo_URL  [NSString stringWithFormat:@"%@%@",URLADDRESS,@"campus/info/listReplyComment"]


#endif
