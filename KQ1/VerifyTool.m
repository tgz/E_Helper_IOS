//
//  VerifyTool.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/9.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "VerifyTool.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>

@implementation VerifyTool

+ (NSString *)CreateNewToken{
    //1.getTime
    NSString *ms = [NSString stringWithFormat:@"%ld",(long)[[NSDate date]timeIntervalSince1970]];
    //2.SubString(10)
    NSString *ms2 = [ms substringToIndex:10];
    //3.Base64
    NSData *nsdata = [ms2 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *encodeResult =[[NSString alloc] initWithData:[nsdata base64EncodedDataWithOptions:0]
                                                  encoding:NSUTF8StringEncoding];
    //trimBase64Result
    NSString *trimResult = [encodeResult stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Encript
    NSString *key = @"EpointGtig_1234!@#$";
    
    NSString *encriptResult = [self HmacSha1:key data:trimResult];
    
    //return
    
    NSString * result =[NSString stringWithFormat:@"%@@%@@%@",@"epointoa",encriptResult,trimResult];
    
    result = [result stringByReplacingOccurrencesOfString:@"/"
                                               withString:@"_"];
    return [result stringByReplacingOccurrencesOfString:@"+"
                                             withString:@"-"];
}




//HmacSHA1加密；
+(NSString *)HmacSha1:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC
                                          length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];
    return hash;
}

//密码加密方式：SHA1
+(NSString *)EncriptPasswordWithSha1:(NSString *)password{
    const char *cstr = [password cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:password.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH *2];
    
    for(int i =0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return [result uppercaseString];
}


@end
