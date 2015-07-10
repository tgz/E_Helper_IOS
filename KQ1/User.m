//
//  User.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/6.
//  Copyright (c) 2015年 qsc. All rights reserved.
//

#import "User.h"
#import "VerifyTool.h"
#import "AFNetworking.h"

@implementation User

#pragma mark - init
+ (User *)userFromNSUserDefaults{
    return [[self alloc] initWithNSUserDefaults];
}

- (User *)initWithNSUserDefaults{
    if(self = [super init]){
        NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
        self.loginID = [userDefaults valueForKey:@"LoginID"];
        self.userGuid = [userDefaults valueForKey:@"UserGuid"];
        self.userName = [userDefaults valueForKey:@"UserName"];
    }
    return self;
}

#pragma mark - saveUserInfo

+ (BOOL)saveUserInfoWithName:(NSString *)userName
                     loginID:(NSString *)loginID
                    userGuid:(NSString *)userGuid
                      oUName:(NSString *)ouName{
    if(!userName || !loginID || !userGuid || !ouName) {
        return NO;
    }
    
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    [userDefaults setObject:loginID forKey:@"LoginID"];
    [userDefaults setObject:userGuid forKey:@"UserGuid"];
    [userDefaults setObject:userName forKey:@"UserName"];
    return YES;
}

+ (void)saveUserInfo:(User *)user{
    NSUserDefaults *userDefaults = [[NSUserDefaults alloc]init];
    [userDefaults setObject:user.loginID forKey:@"LoginID"];
    [userDefaults setObject:user.userGuid forKey:@"UserGuid"];
    [userDefaults setObject:user.userName forKey:@"UserName"];
}


#pragma mark method
+ (User *)loginWithUserName:(NSString *)userName
                   password:(NSString *)password{
    NSString *validateDate = [VerifyTool CreateNewToken];
    NSString *encriptPassword = [VerifyTool EncriptPasswordWithSha1:password];
    
    NSString *soapMessage = [NSString stringWithFormat:@"<v:Envelope xmlns:i=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:d=\"http://www.w3.org/2001/XMLSchema\" xmlns:c=\"http://schemas.xmlsoap.org/soap/encoding/\" xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\"><v:Header /><v:Body><UserLogin2 xmlns=\"http://tempuri.org/\" id=\"o0\" c:root=\"1\"><ValidateData i:type=\"d:string\">%@</ValidateData><ParasXml i:type=\"d:string\">&lt;?xml version=\"1.0\" encoding=\"gb2312\"?&gt;&lt;paras&gt;&lt;LoginID&gt;%@&lt;/LoginID&gt;&lt;Password&gt;%@&lt;/Password&gt;&lt;/paras&gt;</ParasXml></UserLogin2></v:Body></v:Envelope>",validateDate,userName,encriptPassword];
    
    
    NSString *address =@"http://oa.epoint.com.cn/EpointOAWebservice8V2/OAWebService.asmx";
    NSURL* url = [NSURL URLWithString:address];
    NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL:url];
    
    // 然后就是text/xml, 和content-Length必须有。
    [theRequest addValue: @"text/xml; charset=utf-8"forHTTPHeaderField:@"Content-Type"];
    NSString *msgLength = [NSString stringWithFormat:@"%d", [soapMessage length]];
    [theRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    // 下面这行， 后面SOAPAction是规范， 而下面这个网址来自哪里呢，来自于上面加红加粗的部分。
    [theRequest addValue: @"http://tempuri.org/UserLogin2" forHTTPHeaderField:@"SOAPAction"];
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
    if(error)
    {
        NSLog(@"ReponseError:\n\n%@\n\nDebugDescription:\n%@\n",error.description,error.debugDescription);
        return nil;
    }
    
    NSLog(@"Return String is ======⬇️⬇️⬇️\n%@",result);
    


/*
 *AFNetworking failed
 *
 */
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFXMLParserResponseSerializer serializer];

//    [manager POST:address
//       parameters:soapMessage
//          success:^(AFHTTPRequestOperation *operation, id responseObject) {
//              NSString *response = [[NSString alloc]initWithData:responseObject
//                                                        encoding:NSUTF8StringEncoding];
//              NSLog(@"%@, %@",operation,response);
//          }
//          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//              NSString *response = [[NSString alloc]initWithData:[operation responseObject]
//                                                        encoding:NSUTF8StringEncoding];
//              NSLog(@"%@, %@, %@",operation,error,response);
//          }];
   
    
    

    

    return [[User alloc]init];

}


@end
