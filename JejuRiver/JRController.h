//
//  JRController.h
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 4..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JRServer.h"

typedef enum
{
    JRWebFuncLookUp = 0,
    JRWebFuncAlive,
    JRWebFuncAuth,
    JRWebFuncInfo,
    JRWebFuncPlayPause,
    JRWebFuncBrowse,
    JRWebFuncFileList,
    JRWebFuncFileDetail,
    JRWebFuncPlayByKey,
    JRWebFuncAddFile
} JRWebFunc;

typedef enum
{
    kPlaybackStateStop = 0,
       kPlaybackStatePause,
    kPlaybackStatePlay
} JRPlaybackState;

@protocol JRControllerDelegate <NSObject>

@optional
-(void)lookUpResult:(BOOL)success;
-(void)authResult:(BOOL)success;
-(void)authOK;
-(void)info:(NSDictionary*)dic;
-(void)browse:(NSArray*)array;
-(void)fileList:(NSArray*)array;
-(void)fileInfo:(NSDictionary*)dic;
-(void)playByKey:(BOOL)success;
@end

@interface JRController : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    NSMutableArray *cue;
    NSMutableArray *keyArray;
    NSMutableData *httpData;
    NSMutableArray *serverArray;
    JRWebFunc       currentFunc;
    id<JRControllerDelegate> __weak _delegate;
    
    NSURLConnection *authConnection;
    NSURLAuthenticationChallenge *authChallenge;
    
    JRServer *currentServer;
    NSString *token;
    
    NSString *guid;
    int      zone;
    
    NSMutableDictionary *infoDic;
    
    NSString *tempID;
    NSString *tempPW;
    
    NSString *tokenEnd;
    
}


+(JRController*)controller;

@property (nonatomic,strong)    NSMutableArray *keyArray;
@property (nonatomic,strong)    NSMutableArray *serverArray;
@property (nonatomic,weak)      id<JRControllerDelegate>    delegate;

-(void)scanServer;
-(void)addKey:(NSString*)accessKey;
-(void)sendAuthID:(NSString*)userID Password:(NSString*)userPW;
-(void)selectServer:(NSInteger)serverIndex;
-(void)authServerIndex:(NSInteger)serverIndex;
-(void)requestInfo;
-(NSString*)imageURL:(NSString*)fileID Browse:(BOOL)isBrowse;
-(void)setupServerAccessKey:(NSString*)keyStr ID:(NSString*)idStr Password:(NSString*)pwStr;
-(void)playToggle;
-(void)browse:(NSString*)browseID;
-(void)fileList:(NSString*)browseKey;
-(void)fileInfo:(NSString*)fileKey;
-(void)playByKey:(NSString*)fileKey Add:(BOOL)isAdd;
@end
