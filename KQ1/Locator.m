//
//  Locator.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/12.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "Locator.h"
#import "StringXMLTool.h"
#import "VerifyTool.h"

@interface Locator()<NSXMLParserDelegate>
@property (nonatomic,strong)NSMutableString *tempString;
@end

@implementation Locator

#pragma mark - init

- (instancetype)initWithUser:(NSString *)userGuid location:(NSString *)location {
    if(self = [super init]){
        self.userGuid = userGuid;
        self.location = location;
    }
    return self;
}

+ (instancetype)locatorWithUser:(NSString *)userGuid location:(NSString *)location {
    return [[Locator alloc]initWithUser:userGuid location:location];
}


#pragma mark - methods

- (void)kaoQin {
    StringXMLTool *strhelp = [[StringXMLTool alloc]init];
    NSString *validateData = [VerifyTool CreateNewToken];
    
    NSString *formatLocation =[strhelp convert2Unicode:self.location];
    
    NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><MobileWorkAttendanceInsert xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><UserGuid i:type=\"d:string\">%@</UserGuid><AttendLocation i:type=\"d:string\">%@</AttendLocation><Token i:type=\"d:string\">%@</Token></MobileWorkAttendanceInsert></v:Body></v:Envelope>",self.userGuid,formatLocation,validateData];
    
    //创建URL
    NSString *address =@"http://oa.epoint.com.cn/WebServiceManage/EMWebService.asmx";
    NSURL* url = [NSURL URLWithString:address];
    //创建请求
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
    [theRequest addValue: @"http://tempuri.org/MobileWorkAttendanceInsert" forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"\nsoapMessage:\n%@\n",soapMessage);
    
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest
                                                 returningResponse:&response
                                                             error:&error];
    
    [self analyseResult:responseData];

}



#pragma mark - old


+(BOOL)DoKaoQin:(NSString *)Location UserGuid:(NSString *)userGuid
{
    StringXMLTool *strhelp = [[StringXMLTool alloc]init];
    NSString *validateData = [VerifyTool CreateNewToken];
    NSString *formatLocation =[strhelp convert2Unicode:Location];
    NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><MobileWorkAttendanceInsert xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><UserGuid i:type=\"d:string\">%@</UserGuid><AttendLocation i:type=\"d:string\">%@</AttendLocation><Token i:type=\"d:string\">%@</Token></MobileWorkAttendanceInsert></v:Body></v:Envelope>",userGuid,formatLocation,validateData];
    
    NSString *address =@"http://oa.epoint.com.cn/WebServiceManage/EMWebService.asmx";
    NSURL* url = [NSURL URLWithString:address];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    
    
    // 然后就是text/xml, 和content-Length必须有。
    [theRequest addValue: @"text/xml; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
    [theRequest addValue: @"http://tempuri.org/MobileWorkAttendanceInsert" forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    //    不需要这一步，下面会再请求一次。
    //    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
    //    if(!theConnection) {
    //        NSLog(@"TheConnection Fial");
    //        return NO;
    //
    //    }
    
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest
                                                 returningResponse:&response
                                                             error:&error];
    NSMutableString * result = [[NSMutableString alloc]initWithData:responseData
                                                           encoding:NSUTF8StringEncoding];
    if(error)
    {
        NSLog(@"ReponseError:\n\n%@\n\nDebugDescription:\n%@\n",error.description,error.debugDescription);
        return NO;
    }
    NSLog(@"Return String is ======⬇️⬇️⬇️\n%@",result);
    return YES;
    
}

+(NSString *)DoKaoQin4XML:(NSString *)Location UserGuid:(NSString *)userGuid
{
    
    StringXMLTool *strhelp = [[StringXMLTool alloc]init];
    NSString *validateData = [VerifyTool CreateNewToken];
    
    NSString *formatLocation =[strhelp convert2Unicode:Location];
    
    NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><MobileWorkAttendanceInsert xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><UserGuid i:type=\"d:string\">%@</UserGuid><AttendLocation i:type=\"d:string\">%@</AttendLocation><Token i:type=\"d:string\">%@</Token></MobileWorkAttendanceInsert></v:Body></v:Envelope>",userGuid,formatLocation,validateData];
    
    //创建URL
    NSString *address =@"http://oa.epoint.com.cn/WebServiceManage/EMWebService.asmx";
    NSURL* url = [NSURL URLWithString:address];
    //创建请求
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
    [theRequest addValue: @"http://tempuri.org/MobileWorkAttendanceInsert" forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"\nsoapMessage:\n%@\n",soapMessage);
    
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest
                                                 returningResponse:&response
                                                             error:&error];
    NSMutableString * result = [[NSMutableString alloc]initWithData:responseData
                                                           encoding:NSUTF8StringEncoding];
    
    
    NSLog(@"result:\n%@",result);
    if(error)
    {
        
        return  @"ReponseErrorDebugDescription:\n%@\n",error.debugDescription;
        
    }
    
    StringXMLTool *str = [[StringXMLTool alloc]init];
    NSString *correctResult = [str getXMLAttFromStringXML:result Attribute:@"MobileWorkAttendanceInsertResult"];
    if (correctResult) {
        return correctResult;
    }else
    {
        return [str getXMLAttFromStringXML:result Attribute:@"soap:Fault"];
    }
    
}

+(BOOL)SaveLocation:(NSString *)location
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:location forKey:@"Location"];
    return  [userDefaults synchronize];
    
}
+(NSString *)ReadLocation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults stringForKey:@"Location"];
}

#pragma mark - NSXmlParser Delegate

- (void)analyseResult:(NSData *)data {

    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
    parser.delegate = self;
    
    [parser setShouldProcessNamespaces:NO];
    [parser parse];
}


- (void)parserDidStartDocument:(nonnull NSXMLParser *)parser {
    NSLog(@"开始解析");
}

- (void)parser:(nonnull NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {

    NSLog(@"StartElement:%@",elementName);
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

    NSLog(@"%@读取完毕！:%@",elementName,self.tempString);
}

- (void)parser:(nonnull NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {
    NSLog(@"解析发生错误！%@",parseError.localizedDescription);

}

- (void)parserDidEndDocument:(nonnull NSXMLParser *)parser {
    NSLog(@"XML解析完毕");
}















@end


