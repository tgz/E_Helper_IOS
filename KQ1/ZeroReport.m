//
//  ZeroReport.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/21.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "ZeroReport.h"
#import "VerifyTool.h"
#import "ZereReportEntity.h"
#import "AFNetworking.h"
@interface ZeroReport()<NSXMLParserDelegate> 
@property (nonatomic,strong)NSMutableString *tempString;
@property (nonatomic,copy)NSString *zReportInsertResult;
@property (nonatomic,copy)NSString *zReportUserViewResult;
@property (nonatomic,strong)ZereReportEntity *zeroReportEntity;


@end


@implementation ZeroReport


#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(nonnull NSXMLParser *)parser {
    
}


- (void)parser:(nonnull NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {
    //解析到新节点，清空临时变量的值
    [self.tempString setString:@""];
    if ([elementName isEqualToString:@"Report"]){
        self.zeroReportEntity = [[ZereReportEntity alloc]init];
    }
    
//    if ([elementName isEqualToString:@"ZReport_UserViewResult"]) {
//        self.zReportList = [[NSMutableArray alloc]init];
//    }
}


- (void)parser:(nonnull NSXMLParser *)parser foundCharacters:(nonnull NSString *)string {
    if (self.tempString == nil) {
        self.tempString = [[NSMutableString alloc]init];
    }
    [self.tempString appendString:string];
}

- (void)parser:(nonnull NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName {
    if ([elementName isEqualToString:@"ZReport_InsertResult"]) {
        self.zReportInsertResult = [NSString stringWithString:self.tempString];
        
        NSLog(@"%@",self.zReportInsertResult);
    }
    
    if ([elementName isEqualToString:@"ZReport_UserViewResult"]) {
        self.zReportUserViewResult = [NSString stringWithString:self.tempString];
    }
    
    if ([elementName isEqualToString:@"Status"]) {
        if ([self.tempString isEqualToString:@"True"]) {
            self.status = YES;
        }else {
            self.status = NO;
        }
    }
    
    if ([elementName isEqualToString:@"Description"]) {
        self.failDescription = self.tempString;
    }
    
    if ([elementName isEqualToString:@"RecordData"]) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        self.zeroReportEntity.recordDate = [formatter dateFromString:self.tempString];
        
        
    }
    if ([elementName isEqualToString:@"IsNullProblem"]) {
        if ([self.tempString isEqualToString:@"1"]) {
            self.zeroReportEntity.isNullProblem = YES;
        }else {
            self.zeroReportEntity.isNullProblem = NO;
        }
    }
    if ([elementName isEqualToString:@"Content"]) {
        self.zeroReportEntity.Content = [NSString stringWithString:self.tempString];
    }
    
    if ([elementName isEqualToString:@"Report"]) {
        [self.zReportList addObject:self.zeroReportEntity];
    }
    
    
}


- (void)parserDidEndDocument:(nonnull NSXMLParser *)parser {
    if (![self.zReportInsertResult isEqualToString:@""]) {
        //解析具体内容
    }
}

- (void)parser:(nonnull NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {
    NSLog(@"%@",parseError.localizedDescription);
    self.zReportInsertResult = nil;
}

#pragma mark - analyseResult
- (BOOL)analyseResult:(NSData *)response {
    NSLog(@"begin analyseREsult:%@",[[NSString alloc]initWithData:response encoding:NSUTF8StringEncoding]);
    
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:response];
    parser.delegate = self;
    [parser parse];
    
    [parser setShouldProcessNamespaces:NO];
    
    NSError *parseError = [parser parserError];
    
    if(parseError){
        
        NSLog(@"返回结果解析错误:\n%@",[parseError description]);
        self.status = NO;
        self.failDescription = [parseError description];
        return NO;
    }
    
    /**解析具体的返回状态信息*/
    if (self.zReportInsertResult) {
        [self analyseStatus];
    }
    
    if (self.status) {
        return YES;
    }else{
        return NO;
    }
    
    return NO;
    
}

- (void)analyseStatus {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:[self.zReportInsertResult dataUsingEncoding:enc]];
    parser.delegate = self;
    
    [parser setShouldProcessNamespaces:NO];
    
    [parser parse];
    
    NSError *parError = [parser parserError];
    if (parError) {
        self.status = NO;
        NSLog(@"Status解析错误：\n%@",[parError description]);
        self.failDescription = [parError description];
    }
}

- (void)analyseReportList {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSXMLParser *parser = [[NSXMLParser alloc]initWithData:[self.zReportUserViewResult dataUsingEncoding:enc]];
    parser.delegate = self;
    
    [parser setShouldProcessNamespaces:NO];
    
    [parser parse];
    
    NSError *parError = [parser parserError];
    if (parError) {
        self.status = NO;
        NSLog(@"Status解析错误：\n%@",[parError description]);
        self.failDescription = [parError description];
    }
}

#pragma mark - reportZero

- (BOOL)reportZero:(NSDate *)data UserGuid:(NSString *)userGuid {
    
    //初始化时间为今天：
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSString *currentDateStr = [dateFormat stringFromDate:data];
    NSString *validateData = [VerifyTool CreateNewToken];
    NSString *rowGuid = [[NSUUID UUID]UUIDString];
    NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><ZReport_Insert xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><ValidateData i:type=\"d:string\">%@</ValidateData><ParasXml i:type=\"d:string\">&lt;?xml version=\"1.0\" encoding=\"gb2312\"?&gt;&lt;paras&gt;&lt;RowGuid&gt;%@&lt;/RowGuid&gt;&lt;UserGuid&gt;%@&lt;/UserGuid&gt;&lt;RecordData&gt;%@&lt;/RecordData&gt;&lt;Content&gt;&lt;/Content&gt;&lt;IsNullProblem&gt;1&lt;/IsNullProblem&gt;&lt;Status&gt;0&lt;/Status&gt;&lt;OUGuid&gt;&lt;/OUGuid&gt;&lt;/paras&gt;</ParasXml></ZReport_Insert></v:Body></v:Envelope>",validateData,rowGuid,userGuid,currentDateStr];
    
    NSLog(@"零报告：%@,%@",userGuid,currentDateStr);
    
    
    NSString *address =@"http://oa.epoint.com.cn/ZreportServiceV2/ZreportServer.asmx";
    NSURL* url = [NSURL URLWithString:address];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    
    
    // 然后就是text/xml, 和content-Length必须有。
    [theRequest addValue: @"text/xml; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
    [theRequest addValue: @"http://tempuri.org/ZReport_Insert" forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
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
    
    
    return [self analyseResult:responseData];
}

- (NSDictionary *)queryZReportStatus:(NSString *)userGuid fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
    
    NSString *fromDateStr = [dateFormat stringFromDate:fromDate];
    NSString *toDateStr = [dateFormat stringFromDate:toDate];
    NSString *validateData = [VerifyTool CreateNewToken];
    NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><ZReport_UserView xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><ValidateData i:type=\"d:string\">%@</ValidateData><ParasXml i:type=\"d:string\">&lt;?xml version=\"1.0\" encoding=\"gb2312\"?&gt;&lt;paras&gt;&lt;UserGuid&gt;%@&lt;/UserGuid&gt;&lt;StartDate&gt;%@&lt;/StartDate&gt;&lt;EndDate&gt;%@&lt;/EndDate&gt;&lt;IsShowContent&gt;1&lt;/IsShowContent&gt;&lt;/paras&gt;</ParasXml></ZReport_UserView></v:Body></v:Envelope>",validateData,userGuid,fromDateStr,toDateStr];
    
    NSLog(@"零报告查询：%@,%@ ~ %@",userGuid,fromDateStr,toDateStr);
    
    
    NSString *address =@"http://oa.epoint.com.cn/ZreportServiceV2/ZreportServer.asmx";
    NSURL* url = [NSURL URLWithString:address];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    
    
    // 然后就是text/xml, 和content-Length必须有。
    [theRequest addValue: @"text/xml; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
    [theRequest addValue: @"http://tempuri.org/ZReport_UserView" forHTTPHeaderField:@"SOAPAction"];
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
    
    
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
        
    }
    NSLog(@"Return String is ======⬇️⬇️⬇️\n%@",result);
    
    
    
    
    
    
    [self analyseResult:responseData];
    
    NSLog(@"ZReportUserView:\n%@",self.zReportUserViewResult);
    
    [self analyseReportList];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [self.zReportList enumerateObjectsUsingBlock:^(ZereReportEntity  __nonnull *obj, NSUInteger idx, BOOL * __nonnull stop) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *key =[formatter stringFromDate:obj.recordDate];
        
        [dict setObject:obj forKey:key];
        
        NSLog(@"%@,%d",key,obj.isNullProblem);
    
    }];
    return [dict copy];
    
}

- (void)queryWithAFNetworking:(NSMutableURLRequest *)request{
    
    __weak typeof (self) weakSelf = self;
    
    AFHTTPRequestOperation *opertion = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [opertion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\n\n===============================\n");
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSData *responseData = responseObject;
        [weakSelf analyseResult:[responseData copy]];
        NSLog(@"ZReportUserView:\n%@",weakSelf.zReportUserViewResult);
       
        NSLog(@"\n\n===============================\n\n");
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"\n\n===============================\n\n");
        NSLog(@"%@",error);
        NSLog(@"\n\n===============================\n\n");
        
    }];
    [opertion start];
}

- (NSDictionary *)queryZReportStatusV2:(NSString *)userGuid fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
        
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式,这里可以设置成自己需要的格式
        
        NSString *fromDateStr = [dateFormat stringFromDate:fromDate];
        NSString *toDateStr = [dateFormat stringFromDate:toDate];
        NSString *validateData = [VerifyTool CreateNewToken];
        NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><ZReport_UserView xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><ValidateData i:type=\"d:string\">%@</ValidateData><ParasXml i:type=\"d:string\">&lt;?xml version=\"1.0\" encoding=\"gb2312\"?&gt;&lt;paras&gt;&lt;UserGuid&gt;%@&lt;/UserGuid&gt;&lt;StartDate&gt;%@&lt;/StartDate&gt;&lt;EndDate&gt;%@&lt;/EndDate&gt;&lt;IsShowContent&gt;1&lt;/IsShowContent&gt;&lt;/paras&gt;</ParasXml></ZReport_UserView></v:Body></v:Envelope>",validateData,userGuid,fromDateStr,toDateStr];
        
        NSLog(@"零报告查询：%@,%@ ~ %@",userGuid,fromDateStr,toDateStr);
        
        
        NSString *address =@"http://oa.epoint.com.cn/ZreportServiceV2/ZreportServer.asmx";
        NSURL* url = [NSURL URLWithString:address];
        NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
        
        
        
        // 然后就是text/xml, 和content-Length必须有。
        [theRequest addValue: @"text/xml; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
        NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
        [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
        // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
        [theRequest addValue: @"http://tempuri.org/ZReport_UserView" forHTTPHeaderField:@"SOAPAction"];
        [theRequest setHTTPMethod:@"POST"];
        [theRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
        
     /** AFNetworking 第一版----manager
      *由于Header问题，更改为使用AFHTTPRequestOperation
      
     //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
     //    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
     //    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
     //    [manager.requestSerializer setValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
     //    [manager.requestSerializer setValue:msgLength forHTTPHeaderField:@"Content-Length"];
     //    [manager.requestSerializer setValue:@"http://tempuri.org/ZReport_UserView" forHTTPHeaderField:@"SOAPAction"];
     //    [manager POST:address parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
     //        [formData appendPartWithHeaders:[NSDictionary dictionaryWithObjects:@[@"Content-Type"
     //                                                                              ,@"Content-Length"
     //                                                                              ,@"SOAPAction"]
     //                                                                    forKeys:@[@"text/xml; charset=utf-8"
     //                                                                              ,msgLength
     //                                                                              ,@"http://tempuri.org/ZReport_UserView"]]
     //                                   body:[soapMessage dataUsingEncoding:NSUTF8StringEncoding]];
     //} success:^(AFHTTPRequestOperation *operation, id responseObject) {
     //        NSLog(@"\n\n===============================\n\n");
     //        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
     //        NSLog(@"\n\n===============================\n\n");
     //
     //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
     //        NSLog(@"%@%@",operation.description,error);
     //    }];
     //    
      
      *
      */
    
    /**AFNetworking 第二版  operation*/
    [self queryWithAFNetworking:theRequest];
    
    NSLog(@"start analyse Report List ----v2");
    [self analyseReportList];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [self.zReportList enumerateObjectsUsingBlock:^(ZereReportEntity  __nonnull *obj, NSUInteger idx, BOOL * __nonnull stop) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSString *key =[formatter stringFromDate:obj.recordDate];
        
        [dict setObject:obj forKey:key];
        
        NSLog(@"%@,%d",key,obj.isNullProblem);
        
    }];
    return [dict copy];
    
    /**
     *  原NSURLConnection使用时的解析方法
     */
    
    //    [self analyseResult:responseData];
    //
    //    NSLog(@"ZReportUserView:\n%@",self.zReportUserViewResult);
    //
    //    [self analyseReportList];
    //
    //    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    //
    //    [self.zReportList enumerateObjectsUsingBlock:^(ZereReportEntity  __nonnull *obj, NSUInteger idx, BOOL * __nonnull stop) {
    //        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //        [formatter setDateFormat:@"yyyy-MM-dd"];
    //        NSString *key =[formatter stringFromDate:obj.recordDate];
    //
    //        [dict setObject:obj forKey:key];
    //
    //        NSLog(@"%@,%d",key,obj.isNullProblem);
    //
    //    }];
    //    return [dict copy];
    
    
    
    
}


- (NSMutableArray *)zReportList {
    if (_zReportList ==nil) {
        _zReportList = [[NSMutableArray alloc]init];
    }
    return _zReportList;
}

@end
