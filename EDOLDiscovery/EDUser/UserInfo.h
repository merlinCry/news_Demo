//
//  UserInfo.h
//  SaleForIos
//
//  Created by feng on 15-2-4.
//
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

@property (nonatomic, strong)NSString *mId;                 //用户id
@property (nonatomic, strong)NSString *mVerifyCode;        //用户登录唯一标识
@property (nonatomic, strong)NSString *mNickname;           //用户昵称
@property (nonatomic, strong)NSString *mNicknameEncode;     //用户昵称 编码后的昵称
@property (nonatomic, assign)BOOL     superAdmin;    //是否管理员


@property (nonatomic, strong)NSString *mHeadIcon;           //头像
@property (nonatomic, strong)NSString *mMobile;             //手机号码
/**
 *  1 男 2 女  
 */
@property (nonatomic, assign)NSInteger  mSex;           //性别


+(UserInfo *)parseInfoFromDic:(NSDictionary *)dic;

/**
 *  跟新本地缓存
 */
-(void)updateDiskCache;
@end
