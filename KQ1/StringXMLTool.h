//
//  StringXMLTool.h
//  KQ1
//
//  Created by 邱 士川 on 15/7/9.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringXMLTool : NSObject
- (NSString *)stringByDecodingXMLEntities:(NSString *)input;

-(NSString *)getXMLAttFromHtmlEncodeXML:(NSString *)HtmlEncodeXML Attribute:(NSString *) attr;
-(NSString *)getXMLAttFromStringXML:(NSString *)XML Attribute:(NSString *) attr;
-(NSString *)getDescriptionString:(NSString *)xml Attribute:(NSString *)attr;
-(NSString *)convert2Unicode:(NSString *)str;
@end
