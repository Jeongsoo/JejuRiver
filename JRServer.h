//
//  JRServer.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 5..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JRServer : NSObject


@property (nonatomic,strong) NSString *accessKey;
@property (nonatomic,strong) NSString *localIP;
@property (nonatomic,strong) NSString *publicIP;
@property (nonatomic,strong) NSString *macAdress;
@property (nonatomic,strong) NSString *port;
@property (nonatomic,strong) NSString *friendlyName;
@property (nonatomic,assign) BOOL     status;


@end
