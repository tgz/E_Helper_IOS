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

@property(nonatomic,strong)NSMutableString *tempString;

@property (nonatomic,strong)User *user;

@end

@implementation UserLoginResult

- (instancetype)initWithResultContent:(NSString *)resultString {
    if(self = [super init]){
    _loginResult = resultString;
    }
    return self;
}

- (BOOL)analyseLoginResultToUser:(User *)user {
    self.user = user;
    
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:[self.loginResult dataUsingEncoding:enc]];
    parser.delegate = self;
    
    [parser setShouldProcessNamespaces:NO];
    
    [parser parse];
    
    NSLog(@"%@,%@,%@,%d,%@",self.user.userName,self.user.ouName,self.user.userGuid,self.user.isLogin,self.user.failDescription);
    return self.user.isLogin;
}

#pragma mark - XMLParser Delegate

- (void)parserDidStartDocument:(nonnull NSXMLParser *)parser {
    //NSLog(@"开始解析");
    
}

- (void)parser:(nonnull NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary*)attributeDict {
    //NSLog(@"取得节点：%@",elementName);
    
    [self.tempString setString:@""];
}

- (void)parser:(nonnull NSXMLParser *)parser foundCharacters:(nonnull NSString *)string {
    //NSLog(@"读取到内容：%@",string);
    if (self.tempString == nil) {
        self.tempString = [[NSMutableString alloc]init];
    }
    [self.tempString appendString:string];
}

- (void)parser:(nonnull NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    
    if ([elementName isEqualToString:@"UserLogin"]) {
        if ([self.tempString isEqualToString:@"True"]) {
            self.user.isLogin = YES;
        }
    }
    
    if ([elementName isEqualToString:@"UserGuid"]) {
        self.user.userGuid = [NSString stringWithString:self.tempString];
    }
    
    if ([elementName isEqualToString:@"UserDisplayName"]) {
        self.user.userName = [NSString stringWithString:self.tempString];
    }
    
    if ([elementName isEqualToString:@"OUName"]) {
        self.user.ouName = [NSString stringWithString:self.tempString] ;
    }
    
    if ([elementName isEqualToString:@"Description"]) {
        self.user.failDescription = [NSString stringWithString:self.tempString];
    }
}


- (void)parserDidEndDocument:(nonnull NSXMLParser *)parser {
    //NSLog(@"解析完成！");
}

- (void)parser:(nonnull NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {
    NSLog(@"解析发生错误！%@",parseError.localizedDescription);
    self.user.isLogin = NO;
    self.user.failDescription = parseError.localizedDescription;
}

#pragma mark - getters and setters
- (User *)user{
    if (_user == nil) {
        _user = [[User alloc]init];
        _user.isLogin = NO;
        _user.failDescription = @"尚未登陆！";
    }
    return _user;
}

@end
