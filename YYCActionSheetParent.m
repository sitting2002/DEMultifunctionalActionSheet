//
//  YYCActionSheetParent.m
//
//
//  Created by Decade on 16/1/19.
//  Copyright © 2016年 HGG. All rights reserved.
//

#import "YYCActionSheetParent.h"
#import "YYCButtonP.h"
#import "OrderItem.h"
#import "H5ShareItem.h"
#import "YYCShareWeiboEditVC.h"

@implementation YYCActionSheetParent

#pragma mark - 基础单例
+(YYCActionSheetParent *)sharedInstances{
    static YYCActionSheetParent *sharedInstance = nil;
    sharedInstance = [[YYCActionSheetParent alloc] initForAutoLayout];
    return sharedInstance;
}

-(void)setupBaseview:(YYCActionSheetParent *)sharedInstance bgviewtag:(NSInteger)bgviewtag line2tag:(NSInteger)line2tag cancelBtnTitle:(NSString *)cancelBtnTitle{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 215*2)];
    bgview.tag = bgviewtag;
    bgview.backgroundColor = [UIColor whiteColor];
    [sharedInstance addSubview:bgview];
    
    UIButton *cancelBtn = [[UIButton alloc]initForAutoLayout];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitle:cancelBtnTitle forState:UIControlStateNormal];
    [cancelBtn setTitleColor:UIColorFromRGB(0xafafaf) forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [bgview addSubview:cancelBtn];
    [cancelBtn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
    [cancelBtn autoSetDimension:ALDimensionHeight toSize:50];
    
    UIView *line2 = [[UIView alloc]initForAutoLayout];
    line2.backgroundColor = UIColorFromRGB(0xf8f6f6);
    line2.tag = line2tag;
    [bgview addSubview:line2];
    [line2 autoSetDimension:ALDimensionHeight toSize:1];
    [line2 autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
    [line2 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:cancelBtn];
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sharedInstance.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        bgview.frame = CGRectMake(0, SCREEN_HEIGHT - 215*2, SCREEN_WIDTH, 215*2);
    } completion:^(BOOL finished) {
        
    }];
    
    __block YYCActionSheetParent *sharedInstanceBlock = sharedInstance;
    [sharedInstance addAction:^(UIButton *btn) {
        [self showAnimate:sharedInstanceBlock bgview:bgview];
    }];
    
    [cancelBtn addAction:^(UIButton *btn) {
        [self showAnimate:sharedInstanceBlock bgview:bgview];
    }];
}

-(void)showAnimate:(YYCActionSheetParent *)sharedInstanceBlock bgview:(UIView *)bgview{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        sharedInstanceBlock.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        bgview.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 215*2);
    } completion:^(BOOL finished) {
        [sharedInstanceBlock removeFromSuperview];
//        sharedInstanceBlock = nil;
    }];
}

#pragma mark - 推送提示相关
-(void)showNotificationActionSheet{
    YYCActionSheetParent *sharedInstance = [YYCActionSheetParent sharedInstances];
    sharedInstance.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [[[appDelegate window]rootViewController].view addSubview:sharedInstance];
    [sharedInstance autoPinEdgesToSuperviewEdges];
    
    [self setupBaseview:sharedInstance bgviewtag:20160129 line2tag:2016012901 cancelBtnTitle:LOCALIZATION(@"YYCnotificationActionSheet")];
}

#pragma mark - 分享相关
-(void)showShareActionSheet:(shareFrom)shareFrom shareObject:(id)shareObject{
    YYCActionSheetParent *sharedInstance = [YYCActionSheetParent sharedInstances];
    sharedInstance.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [[[appDelegate window]rootViewController].view addSubview:sharedInstance];
    [sharedInstance autoPinEdgesToSuperviewEdges];
    
    [self setupBaseview:sharedInstance bgviewtag:20160125 line2tag:2016012501 cancelBtnTitle:LOCALIZATION(@"YYCMyVCloginNotice2")];
    
    UIView *bgview = [sharedInstance viewWithTag:20160125];
    UIView *line2 = [sharedInstance viewWithTag:2016012501];
    
    YYCButtonP *wechatBtn = [[YYCButtonP alloc]initForAutoLayout:[UIImage imageNamed:@"YYC_50_wechat_c"] title:LOCALIZATION(@"YYCwechatFriend")];
    [bgview addSubview:wechatBtn];
    YYCButtonP *wechatCycleBtn = [[YYCButtonP alloc]initForAutoLayout:[UIImage imageNamed:@"YYC_50_wechat_moment_c"] title:LOCALIZATION(@"YYCwechatCycle")];
    [bgview addSubview:wechatCycleBtn];
    YYCButtonP *weiboBtn = [[YYCButtonP alloc]initForAutoLayout:[UIImage imageNamed:@"YYC_50_sina_weibo_c"] title:LOCALIZATION(@"YYCweibo")];
    [bgview addSubview:weiboBtn];
    YYCButtonP *copyBtn = [[YYCButtonP alloc]initForAutoLayout:[UIImage imageNamed:@"YYC_50_copylink"] title:LOCALIZATION(@"YYCcopylink")];
    [bgview addSubview:copyBtn];
    
    //prepare for share
    
    [wechatBtn.imgbtn addAction:^(UIButton *btn) {
        [self prepareShareTextwithshareFrom:shareFrom shareObject:shareObject];
        [self ShareToWechat];
    }];
    [wechatCycleBtn.imgbtn addAction:^(UIButton *btn) {
        [self prepareShareTextwithshareFrom:shareFrom shareObject:shareObject];
        [self ShareToWechatCircle];
    }];
    [weiboBtn.imgbtn addAction:^(UIButton *btn) {
        [self prepareWeiboShareTextwithshareFrom:shareFrom shareObject:shareObject];
        [self ShareToWeibo:sharedInstance bgview:bgview];
    }];
    [copyBtn.imgbtn addAction:^(UIButton *btn) {
        [self prepareShareTextwithshareFrom:shareFrom shareObject:shareObject];
        [self copyToPasteboard:sharedInstance bgview:bgview];
    }];
    
    UIView *line1 = [[UIView alloc]initForAutoLayout];
    line1.backgroundColor = UIColorFromRGB(0xf8f6f6);
    [bgview addSubview:line1];
    [line1 autoSetDimension:ALDimensionHeight toSize:1];
    [line1 autoSetDimension:ALDimensionWidth toSize:SCREEN_WIDTH];
    [line1 autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:wechatBtn withOffset:-20];
    
    NSArray *Buttons = @[wechatBtn, wechatCycleBtn, weiboBtn, copyBtn];
    [Buttons autoSetViewsDimension:ALDimensionHeight toSize:50 + 35];
    [Buttons autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10 insetSpacing:YES matchedSizes:YES];
    [wechatBtn autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:line2 withOffset:-20];
    
    YYCButtonP *headPicture = [[YYCButtonP alloc]initForAutoLayout:[UIImage imageNamed:@"YYC_50_sharing"] title:LOCALIZATION(@"YYCshareheadTitle")];
    headPicture.textbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [headPicture setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [bgview addSubview:headPicture];
    [headPicture autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [headPicture autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:line1 withOffset:-30];
}

-(void)prepareShareTextwithshareFrom:(shareFrom)shareFrom shareObject:(id)shareObject{
    if (shareFrom == concertShare) {/**< 演出分享 */
        Concert *shareData = (Concert *)shareObject;
        self.shareTitletext = [NSString stringWithFormat:@"「%@」", shareData.title];
        self.shareContenttext = [NSString stringWithFormat:@"%@在%@", [shareData getTimeTextFirstandLast], shareData.scene.name];
        self.shareImg = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100", shareData.posterOrigin];
        self.shareUrl = [NSString stringWithFormat:@"%@/%@/%@", API_HOST, @"show", shareData.performanceId];
    }else if (shareFrom == htmlShare){/**< 网页分享 */
        H5ShareItem *shareData = (H5ShareItem *)shareObject;
        self.shareTitletext = [NSString stringWithFormat:@"「%@」", shareData.title];
        self.shareContenttext = [NSString stringWithFormat:@"%@", shareData.content];
        self.shareImg = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100", shareData.imageUrlString];
        self.shareUrl = [NSString stringWithFormat:@"%@", shareData.linkUrlString];
    }else if (shareFrom == orderShare){/**< 订单分享 */
        OrderItem *shareData = (OrderItem *)shareObject;
        self.shareTitletext = [NSString stringWithFormat:@"我买到票啦！一起去吗？「%@」", shareData.concertTitle];
        self.shareContenttext = [NSString stringWithFormat:@"%@在%@", shareData.ticketShowTimeString, shareData.concertLocation];
        self.shareImg = [NSString stringWithFormat:@"%@", shareData.concertPoster];
        self.shareUrl = [NSString stringWithFormat:@"%@/%@/%@", API_HOST, @"show", shareData.concertID];
    }else if (shareFrom == couponShare){/**< 优惠券分享 */
        BannerCouponSetting *shareData = (BannerCouponSetting *)shareObject;
        self.shareTitletext = [NSString stringWithFormat:@"%@", shareData.weixin.title];
        self.shareContenttext = [NSString stringWithFormat:@"%@", shareData.weixin.content];
        self.shareImg = [NSString stringWithFormat:@"%@", shareData.weixin.image];
        self.shareUrl = [NSString stringWithFormat:@"%@", shareData.weixin.link];
    }else if (shareFrom == articleShare){/**< 文章分享 */
        News *shareData = (News *)shareObject;
        self.shareTitletext = [NSString stringWithFormat:@"「%@」", shareData.title];
        self.shareContenttext = [NSString stringWithFormat:@""];
        self.shareImg = [NSString stringWithFormat:@"%@?imageView2/1/w/100/h/100", shareData.cover];
        self.shareUrl = [NSString stringWithFormat:@"%@", shareData.url];
    }else if (shareFrom == cicleShare){/**< 圈点分享 */
    
    }else if (shareFrom == aboutShare){/**< 关于分享 */
        self.shareTitletext = [NSString stringWithFormat:@""];
        self.shareContenttext = [NSString stringWithFormat:@""];
        self.shareImg = @"";
        self.shareUrl = @"";
    }else if (shareFrom == redPacketShare){/**< 红包分享 */
        NSDictionary *shareData = (NSDictionary *)shareObject;
        self.shareTitletext = [NSString stringWithFormat:@"%@", shareData[@"weixin"][@"title"]];
        self.shareContenttext = [NSString stringWithFormat:@"%@", shareData[@"weixin"][@"content"]];
        self.shareImg = [NSString stringWithFormat:@"%@", shareData[@"weixin"][@"image"]];
        self.shareUrl = [NSString stringWithFormat:@"%@", shareData[@"weixin"][@"link"]];
    }
}

-(void)prepareWeiboShareTextwithshareFrom:(shareFrom)shareFrom shareObject:(id)shareObject{
    if (shareFrom == concertShare) {/**< 演出分享 */
        Concert *shareData = (Concert *)shareObject;
        self.shareContenttext = [NSString stringWithFormat:@"「%@」 @ %@/%@/%@ ", shareData.title, API_HOST, @"show", shareData.performanceId];
        self.shareUrl = shareData.posterOrigin;
    }else if (shareFrom == htmlShare){/**< 网页分享 */
        H5ShareItem *shareData = (H5ShareItem *)shareObject;
        self.shareContenttext = [NSString stringWithFormat:@"「%@」 @ %@", shareData.title, shareData.linkUrlString];
        self.shareUrl = shareData.imageUrlString;
    }else if (shareFrom == orderShare){/**< 订单分享 */
        OrderItem *shareData = (OrderItem *)shareObject;
        self.shareContenttext = [NSString stringWithFormat:@"我买到票啦！一起去吗？「%@」 @ %@/%@/%@ ", shareData.concertTitle, API_HOST, @"show", shareData.concertID];
        self.shareUrl = shareData.concertPoster;
    }else if (shareFrom == couponShare){/**< 优惠券分享 */
        BannerCouponSetting *shareData = (BannerCouponSetting *)shareObject;
        self.shareContenttext = [NSString stringWithFormat:@"「%@」 @ %@", shareData.weibo.title, shareData.weibo.link];
        self.shareUrl = shareData.weibo.image;
    }else if (shareFrom == articleShare){/**< 文章分享 */
        News *shareData = (News *)shareObject;
        self.shareContenttext = [NSString stringWithFormat:@"「%@」 @ %@", shareData.title, shareData.url];
        self.shareUrl = shareData.cover;
    }else if (shareFrom == cicleShare){/**< 圈点分享 */
        
    }else if (shareFrom == aboutShare){/**< 关于分享 */
        self.shareContenttext = @"";
        self.shareUrl = nil;
    }else if (shareFrom == redPacketShare){/**< 红包分享 */
        NSDictionary *shareData = (NSDictionary *)shareObject;
        self.shareContenttext = [NSString stringWithFormat:@"%@ @ %@", shareData[@"weibo"][@"content"], shareData[@"weibo"][@"link"]];
        self.shareUrl = [NSString stringWithFormat:@"%@", shareData[@"weibo"][@"image"]];
    }
}

-(void)wechatShareAction:(ShareType)shareType content:(NSString *)content img:(NSString *)img title:(NSString *)title url:(NSString *)url{
    if (![WXApi isWXAppInstalled]) {
        [GGUtil showGGAlert:@"您还没有安装微信" title:@"提醒"];
        return;
    }
    
    if (![GGUtil checkNetworkConnection]) {
        [GGUtil showHUD:LOCALIZATION(@"ShareViewWithoutNetwork") inView:[[UIApplication sharedApplication] keyWindow] hideAfter:1];
        return;
    }
    
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@""
                                                image:[ShareSDK imageWithUrl:img]
                                                title:title
                                                  url:url
                                          description:nil
                                            mediaType:SSPublishContentMediaTypeNews];
    
    [ShareSDK shareContent:publishContent type:shareType authOptions:nil statusBarTips:NO result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
        if (state == SSPublishContentStateSuccess){
            NSLog(@"发表成功");
        }else if (state == SSPublishContentStateFail){
            NSLog(@"发布失败! error code == %@, error code == %@", @([error errorCode]), [error errorDescription]);
        }
    }];
}

-(void)ShareToWechat{
    [self wechatShareAction:ShareTypeWeixiSession content:self.shareContenttext img:self.shareImg title:self.shareTitletext url:self.shareUrl];
}

-(void)ShareToWechatCircle{
    [self wechatShareAction:ShareTypeWeixiTimeline content:self.shareContenttext img:self.shareImg title:self.shareTitletext url:self.shareUrl];
}

-(void)copyToPasteboard:(YYCActionSheetParent *)sharedInstance bgview:(UIView *)bgview{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithFormat:@"%@\n%@", self.shareTitletext, self.shareUrl];
    MBProgressHUD *copyTips = [MBProgressHUD showHUDAddedTo:sharedInstance  animated:YES];
    [copyTips setLabelText:LOCALIZATION(@"ShareViewCopySucceed")];
    copyTips.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    [copyTips setMode:MBProgressHUDModeCustomView];
    [copyTips hide:YES afterDelay:1];
    /**< GCD延时 */
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC));
    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
        [self showAnimate:sharedInstance bgview:bgview];
    });
}

-(void)ShareToWeibo:(YYCActionSheetParent *)sharedInstanceBlock bgview:(UIView *)bgview{
    [self showAnimate:sharedInstanceBlock bgview:bgview];
    WEAKSELF
    [YYCAccount bindShareWithType:ShareTypeSinaWeibo withBlock:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
        [weakSelf jumpToShareEditViewWithShareType:ShareTypeSinaWeibo];
    }];
}

-(void)jumpToShareEditViewWithShareType:(ShareType)type{
    YYCShareWeiboEditVC *editVC = [[YYCShareWeiboEditVC alloc]init];
    editVC.picUrl = self.shareUrl;
    editVC.contentText = self.shareContenttext;
    [((YYCNaviPVC *)[((RDVTabBarController *)[[appDelegate window]rootViewController]) selectedViewController]) pushViewController:editVC animated:YES];
}
    
@end
