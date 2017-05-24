//
//  UserInfo.m
//  SaleForIos
//
//  Created by feng on 15-2-4.
//
//

#import "UserInfo.h"

@implementation UserInfo
- (id)init
{
    self = [super init];
    if (self) {
        _mId = @"";
        _mHeadIcon = @"";
        _mMobile = @"";
        _mNickname = @"";
        _mVerifyCode = @"";
        _mSex = 1;
        
    }
    return self;
}
+(UserInfo *)parseInfoFromDic:(NSDictionary *)dic
{
    if (!dic) {
        return [[UserInfo alloc]init];
    }
    UserInfo *info    = [[UserInfo alloc]init];
    info.mId          = [NetDataCommon stringFromDic:dic forKey:@"userId"];
    info.mHeadIcon    = [[NetDataCommon stringFromDic:dic forKey:@"headIcon"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    info.mMobile      = [NetDataCommon stringFromDic:dic forKey:@"mobile"];
    info.mNicknameEncode    = [NetDataCommon stringFromDic:dic forKey:@"nickname"];
    if (NOTEmpty(info.mNicknameEncode)) {
        info.mNickname = [EDOLTool base64decodeString:info.mNicknameEncode];
    }
    info.mSex         = [[NetDataCommon stringFromDic:dic forKey:@"sex"] intValue];
    info.mVerifyCode  = [NetDataCommon stringFromDic:dic forKey:@"verifyCode"];
    info.superAdmin   = [[NetDataCommon stringFromDic:dic forKey:@"superAdmin"] boolValue];
    
    
    return info;
}

-(void)updateDiskCache{
    NSString *sexStr = [NSString stringWithFormat:@"%ld",(long)self.mSex];
    NSDictionary *userFormatDic =  USER_BASEINFO_DIC(self.mId, self.mMobile, self.mNickname, self.mVerifyCode, self.mHeadIcon,self.superAdmin,sexStr);
    [EDOLTool saveToNSUserDefaults:userFormatDic forKey:ED_LoginMark];
}

@end
