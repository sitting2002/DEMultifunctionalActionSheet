//
//  YYCActionSheetParent.h
//
//
//  Created by Decade on 16/1/19.
//  Copyright © 2016年 HGG. All rights reserved.
//

@interface YYCActionSheetParent : UIButton
/**
 *分享类型
 */
typedef enum{
    concertShare,/**< 演出分享 */
    htmlShare,   /**< 网页分享 */
    orderShare,  /**< 订单分享 */
    redPacketShare, /**< 红包分享 */
    couponShare, /**< 优惠券分享 */
    articleShare,/**< 文章分享 */
    cicleShare,  /**< 圈点分享 */
    aboutShare   /**< 关于分享 */
}shareFrom;

@property (nonatomic, strong) NSString *shareTitletext;
@property (nonatomic, strong) NSString *shareContenttext;
@property (nonatomic, strong) NSString *shareImg;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, strong) NSString *shareOtherinfo;

/**
 * 基础单例
 */
+(YYCActionSheetParent *)sharedInstances;

/**
 * 推送ActionSheet
 */
-(void)showNotificationActionSheet;

/**
 * 分享ActionSheet
 */
-(void)showShareActionSheet:(shareFrom)shareFrom shareObject:(id)shareObject;

/**
 * 微信分享相关
 */
-(void)prepareShareTextwithshareFrom:(shareFrom)shareFrom shareObject:(id)shareObject;
-(void)ShareToWechat;
-(void)ShareToWechatCircle;

/**
 * 微博分享相关
 */
-(void)prepareWeiboShareTextwithshareFrom:(shareFrom)shareFrom shareObject:(id)shareObject;
-(void)ShareToWeibo:(YYCActionSheetParent *)sharedInstanceBlock bgview:(UIView *)bgview;

@end
