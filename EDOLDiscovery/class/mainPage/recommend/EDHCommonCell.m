//
//  EDHRecommendCell.m
//  EDOLDiscovery
//
//  Created by song on 17/1/3.
//  Copyright © 2017年 song. All rights reserved.
//

#import "EDHCommonCell.h"
#import "ImageInfo.h"
#import "TYAttributedLabel.h"
@interface EDHCommonCell ()
{
    //共有部分
    TYAttributedLabel  *textLabel;
    UILabel  *fromeAndTime;
    UIButton *replay;
    
    EDBaseImageView *bigImageView;
    EDBaseImageView *rightImageView;
    UIView      *imagesView;
    UILabel     *zhiDing;
    
    //close按钮
    UIButton    *unLikeBtn;

    UILongPressGestureRecognizer *longPress;
}


@end
@implementation EDHCommonCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
        self.contentView.backgroundColor = [UIColor randomColor];
    }
    return self;
}

-(void)initSubViews
{
//    textLabel = LABEL(FONT(18), COLOR_333);
    textLabel = [[TYAttributedLabel alloc]init];
    textLabel.font = FONT(18);
    textLabel.textColor = COLOR_333;
    textLabel.linesSpacing  = 3;
    textLabel.numberOfLines = 2;
    textLabel.characterSpacing = 0;
    textLabel.backgroundColor = CLEARCOLOR;
    
    zhiDing = LABEL(FONT(10), UIColorFromRGB(0xFF6060));
    zhiDing.textAlignment       = NSTextAlignmentCenter;
    zhiDing.layer.cornerRadius  = 4;
    zhiDing.layer.masksToBounds = YES;
    zhiDing.layer.borderColor   = UIColorFromRGB(0xFF6060).CGColor;
    zhiDing.layer.borderWidth   = 1;
    zhiDing.text = @"置顶";
    
    fromeAndTime     = LABEL(FONT_Light(12), COLOR_999);
    
    replay           = [[UIButton alloc]init];
    replay.titleLabel.font = FONT_Light(12);
    replay.adjustsImageWhenHighlighted  = NO;
    replay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    //图片部分
    //big
    bigImageView = [EDBaseImageView new];
    bigImageView.contentMode = UIViewContentModeScaleAspectFill;
    bigImageView.userInteractionEnabled = YES;
    bigImageView.clipsToBounds = YES;
    
    //right
    rightImageView = [EDBaseImageView new];
    rightImageView.userInteractionEnabled = YES;
    rightImageView.contentMode = UIViewContentModeScaleAspectFill;
    rightImageView.clipsToBounds = YES;

    //多图
    imagesView = [UIView new];
    imagesView.userInteractionEnabled = YES;
    
    unLikeBtn = [UIButton new];
    unLikeBtn.backgroundColor = Cell_CONTENT_COLOR;
    [unLikeBtn setImage:[UIImage imageNamed:@"deleIcon"] forState:UIControlStateNormal];
    [unLikeBtn addTarget:self action:@selector(showPopmenu:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:textLabel];
    [self.contentView addSubview:zhiDing];
    [self.contentView addSubview:fromeAndTime];
    [self.contentView addSubview:replay];
    [self.contentView addSubview:bigImageView];
    [self.contentView addSubview:rightImageView];
    [self.contentView addSubview:imagesView];
    [self.contentView addSubview:unLikeBtn];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.height          = self.height - 1;
    unLikeBtn.frame   = CGRectMake(0, 0, 40, 30);
    unLikeBtn.right   = self.width;
    unLikeBtn.bottom  = self.height;
    
    CGFloat   padding = 12;
    zhiDing.frame     = CGRectMake(padding, 0, 30, 15);
    zhiDing.bottom    = self.height - 10;
    CGFloat ftWidth   = [fromeAndTime.text sizeWithAttributes:@{NSFontAttributeName:fromeAndTime.font}].width + 4;
    fromeAndTime.frame  = CGRectMake(padding, 0, ftWidth, 12);
    fromeAndTime.bottom = self.height - padding;
    if (_model.stickyTopFlag) {
        fromeAndTime.left =  zhiDing.right + 5;
    }
    
    replay.frame        = CGRectMake(fromeAndTime.right + 10, 0, 70, 16);
    replay.centerY      = fromeAndTime.centerY + 2;
    replay.titleEdgeInsets = UIEdgeInsetsMake(-2, 2, 0, 0);
    
    switch (_model.cellStyle) {
        case EDHCommonCellStyleOnelyText:
        {
            textLabel.frame = CGRectMake(padding, padding, self.width - padding*2,_model.textHeight);
            
        }
            break;
        case EDHCommonCellStyleIMG1:
        {
            bigImageView.hidden   = NO;
            textLabel.frame       = CGRectMake(padding, padding, self.width - padding*2,_model.textHeight);
            bigImageView.frame    = CGRectMake(padding, textLabel.bottom + 5, self.width - 20, _model.imageHeight);
            bigImageView.backgroundColor = MAINCOLOR;
        }
            break;
        case EDHCommonCellStyleIMG3:
        {
            imagesView.hidden     = NO;
            textLabel.frame = CGRectMake(padding, padding, self.width - padding*2,_model.textHeight);
            imagesView.frame = CGRectMake(padding, textLabel.bottom + 5, self.width - 20, _model.imageHeight);

            for (UIView *view in imagesView.subviews) {
                [view removeFromSuperview];
            }
            CGFloat space   = 10;
            CGSize  imgSize = CGSizeMake((SCREEN_WIDTH - space*4)/3, imagesView.height);
            for (NSInteger i = 0; i<_model.imageList.count; i++) {
                EDBaseImageView *sImgView = [[EDBaseImageView alloc]initWithFrame:CGRectMake(i*(imgSize.width + space), 0, imgSize.width, imgSize.height)];
                sImgView.contentMode = UIViewContentModeScaleAspectFill;
                sImgView.clipsToBounds = YES;
                ImageInfo *aImg = _model.imageList[i];
                [sImgView sd_setImageWithURL:[NSURL URLWithString:aImg.img] placeholderImage:[UIImage imageNamed:@"default_article_small"]];
                [imagesView addSubview:sImgView];
            }
        }
            break;
        case EDHCommonCellStyleIMGRight:
        {
            rightImageView.hidden = NO;
            textLabel.frame = CGRectMake(padding, padding, self.width - 150,_model.textHeight);
            CGFloat scale   = 112/80.0f;
            rightImageView.frame = CGRectMake(0, 0, scale*_model.imageHeight, _model.imageHeight);
            rightImageView.right   = self.width - 10;
            rightImageView.centerY = self.height/2;
            unLikeBtn.right        = rightImageView.left - 10;
            
        }
            break;
            
        default:
            break;
    }
    
}

-(void)setModel:(EDHomeNewsModel *)model
{
    _model = model;
    rightImageView.hidden = YES;
    bigImageView.hidden   = YES;
    imagesView.hidden     = YES;
    
    textLabel.text    = model.title;
    if (_model.hasRead) {
        textLabel.textColor = COLOR_999;
        
    }else{
        textLabel.textColor = COLOR_333;
        
    }
    zhiDing.hidden = !_model.stickyTopFlag;
//    fromeAndTime.text = [NSString stringWithFormat:@"%@  %@",model.author,model.releaseTimeStr];
    fromeAndTime.text = model.releaseTimeStr;
    
    replay.hidden = [_model.commentCount integerValue] <= 0;
    [replay setTitleColor:COLOR_999 forState:UIControlStateNormal];
    [replay setTitle:_model.commentCount forState:UIControlStateNormal];
    
    UIImage *repImg = [UIImage iconWithInfo:TBCityIconInfoMake(commentIcon, 16, COLOR_999)];
    [replay setImage:repImg forState:UIControlStateNormal];
    
    switch (model.cellStyle) {
        case EDHCommonCellStyleOnelyText:
        {
            
        }
            break;
        case EDHCommonCellStyleIMG1:
        {
            bigImageView.hidden   = NO;
            if (NOTEmpty(_model.imageList)) {
                ImageInfo *firstImg = _model.imageList[0];
                [bigImageView sd_setImageWithURL:[NSURL URLWithString:firstImg.img] placeholderImage:[UIImage imageNamed:@"default_article_title"]];

            }

        }
            break;
        case EDHCommonCellStyleIMG3:
        {
            imagesView.hidden     = NO;
            
        }
            break;
        case EDHCommonCellStyleIMGRight:
        {
            rightImageView.hidden = NO;
            if (NOTEmpty(_model.imageList)) {
                ImageInfo *imgInfo = _model.imageList[0];
                [rightImageView sd_setImageWithURL:[NSURL URLWithString:imgInfo.img] placeholderImage:[UIImage imageNamed:@"default_article_small"]];

            }
           
        }
            break;
            
        default:
            break;
    }

}

-(void)setRead:(BOOL)read
{
    _read = read;
    textLabel.textColor = COLOR_999;
}


-(void)showPopmenu:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(edHCommonCell:sourceView:model:)]) {
        [_delegate edHCommonCell:self sourceView:sender model:_model];
    }
}


-(void)deleteModel
{
    if (_delegate && [_delegate respondsToSelector:@selector(edHCommonCell:didDelete:)]) {
        [_delegate edHCommonCell:self didDelete:_model];
    }
}
#pragma theme
-(void)themeCheck
{
    [super themeCheck];
    textLabel.textColor = T_TITLE_COLOR;
    unLikeBtn.backgroundColor = Cell_CONTENT_COLOR;
   
}



@end
