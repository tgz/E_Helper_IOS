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
#import "AttendanceRecord.h"

@interface Locator()<NSXMLParserDelegate>
@property (nonatomic,strong)NSMutableString *tempString;
@property (nonatomic,copy)NSString *attendanceInsertResult;
@property (nonatomic,strong)AttendanceRecord *tempAttendRecord;
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
    
    NSLog(@"Result:\n%@\n", [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    [self analyseResult:responseData];
    
    //解析成功的情况下，继续解析实际列表
    if (self.isSuccess) {
        self.attendanceInsertResult = [NSString stringWithFormat:@"<Result>%@</Result>",self.attendanceInsertResult];
        [self analyseResult:[self.attendanceInsertResult dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [self.locations enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
        if ([obj isKindOfClass:[AttendanceRecord class]]) {
            NSLog(@"%d,%@",idx,obj);
        }
        
    }];
    
    //考勤后，把考勤地点记录下来备用。
    [self saveLocation];
    
    
    NSLog(@"%@",self.locations);
}

- (void)getAttendanceRecord {
    NSString *validateData = [VerifyTool CreateNewToken];
    
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    
    [dateFormater setDateFormat:@"yyyy-MM-dd"];
    NSDate *currentDate = [NSDate date];
    
    
    NSString *datetime =[dateFormater stringFromDate:currentDate]; // @"2015-07-13";//[[NSString alloc]init];
    NSLog(@"======> currentDate: %@", datetime);
    NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><GetWorkAttendanceRecord xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><Token i:type=\"d:string\">%@</Token><UserGuid i:type=\"d:string\">%@</UserGuid><dt i:type=\"d:string\">%@</dt></GetWorkAttendanceRecord></v:Body></v:Envelope>",validateData,self.userGuid,datetime];
    
    //创建URL
    NSString *address =@"http://oa.epoint.com.cn/WebServiceManage/EMWebService.asmx";
    NSURL* url = [NSURL URLWithString:address];
    //创建请求
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    [theRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
    [theRequest addValue: @"http://tempuri.org/GetWorkAttendanceRecord" forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"\nsoapMessage:\n%@\n",soapMessage);
    
    NSURLResponse *response;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:theRequest
                                                 returningResponse:&response
                                                             error:&error];
    
    NSLog(@"Result:\n%@\n", [[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]);
    
    [self analyseResult:responseData];
    
    //解析成功的情况下，继续解析实际列表
    if (self.isSuccess) {
        self.attendanceInsertResult = [NSString stringWithFormat:@"<Result>%@</Result>",self.attendanceInsertResult];
        [self analyseResult:[self.attendanceInsertResult dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [self.locations enumerateObjectsUsingBlock:^(id  __nonnull obj, NSUInteger idx, BOOL * __nonnull stop) {
        if ([obj isKindOfClass:[AttendanceRecord class]]) {
            NSLog(@"%d,%@",idx,obj);
        }
    }];
    
    NSLog(@"%@",self.locations);
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

- (void)saveLocation {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.location forKey:@"Location"];
    [userDefaults synchronize];
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
    self.attendanceInsertResult = [[NSString alloc]init];
    self.locations = [[NSMutableArray alloc]init];
    
}

- (void)parser:(nonnull NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary *)attributeDict {

    NSLog(@"StartElement:%@",elementName);
    [self.tempString setString:@""];
    
    if (!self.tempAttendRecord) {
        self.tempAttendRecord = [[AttendanceRecord alloc]init] ;
       
    }
}

- (void)parser:(nonnull NSXMLParser *)parser foundCharacters:(nonnull NSString *)string {
    //NSLog(@"读取到内容：%@",string);
    if (self.tempString == nil) {
        self.tempString = [[NSMutableString alloc]init];
    }
    [self.tempString appendString:string];

}

- (void)parser:(nonnull NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {

    //NSLog(@"%@读取完毕！:%@",elementName,self.tempString);
    if ([elementName isEqualToString:@"MobileWorkAttendanceInsertResult"]
        || [elementName isEqualToString:@"GetWorkAttendanceRecordResult"]) {
        self.attendanceInsertResult = self.tempString;
        
        NSLog(@"获取到签到列表内容：%@",self.attendanceInsertResult); 
    }
    
    if ([elementName isEqualToString:@"AttendTime"]) {
        //
        self.tempAttendRecord.AttendTime = self.tempString;
    }
    if ([elementName isEqualToString:@"AttendLocation"]) {
        //
        
        self.tempAttendRecord.AttendLocation = self.tempString;
    }
    
    if ([elementName isEqualToString:@"Record"]) {
        [self.locations addObject:self.tempAttendRecord];
        self.tempAttendRecord = nil;
    }
}

- (void)parser:(nonnull NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {
    NSLog(@"解析发生错误！%@",parseError.localizedDescription);
    self.isSuccess = NO;
    self.failDescription = parseError.localizedDescription;
}

- (void)parserDidEndDocument:(nonnull NSXMLParser *)parser {
    NSLog(@"XML解析完毕");
    self.isSuccess = YES;
}







#pragma mark - getters 

//- (AttendanceRecord *)tempAttendRecord {
//    if (_tempAttendRecord ==nil) {
//        _tempAttendRecord = [[AttendanceRecord alloc]init];
//    }
//    return _tempAttendRecord;//[_tempAttendRecord copy];
//}







@end


