//
//  WebserviceHelper.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/9.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebserviceHelper : NSObject

- (NSString *)RequsetWebservice:(NSString *)url andPostMessage:(NSString *)messageBody;
@end
