//
//  JRController.m
//  JejuRiver
//
//  Created by Jeongsoo on 2015. 5. 4..
//  Copyright (c) 2015년 Jeongsoo. All rights reserved.
//

#import "JRController.h"
#import "XMLReader.h"
#import "AuthViewController.h"
#import "AppDelegate.h"


#define JRIVER_LOOKUP_URL (@"http://webplay.jriver.com/libraryserver/lookup?id=")
#define KEY_CONNECTION (@"KEY_CONNECTION")
#define KEY_FUNC (@"KEY_FUNC")
#define KEY_RESPONSE (@"Response")
#define KEY_STATUS (@"Status")
#define KEY_TEXTVALUE (@"text")
#define KEY_ACCESSKEY (@"AccessKey")
#define KEY_FRIENDLYNAME (@"FriendlyName")

#define BASE_URL ([self baseURL])


@implementation JRController

static JRController *controller = nil;

@synthesize keyArray;
@synthesize serverArray;
@synthesize delegate = _delegate;


+(JRController*)controller
{
    @synchronized(self)
    {
        if (controller == nil)
        {
            controller = [[JRController alloc] init];
        }
    }
    
    return controller;
}

-(void)setupServerAccessKey:(NSString*)keyStr ID:(NSString*)idStr Password:(NSString*)pwStr
{
    tempID = [NSString stringWithString:idStr];
    tempPW = [NSString stringWithString:pwStr];
    
    currentServer = [[JRServer alloc] init];
    [currentServer setAccessKey:keyStr];
    
    [self lookup:keyStr];
}

-(void)addKey:(NSString*)accessKey
{
//    [keyArray addObject:accessKey];
    if( serverArray == nil )
        serverArray = [[NSMutableArray alloc] init];
    
    JRServer *server = [[JRServer alloc] init];
    [server setAccessKey:accessKey];
    [serverArray addObject:server];
}

-(void)scanServer
{
    for(JRServer *server in serverArray)
    {
        [self lookup:[server accessKey]];
    }
}

-(void)lookup:(NSString*)accessKey
{
    NSString *tempStr = [[NSString stringWithFormat:@"%@%@",JRIVER_LOOKUP_URL,accessKey] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    [self sendURL:url Func:JRWebFuncLookUp];
    [self sendRequest:[self connectionWithURLString:tempStr] Func:JRWebFuncLookUp];
    
}

-(void)playToggle
{
    NSString *url = [NSString stringWithFormat:@"%@Playback/PlayPause?Zone=%d%@",[self baseURL],zone,tokenEnd];
    [self sendURL:url Func:JRWebFuncPlayPause];
}

-(void)browse:(NSString*)browseID
{
    NSString *url = [NSString stringWithFormat:@"%@Browse/Children?ID=%@&Skip=1%@",[self baseURL],browseID,tokenEnd];
    [self sendURL:url Func:JRWebFuncBrowse];
}

-(void)fileList:(NSString*)browseKey
{
    NSString *url = [NSString stringWithFormat:@"%@Browse/Files?ID=%@&Action=mpl&ActiveFile=-1&Zone=-1&ZoneType=ID%@",[self baseURL],browseKey,tokenEnd];
    [self sendURL:url Func:JRWebFuncFileList];
}

-(void)fileInfo:(NSString*)fileKey
{
    NSString *url = [NSString stringWithFormat:@"%@File/GetInfo?File=%@%@",[self baseURL],fileKey,tokenEnd];
    [self sendURL:url Func:JRWebFuncFileDetail];
}

-(void)playByKey:(NSString*)fileKey Add:(BOOL)isAdd
{
    NSString *url = [NSString stringWithFormat:@"%@Playback/PlayByKey?Key=%@&%@Zone=%d%@",[self baseURL],fileKey,(isAdd?@"Location=End&":@""),zone,tokenEnd];
    [self sendURL:url Func:JRWebFuncPlayByKey];
}

-(NSURLConnection*)connectionWithURLString:(NSString*)str
{
    NSString *urlString = [NSString stringWithString:str];
    return  [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] delegate:self];
}

-(void)sendURL:(NSString*)str Func:(JRWebFunc)func
{
    if( cue == nil )
        cue = [[NSMutableArray alloc] init];
    
    NSString *urlString = [NSString stringWithString:str];
    NSURLConnection *connection = [self connectionWithURLString:urlString];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:connection,KEY_CONNECTION,[NSNumber numberWithInt:func],KEY_FUNC, nil];
    [cue addObject:dic];
    if( cue.count == 1)
    {
        [self popCue];
    }
}

-(void)sendRequest:(NSURLConnection*)connection Func:(JRWebFunc)func
{
    if( cue == nil )
        cue = [[NSMutableArray alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithObjectsAndKeys:connection,KEY_CONNECTION,[NSNumber numberWithInt:func],KEY_FUNC, nil];
    [cue addObject:dic];
    if( cue.count == 1)
    {
        [self popCue];
    }
}

-(void)popCue
{
    if( [cue count] == 0 )
        return;
    
    httpData = [[NSMutableData alloc] init];
    NSDictionary *dic = [cue objectAtIndex:0];
    NSURLConnection *connection = (NSURLConnection*)[dic objectForKey:KEY_CONNECTION];
    NSLog(@"%@",connection.currentRequest.URL.description);
    [connection start];
}


#pragma mark -
#pragma mark NSURLConnection delegate methods

// -------------------------------------------------------------------------------
//	handleError:error
// -------------------------------------------------------------------------------
- (void)handleError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"에러가 발생했습니다"
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    
}

// The following are delegate methods for NSURLConnection. Similar to callback functions, this is how
// the connection object,  which is working in the background, can asynchronously communicate back to
// its delegate on the thread from which it was started - in this case, the main thread.
//

// -------------------------------------------------------------------------------
//	connection:didReceiveResponse:response
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
    httpData = [[NSMutableData alloc] init];    // start off with new data
}

// -------------------------------------------------------------------------------
//	connection:didReceiveData:data
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData");
    
    [httpData appendData:data];  // append incoming data
}

// -------------------------------------------------------------------------------
//	connection:didFailWithError:error
// -------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    if ([error code] == kCFURLErrorNotConnectedToInternet)
//    {
//        // if we can identify the error, we can present a more precise message to the user.
//        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:@"No Connection Error"
//                                                             forKey:NSLocalizedDescriptionKey];
//        NSError *noConnectionError = [NSError errorWithDomain:NSCocoaErrorDomain
//                                                         code:kCFURLErrorNotConnectedToInternet
//                                                     userInfo:userInfo];
//        [self handleError:noConnectionError];
//    }
//    else
//    {
//        // otherwise handle the error generically
//        [self handleError:error];
//    }
    
    JRWebFunc func = [[[cue objectAtIndex:0] objectForKey:KEY_FUNC] intValue];
    
    for (int i = 0; i < cue.count; i++)
    {
        NSDictionary *dic = [cue objectAtIndex:i];
        if( [dic objectForKey:KEY_CONNECTION] == connection)
        {
            func = [[dic objectForKey:KEY_FUNC] intValue];
            i = (int)cue.count;
        }
    }
    
    switch (func)
    {
        case JRWebFuncLookUp:
        {
            
            if( [_delegate respondsToSelector:@selector(lookUpResult:)])
            {
                [_delegate lookUpResult:NO];
            }
            
        }
            break;
        case JRWebFuncAlive:
        {
            
        }
            
            break;
            
        default:
            break;
    }
    
    [cue removeObjectAtIndex:0];
    [self popCue];
    
    //self.noticeConnection = nil;   // release our connection
}

// -------------------------------------------------------------------------------
//	connectionDidFinishLoading:connection
// -------------------------------------------------------------------------------
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"connectionDidFinishLoading");
    
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSDictionary *dic;
    NSString *status;
    
    
    JRWebFunc func = [[[cue objectAtIndex:0] objectForKey:KEY_FUNC] intValue];
    
    for (int i = 0; i < cue.count; i++)
    {
        NSDictionary *dic = [cue objectAtIndex:i];
        if( [dic objectForKey:KEY_CONNECTION] == connection)
        {
            func = [[dic objectForKey:KEY_FUNC] intValue];
            i = (int)cue.count;
        }
    }
    
    if( func == JRWebFuncFileList || func == JRWebFuncFileDetail)
    {
        dic = [XMLReader dictionaryForXMLData:httpData error:nil];
    }
    else
    {
        dic = [[XMLReader dictionaryForXMLData:httpData error:nil] objectForKey:KEY_RESPONSE];
        status = [dic objectForKey:KEY_STATUS];
    }
    
    switch (func)
    {
        case JRWebFuncLookUp:
        {
        
            if( [status isEqualToString:@"OK"] )
            {
                [currentServer setLocalIP:[[dic objectForKey:@"localiplist"] objectForKey:KEY_TEXTVALUE]];
                [currentServer setMacAdress:[[dic objectForKey:@"macaddresslist"] objectForKey:KEY_TEXTVALUE]];
                [currentServer setPublicIP:[[dic objectForKey:@"ip"] objectForKey:KEY_TEXTVALUE]];
                [currentServer setPort:[[dic objectForKey:@"port"] objectForKey:KEY_TEXTVALUE]];
                
                NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/MCWS/v1/Alive",currentServer.localIP,currentServer.port];
                [self sendURL:urlString Func:JRWebFuncAlive];
            }
            else
            {
                if( [_delegate respondsToSelector:@selector(lookUpResult:)])
                {
                    [_delegate lookUpResult:NO];
                }
            }
            
        }
            break;
            
        case JRWebFuncAlive:
        {
            if( [status isEqualToString:@"OK"])
            {
                NSArray *itemArray = [dic objectForKey:@"Item"];
                NSString *key = @"";
                NSString *friendlyName = @"";
                for( NSDictionary *item in itemArray)
                {
                    if( [[item objectForKey:@"Name"] isEqualToString:@"AccessKey"])
                    {
                        key = [item objectForKey:KEY_TEXTVALUE];
                    }
                    
                    if( [[item objectForKey:@"Name"] isEqualToString:@"FriendlyName"])
                    {
                        friendlyName = [item objectForKey:KEY_TEXTVALUE];
                    }
                    
                    if( [[item objectForKey:@"Name"] isEqualToString:@"RuntimeGUID"])
                    {
                        guid = [item objectForKey:KEY_TEXTVALUE];
                    }
                }
                

                [currentServer setFriendlyName:friendlyName];
                [currentServer setStatus:YES];
                
                [self authCurrentServer];

            }
            else
            {
                if( [_delegate respondsToSelector:@selector(lookUpResult:)])
                {
                    [_delegate lookUpResult:NO];
                }
            }
            
            
        }
            
            break;
            
        case JRWebFuncAuth:
        {
            if ([status isEqualToString:@"OK"])
            {
                token = [[dic objectForKey:@"Item"] objectForKey:KEY_TEXTVALUE];
                tokenEnd = [NSString stringWithFormat:@"&Token=%@",token];
                zone = 0;
                
                if( [_delegate respondsToSelector:@selector(authResult:)] )
                    [_delegate authResult:YES];
            }
            else
            {
                if( [_delegate respondsToSelector:@selector(authResult:)] )
                    [_delegate authResult:NO];
            }
        }
            break;
            
        case JRWebFuncInfo:
        {
            if( [status isEqualToString:@"OK"])
            {
                NSArray *itemArray = [dic objectForKey:@"Item"];
                infoDic = [[NSMutableDictionary alloc] init];
                for( NSDictionary *item in itemArray)
                {
                    [infoDic setObject:[item objectForKey:KEY_TEXTVALUE] forKey:[item objectForKey:@"Name"] ];
                }
                
                if( [_delegate respondsToSelector:@selector(info:)] )
                   [_delegate info:infoDic];
            }
        }
            break;
            
        case JRWebFuncPlayPause:
        {
            if( [status isEqualToString:@"OK"])
            {
//                [self requestInfo];
            }
        }
            break;
            
        case JRWebFuncBrowse:
        {
            if( [status isEqualToString:@"OK"])
            {
                NSArray *itemArray = [dic objectForKey:@"Item"];
                NSMutableArray *tempArray = [[NSMutableArray alloc] init];
                
                if( itemArray != nil)
                {
                    
                    for( NSDictionary *item in itemArray)
                    {
                        JRObject *obj = [[JRObject alloc] initWithIsBrowse:YES];
                        [obj setTitle:[item objectForKey:@"Name"]];
                        [obj setID:[item objectForKey:KEY_TEXTVALUE]];
                        [obj startImageDownload];
                        [tempArray addObject:obj];
                    }
                    

                }
                
                if( [_delegate respondsToSelector:@selector(browse:)] )
                    [_delegate browse:tempArray];


            }
        }
            break;
        case JRWebFuncFileList:
        {
            id data = [[dic objectForKey:@"MPL"] objectForKey:@"Item"];
            NSMutableArray *tempArray = [[NSMutableArray alloc] init];
            
            if( [data isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary*)data;
                NSArray *fields = [dic objectForKey:@"Field"];
                NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
                for (NSDictionary *fieldDic in fields)
                {
                    [itemDic setObject:[fieldDic objectForKey:KEY_TEXTVALUE] forKey:[fieldDic objectForKey:@"Name"]];
                }
                [tempArray addObject:itemDic];
            }
            else
            {
                NSArray *itemArray = (NSArray*)data;
                
                for (NSDictionary *item in itemArray)
                {
                    NSArray *fields = [item objectForKey:@"Field"];
                    NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
                    for (NSDictionary *fieldDic in fields)
                    {
                        [itemDic setObject:[fieldDic objectForKey:KEY_TEXTVALUE] forKey:[fieldDic objectForKey:@"Name"]];
                    }
                    [tempArray addObject:itemDic];
                }
            }

            if( [_delegate respondsToSelector:@selector(fileList:)] )
                [_delegate fileList:tempArray];
        }
            
            break;
        
        case JRWebFuncFileDetail:
        {
            id data = [[dic objectForKey:@"MPL"] objectForKey:@"Item"];
            NSMutableDictionary *itemDic = [[NSMutableDictionary alloc] init];
            
            if( [data isKindOfClass:[NSDictionary class]])
            {
                NSDictionary *dic = (NSDictionary*)data;
                NSArray *fields = [dic objectForKey:@"Field"];

                for (NSDictionary *fieldDic in fields)
                {
                    [itemDic setObject:[fieldDic objectForKey:KEY_TEXTVALUE] forKey:[fieldDic objectForKey:@"Name"]];
                }
            }
            
            
            if( [_delegate respondsToSelector:@selector(fileInfo:)] )
                [_delegate fileInfo:itemDic];
        }
            break;
            
        case JRWebFuncPlayByKey:
        {
            if( [status isEqualToString:@"OK"])
            {
                if( [_delegate respondsToSelector:@selector(playByKey:)])
                {
                    [_delegate playByKey:YES];
                }
            }
        }
            break;
            
        default:
            break;
    }
    
    if( [cue count] > 0)
        [cue removeObjectAtIndex:0];
    
    [self popCue];
    
    
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    NSLog(@"willSendRequestForAuthenticationChallenge ------ ");
    /*
    authConnection = connection;
    authChallenge = challenge;
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:[[AuthViewController alloc] initWithNibName:@"AuthViewController" bundle:nil]];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController setModalPresentationStyle:UIModalPresentationPopover];
    [appDelegate.window.rootViewController presentViewController:navi animated:YES completion:nil];
    */
    
    [[challenge sender] useCredential:[NSURLCredential credentialWithUser:tempID password:tempPW persistence:NSURLCredentialPersistenceForSession] forAuthenticationChallenge:challenge];
    
}

-(void)sendAuthID:(NSString *)userID Password:(NSString *)userPW
{
    [[authChallenge sender] useCredential:[NSURLCredential credentialWithUser:userID password:userPW persistence:NSURLCredentialPersistenceForSession] forAuthenticationChallenge:authChallenge];
}

-(void)authServerIndex:(NSInteger)serverIndex
{
    currentServer = [serverArray objectAtIndex:serverIndex];
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MCWS/v1/Authenticate",currentServer.localIP,currentServer.port];
    [self sendRequest:[self connectionWithURLString:url] Func:JRWebFuncAuth];
    
}

-(void)authCurrentServer
{
    NSString *url = [NSString stringWithFormat:@"http://%@:%@/MCWS/v1/Authenticate",currentServer.localIP,currentServer.port];
    [self sendURL:url Func:JRWebFuncAuth];
}

-(void)selectServer:(NSInteger)serverIndex
{
    currentServer = [serverArray objectAtIndex:serverIndex];
}

-(void)requestInfo
{
    NSString *url = [NSString stringWithFormat:@"%@Playback/Info?Zone=%d%@",[self baseURL],zone,tokenEnd];
    [self sendURL:url Func:JRWebFuncInfo];
    
}

-(NSString*)imageURL:(NSString*)fileID Browse:(BOOL)isBrowse
{
    if( isBrowse )
        return [NSString stringWithFormat:@"%@Browse/Image?ID=%@%@",[self baseURL],fileID,tokenEnd];
    else
        return [NSString stringWithFormat:@"%@File/GetImage?File=%@%@",[self baseURL],fileID,tokenEnd];        
}

-(NSString*)baseURL
{
    return [NSString stringWithFormat:@"http://%@:%@/MCWS/v1/",currentServer.localIP,currentServer.port];
}



@end
