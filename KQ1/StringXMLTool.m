//
//  StringXMLTool.m
//  KQ1
//
//  Created by 邱 士川 on 15/7/9.
//  Copyright © 2015年 qsc. All rights reserved.
//

#import "StringXMLTool.h"

@implementation StringXMLTool
//HTML DECODE方法，来源于网络。
-(NSString *)stringByDecodingXMLEntities:(NSString *)input
{
    NSUInteger myLength = [input length];
    NSUInteger ampIndex = [input rangeOfString:@"&" options:NSLiteralSearch].location;
    
    // Short-circuit if there are no ampersands.
    if (ampIndex == NSNotFound) {
        return input;
    }
    // Make result string with some extra capacity.
    NSMutableString *result = [NSMutableString stringWithCapacity:(myLength * 1.25)];
    
    // First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
    NSScanner *scanner = [NSScanner scannerWithString:input];
    
    [scanner setCharactersToBeSkipped:nil];
    
    NSCharacterSet *boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@" \t\n\r;"];
    
    do {
        // Scan up to the next entity or the end of the string.
        NSString *nonEntityString;
        if ([scanner scanUpToString:@"&" intoString:&nonEntityString]) {
            [result appendString:nonEntityString];
        }
        if ([scanner isAtEnd]) {
            goto finish;
        }
        // Scan either a HTML or numeric character entity reference.
        if ([scanner scanString:@"&amp;" intoString:NULL])
            [result appendString:@"&"];
        else if ([scanner scanString:@"&apos;" intoString:NULL])
            [result appendString:@"'"];
        else if ([scanner scanString:@"&quot;" intoString:NULL])
            [result appendString:@"\""];
        else if ([scanner scanString:@"&lt;" intoString:NULL])
            [result appendString:@"<"];
        else if ([scanner scanString:@"&gt;" intoString:NULL])
            [result appendString:@">"];
        else if ([scanner scanString:@"&#" intoString:NULL]) {
            BOOL gotNumber;
            unsigned charCode;
            NSString *xForHex = @"";
            
            // Is it hex or decimal?
            if ([scanner scanString:@"x" intoString:&xForHex]) {
                gotNumber = [scanner scanHexInt:&charCode];
            }
            else {
                gotNumber = [scanner scanInt:(int*)&charCode];
            }
            
            if (gotNumber) {
                [result appendFormat:@"%C", (unichar)charCode];
                
                [scanner scanString:@";" intoString:NULL];
            }
            else {
                NSString *unknownEntity = @"";
                
                [scanner scanUpToCharactersFromSet:boundaryCharacterSet intoString:&unknownEntity];
                
                
                [result appendFormat:@"&#%@%@", xForHex, unknownEntity];
                
                //[scanner scanUpToString:@";" intoString:&unknownEntity];
                //[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
                NSLog(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
                
            }
            
        }
        else {
            NSString *amp;
            
            [scanner scanString:@"&" intoString:&amp];  //an isolated & symbol
            [result appendString:amp];
            
            /*
             NSString *unknownEntity = @"";
             [scanner scanUpToString:@";" intoString:&unknownEntity];
             NSString *semicolon = @"";
             [scanner scanString:@";" intoString:&semicolon];
             [result appendFormat:@"%@%@", unknownEntity, semicolon];
             NSLog(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
             */
        }
        
    }
    while (![scanner isAtEnd]);
    
finish:
    return result;
}


//获取XML某个属性值，此XML为HTML Encode后的结果。如--->【&lt;attr&gt;需要的值&lt;/&gt;】
-(NSString *)getXMLAttFromHtmlEncodeXML:(NSString *)HtmlEncodeXML Attribute:(NSString *)attr
{
    NSString *start = [[NSString alloc]initWithFormat:@"&lt;%@&gt;",attr];
    NSString *end = [[NSString alloc]initWithFormat:@"&lt;/%@&gt;",attr];
    NSRange range_start =[HtmlEncodeXML rangeOfString:start];
    NSRange range_end = [HtmlEncodeXML rangeOfString:end];
    
    if (range_start.location!=NSNotFound&&range_end.location!=NSNotFound)
    {
        NSString *result =  [HtmlEncodeXML substringWithRange: NSMakeRange(
                                                                           range_start.location+range_start.length,
                                                                           range_end.location-range_start.location-range_start.length
                                                                           )];
        return result;
    }
    else
    {
        return nil;
    }
    
}

//获取XML某个属性值。如--->【<attr>需要的值</attr>】
-(NSString *)getXMLAttFromStringXML:(NSString *)XML Attribute:(NSString *)attr
{
    NSString *start = [[NSString alloc]initWithFormat:@"<%@>",attr];
    NSString *end = [[NSString alloc]initWithFormat:@"</%@>",attr];
    NSRange range_start =[XML rangeOfString:start];
    NSRange range_end = [XML rangeOfString:end];
    
    if (range_start.location!=NSNotFound&&range_end.location!=NSNotFound)
    {
        return [XML substringWithRange:NSMakeRange(
                                                   range_start.location+range_start.length,
                                                   range_end.location-range_start.location-range_start.length
                                                   )];
    }
    else
    {
        return nil;
    }
    
}

-(NSString *)convert2Unicode:(NSString *)str
{
    NSMutableString *resultString = [[NSMutableString alloc]init];
    
    NSInteger length =[str length];
    for (int i=0; i<length; i++) {
        // NSLog(@"ConvertString2Unicode ******  charAtIndex%d is %c code:&#%d;",i,[str characterAtIndex:i],[str characterAtIndex:i]);
        [resultString appendString:[NSString stringWithFormat:@"&#%d;",[str characterAtIndex:i]]] ;
    }
    return resultString;
}
@end
