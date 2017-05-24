//
//  EDAdviceVC.m
//  EDOLDiscovery
//
//  Created by song on 17/1/7.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDAdviceVC.h"
#import "EDButton.h"
#import "EDMainColorBtn.h"
#import "EDThumbImageView.h"

@interface EDAdviceVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,EDThumbImageViewDelegate>
{
    UIScrollView *bgScrollView;
    UIView *sectionTopView;
    UIView *sectionMidView;
    UIView *sectionBotView;
    
    UILabel    *editPic;
    UILabel    *editTip;
    UITextView *adviceContent;
    
    UILabel *imagePic;
    UILabel *imageTip;
    UIView  *picView;
    
    UILabel     *mobilePic;
    UILabel     *mobileTip;
    UITextField *mobileField;
 
    EDButton    *addPicBtn;
    
    NSMutableArray *picArr;
    NSMutableArray *picShowArr;//预览图
}

@end

@implementation EDAdviceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLikeNavTitle:@"意见反馈"];
    
    [self createBgscroll];
    [self createEditView];
    [self createImageView];
    [self createMobileView];
    [self adjuestContentSize];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [bgScrollView addGestureRecognizer:tapGes];
    
    picArr     = [NSMutableArray new];
    picShowArr = [NSMutableArray new];
}
-(void)dismissKeyBoard
{
    [KeyWindow endEditing:YES];
}

-(void)createBgscroll
{
    bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    bgScrollView.showsVerticalScrollIndicator = NO;
    bgScrollView.alwaysBounceVertical = YES;
    bgScrollView.userInteractionEnabled = YES;
    [self.view addSubview:bgScrollView];
}

-(void)createEditView
{
    sectionTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 203)];
    sectionTopView.backgroundColor = CLEARCOLOR;
    
    editPic = LABEL(ICONFONT(25), THEME_COLOR(COLOR_DDD, COLOR_BBB));
    editPic.text  = editIcon;
    editPic.frame = CGRectMake(15, 10, 25, 25);
    [sectionTopView addSubview:editPic];
    
    editTip      = LABEL(FONT_Light(16), THEME_COLOR(COLOR_DDD, COLOR_BBB));
    editTip.text = @"您的反馈帮助我们变的更好~";
    editTip.frame = CGRectMake(editPic.right + 7, 0, 250, 45);
    [sectionTopView addSubview:editTip];
    
    adviceContent = [[UITextView alloc]initWithFrame:CGRectMake(0, 45, self.view.width, 158)];
    adviceContent.font = FONT_Light(16);
    adviceContent.textColor       = THEME_COLOR(COLOR_999, COLOR_666);
    adviceContent.backgroundColor = THEME_COLOR(COLOR_333, WHITECOLOR);
    adviceContent.placeholder     = @"请输入您的内容或意见";
    adviceContent.placeholderColor = COLOR_999;
    adviceContent.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [sectionTopView addSubview:adviceContent];
    
    [bgScrollView addSubview:sectionTopView];
}

-(void)createImageView
{
    sectionMidView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionTopView.bottom, SCREEN_WIDTH, 150)];
    sectionMidView.backgroundColor = THEME_COLOR(COLOR_333, WHITECOLOR);
    
    UIView *titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    titleView.backgroundColor = View_BACKGROUND_COLOR;
    [sectionMidView addSubview:titleView];
    
    imagePic = LABEL(ICONFONT(25), THEME_COLOR(COLOR_DDD, COLOR_BBB));
    imagePic.text  = pictureIcon;
    imagePic.frame = CGRectMake(15, 10, 25, 25);
    [titleView addSubview:imagePic];
    
    imageTip = LABEL(FONT_Light(16), THEME_COLOR(COLOR_DDD, COLOR_BBB));
    imageTip.text = @"图片展示更加直观（选填）";
    imageTip.frame = CGRectMake(imagePic.right + 7, 0, 250, 45);
    [titleView addSubview:imageTip];
    
    addPicBtn = [[EDButton alloc]initWithFrame:CGRectMake(16, 60, 74, 74)];
    addPicBtn.backgroundColor = CLEARCOLOR;
    addPicBtn.style = EDButtonStyleDown;
    [addPicBtn setBackgroundImage:[UIImage imageNamed:@"dashRect"] forState:UIControlStateNormal];
    [addPicBtn setTitle:@"添  加" forState:UIControlStateNormal];
    [addPicBtn setTitleColor:COLOR_DDD forState:UIControlStateNormal];
    addPicBtn.titleLabel.font  = FONT_Light(14);
    [addPicBtn addTarget:self action:@selector(addAdviceImage) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *addImage = [UIImage iconWithInfo:TBCityIconInfoMake(corssAdd, 28, COLOR_DDD)];
    [addPicBtn setImage:addImage forState:UIControlStateNormal];
    
    [sectionMidView addSubview:addPicBtn];
    
    [bgScrollView addSubview:sectionMidView];
    
}

-(void)createMobileView
{
    sectionBotView = [[UIView alloc]initWithFrame:CGRectMake(0, sectionMidView.bottom, SCREEN_WIDTH, 95)];
    sectionBotView.backgroundColor = CLEARCOLOR;
    
    mobilePic = LABEL(ICONFONT(25), THEME_COLOR(COLOR_DDD, COLOR_BBB));
    mobilePic.text  = mobileIcon;
    mobilePic.frame = CGRectMake(15, 10, 25, 25);
    [sectionBotView addSubview:mobilePic];
    
    mobileTip = LABEL(FONT_Light(16), THEME_COLOR(COLOR_DDD, COLOR_BBB));
    mobileTip.text = @"方便我们后期为您答疑解惑（选填）";
    mobileTip.frame = CGRectMake(imagePic.right + 7, 0, 280, 45);
    [sectionBotView addSubview:mobileTip];
    
    
    mobileField = [[UITextField alloc]initWithFrame:CGRectMake(0, 45, SCREEN_WIDTH, 50)];
    mobileField.backgroundColor = THEME_COLOR(COLOR_333, WHITECOLOR);
    mobileField.textColor = COLOR_999;
    mobileField.font      = FONT_Light(16);
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 17, 5)];
    mobileField.leftView = leftView;
    mobileField.leftViewMode = UITextFieldViewModeAlways;
    mobileField.placeholder  = @"请输入您的手机号/QQ/邮箱";
    [mobileField setValue:COLOR_999 forKeyPath:@"_placeholderLabel.textColor"];
    [sectionBotView addSubview:mobileField];
    [bgScrollView addSubview:sectionBotView];
    
    EDMainColorBtn *commitBtn = [[EDMainColorBtn alloc]initWithFrame:CGRectMake(30, sectionBotView.bottom + 26, SCREEN_WIDTH - 60, 45)];
    [commitBtn.contentBtn setTitle:@"提  交" forState:UIControlStateNormal];
    [commitBtn.contentBtn addTarget:self action:@selector(commitContext) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollView addSubview:commitBtn];
}

-(void)adjuestContentSize
{
    bgScrollView.contentSize = CGSizeMake(self.view.width, 600);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  反馈
 */
-(void)commitContext
{
    if (ISEmpty(adviceContent.text)) {
        [APPServant makeToast:self.view title:@"请填写反馈内容!" position:74];
        return;
    }
    
    NSMutableDictionary *paraDic = @{
        @"content":adviceContent.text,
        @"systemSource":@"3",
        @"clientType":@"2"
    }.mutableCopy;
    
    if (NOTEmpty(mobileField.text)) {
        [paraDic setObject:mobileField.text forKey:@"mobile"];
    }

    if (NOTEmpty(picArr)) {
        NSArray *keyValueArr = @[@"imgOne",@"imgTwo",@"imgThree"];
        for (int i = 0; i < picArr.count; i++) {
            NSString *imgUrl = picArr[i];
            if (i < keyValueArr.count ) {
                [paraDic setObject:imgUrl forKey:keyValueArr[i]];
            }
        }
    }
    [EDHud show];
    [[HttpRequestManager manager] GET:EDAdvice_URL parameters:paraDic success:^(NSURLSessionDataTask * task,id responseObject)
     {
         [EDHud dismiss];
         NSDictionary *dic =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
         NSLog(@"获取成功:%@",dic);
         if ([[dic objectForKey:@"rescode"] integerValue] == 200) {
             //清空数据
             adviceContent.text = @"";
             [APPServant makeToast:self.view title:@"提交成功" position:74];

             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self backBtPressed];
             });
         }else{
             //提交失败
             [APPServant makeToast:self.view title:[NetDataCommon stringFromDic:dic forKey:@"msg"] position:74];

         }
     }failure:^(NSURLSessionDataTask * task,NSError *errpr)
     {
         NSLog(@"failuer");
         [EDHud dismiss];
         [APPServant makeToast:KeyWindow title:NETWOTK_ERROR_STATUS position:74];
     }];
}


-(void)addAdviceImage
{
    UIActionSheet *shareSheet = [[UIActionSheet alloc]initWithTitle:@"更换头像" delegate:self cancelButtonTitle:ALERT_CANCEL destructiveButtonTitle:nil otherButtonTitles:nil,nil];
    shareSheet.delegate = self;
    shareSheet.tag = 777;
    shareSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    
    [shareSheet addButtonWithTitle:@"相册"];
    [shareSheet addButtonWithTitle:@"拍照"];
    [shareSheet showInView:self.view];
}


-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        return;
    }

    if (buttonIndex == 1) {
        //相册
        UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
        
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imgPicker.delegate = self;
        //设置选择后的图片可被编辑
        imgPicker.allowsEditing = YES;
        [self presentViewController:imgPicker animated:YES completion:nil];
        
    }else if(buttonIndex == 2){
        //拍照
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront])
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            //设置拍照后的图片可被编辑
            picker.allowsEditing = YES;
            picker.sourceType = sourceType;
            picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage* image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (image) {
            //保存预览图
            [self showPreImageView:image];
            
            //上传到阿里云
            NSString *timeInterval = [NSString stringWithFormat:@"%.f",[[NSDate date] timeIntervalSince1970]];
           NSString *path =  [NSString stringWithFormat:@"feedback/feed_%@.jpeg",timeInterval];
            [APPServant postImageToAli:image scale:0.5 path:path  completionBlock:^(BOOL isSuccess, id param) {
                if (isSuccess) {
                    //保存图片链接
                    if (NOTEmpty(param)) {
                        [picArr addObject:param];
                    }
                }else{
                    [APPServant makeToast:self.view title:@"图片上传失败" position:74];

                }
            }];
            
        }
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)keyboardWasShown:(NSNotification *)notif
{
    bgScrollView.height = self.view.height - 64 - 200;
    if (mobileField.isFirstResponder) {
        bgScrollView.contentOffset = CGPointMake(0, bgScrollView.contentSize.height - bgScrollView.height);
    }
}

-(void)keyboardWasHidden:(NSNotification *)notif
{
    bgScrollView.height = self.view.height - 64;
    if (mobileField.isFirstResponder) {
        bgScrollView.contentOffset = CGPointMake(0, 0);
    }

}

-(void)refreshImages
{
    CGRect firstRect = CGRectMake(16, 60, 74, 74);
    for (int i = 0; i<picShowArr.count; i++) {
        EDThumbImageView *imageView = picShowArr[i];
        CGFloat x = firstRect.origin.x + i*(74 + 16);
        [UIView animateWithDuration:0.2 animations:^{
            imageView.frame =  CGRectMake(x, firstRect.origin.y, firstRect.size.width, firstRect.size.height);
        }];
    }
    //如果图片数量小于最大数量,将append按钮显示在最后面，不然则隐藏
    if (picShowArr.count>0 && picShowArr.count < 3) {
        [UIView animateWithDuration:0.2 animations:^{
            addPicBtn.origin = CGPointMake(firstRect.origin.x + picShowArr.count*(74 + 16), firstRect.origin.y);
        }];
    }
    else{
        addPicBtn.origin = firstRect.origin;
    }
    
}



-(void)showPreImageView:(UIImage *)image
{
    EDThumbImageView *showImage = [[EDThumbImageView alloc]initWithFrame:CGRectMake(0, 0, 74, 74)];
    showImage.image = image;
    showImage.delegate = self;
    [sectionMidView addSubview:showImage];
    [picShowArr addObject:showImage];
    [self refreshImages];
}
#pragma mark EDThumbImageViewDelegate

-(void)edThumbImageViewDeleted:(EDThumbImageView *)imageView
{
    if ([picShowArr containsObject:imageView]) {
        [picShowArr removeObject:imageView];
    }
    [self refreshImages];
}

@end
