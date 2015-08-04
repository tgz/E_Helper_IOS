//
//  ZeroReportQuery.m
//  KQ1
//
//  Created by 邱 士川 on 15/8/3.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "ZeroReportQuery.h"
#import "AFNetworking.h"
#import "VerifyTool.h"




@implementation ZeroReportQuery



#pragma mark - 网络请求
- (void)queryWithAFNetworking:(NSMutableURLRequest *)request{
    AFHTTPRequestOperation *opertion = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [opertion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\n\n===============================\n");
        NSLog(@"%@",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSData *responseData = responseObject;
        NSLog(@"\n\n===============================\n\n");


    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"\n\n===============================\n\n");
        NSLog(@"%@",error);
        NSLog(@"\n\n===============================\n\n");

    }];
    [opertion start];
}
- (void)queryZReportStatus:(NSString *)userGuid fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
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
    AFHTTPRequestOperation *opertion = [[AFHTTPRequestOperation alloc]initWithRequest:theRequest];

    opertion.responseSerializer = [AFXMLParserResponseSerializer serializer];
    [opertion setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"\n\n===============================\n");

        NSXMLParser *parser = responseObject;
        parser.delegate = self;
        /**对返回结果进行解析*/
        BOOL isSuccess = [parser parse];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"\n\n===============================\n\n");
        NSLog(@"%@",error);
        NSLog(@"\n\n===============================\n\n");

    }];
    [opertion start];

}

#pragma mark - NSXmlDelegate
/**
 *  开始解析XML数据
 */
- (void)parserDidStartDocument:(nonnull NSXMLParser *)parser {

}


/**
 *  开始解析节点
 */
- (void)parser:(nonnull NSXMLParser *)parser didStartElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName attributes:(nonnull NSDictionary<NSString *,NSString *> *)attributeDict {

}
/**
 *获取到文本
 */
- (void)parser:(nonnull NSXMLParser *)parser foundCharacters:(nonnull NSString *)string{

}

/**
 *节点解析完毕
 */
- (void)parser:(nonnull NSXMLParser *)parser didEndElement:(nonnull NSString *)elementName namespaceURI:(nullable NSString *)namespaceURI qualifiedName:(nullable NSString *)qName{

}

/**
 *xml解析完毕
 */
- (void)parserDidEndDocument:(nonnull NSXMLParser *)parser{

}

/**
 *解析出错
 */
- (void)parser:(nonnull NSXMLParser *)parser parseErrorOccurred:(nonnull NSError *)parseError {

}



@end
