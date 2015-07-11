//
//  UserLoginResult.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/11.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "UserLoginResult.h"
#import "User.h"

@interface UserLoginResult()<NSXMLParserDelegate>
@property(nonatomic,copy)NSString *loginResult;
@property(nonatomic,copy)NSString *userGuid;
@property(nonatomic,copy)NSString *userDisplayName;
@property(nonatomic,copy)NSString *ouName;
@property(nonatomic,assign)BOOL isLogin;

@end

@implementation UserLoginResult

- (instancetype)initWithResultContent:(NSString *)resultString {
    if(self = [super init]){
    _loginResult = resultString;
    }
    return self;
}

- (User *)ayalyzeLoginResult {
    
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:[self.loginResult dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    
    [parser setShouldProcessNamespaces:NO];
    
    [parser parse];
    

    return [[User alloc]init];
}

#pragma mark - XMLParser Delegate

- (void)parserDidStartDocument:(nonnull NSXMLParser *)parser {

}

- (void)parser:(nonnull NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {

}

- (void)parser:(nonnull NSXMLParser *)parser foundCharacters:(nonnull NSString *)string {

}

- (void)parser:(nonnull NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {

}


- (void)parserDidEndDocument:(nonnull NSXMLParser *)parser {

}

- (void)parser:(nonnull NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {
    NSLog(@"%@",parseError.localizedDescription);
    
}

@end
