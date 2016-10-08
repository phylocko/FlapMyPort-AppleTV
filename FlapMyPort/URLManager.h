//
//  URLManager.h
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 30.09.16.
//  Copyright (c) 2016 Vladislav Pavkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol URLManagerDelegate <NSObject>

- (void)refresh:(NSData *)data;
- (void)connectionError:(NSError *)error;

@end

@interface URLManager : NSObject <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@property (nonatomic,strong) NSURLSession *session;
@property (nonatomic,strong) NSURLSessionDataTask *task;

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableData *data;

@property (nonatomic, weak) NSString *UserLogin;
@property (nonatomic, weak) NSString *UserPassword;

+ (URLManager *) sharedInstance;
- (void) createSession;
- (void) getURL: (NSString *) url;

// Delegate's methods

@end
