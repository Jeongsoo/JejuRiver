//
//  XMLReader.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 5..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMLReader : NSObject<NSXMLParserDelegate>
{
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError *errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError *)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError *)errorPointer;

@end
