//
//  QPHttpManager.h
//  QuickPay
//
//  Created by Nie on 2016/11/4.
//  Copyright © 2016年 Nie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QPRequestService.h"
@interface QPHttpManager : NSObject
/**
 *  获取要生成订单的字符串
 *  @param amount 金额 精确到分 最多到十万位
 *  @param type   支付类型  微信 :2 ;
 *  @param handler 完成后的回调
 */
+ (void)getQRcodeString:(NSString *)amount
                 PayTye:(NSString *)type
            Completion:(QPRequestSuccessHandler)handler
               failure:(QPRequestFailureHandler)failhandler;

/**
 *  交易查询接口
 *  @param orderId 订单ID
 *
 *  @param handler 完成后的回调
 */

+ (void)getOrderDetail:(NSString *)orderId
             Completion:(QPRequestSuccessHandler)handler
                failure:(QPRequestFailureHandler)failhandler;


/**
 *  登录接口
 *  @param phoneStr 用户名：手机号
 *  @param password 密码
 *  @param handler 完成后的回调
 */

+ (void)loginWithUsename:(NSString *)phoneStr
                Password:(NSString *)password
      Completion:(QPRequestSuccessHandler)handler
         failure:(QPRequestFailureHandler)failhandler;

/**
 *  获取商户基本信息接口
 *
 *  @param handler 完成后的回调
 */

+ (void)getMerinfoCompletion:(QPRequestSuccessHandler)handler
           failure:(QPRequestFailureHandler)failhandler;



@end
