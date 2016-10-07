//
//  URLManager.m
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 05/08/16.
//  Copyright © 2016 Vladislav Pavkin. All rights reserved.
//

#import "URLManager.h"


@implementation URLManager

@synthesize delegate;

+(URLManager *) sharedInstance
{
    static URLManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[URLManager alloc] init];
    });
    return _sharedInstance;
}


- (void) createSession
{
    static NSURLSession *session = nil;
    session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                            delegate:self
                                       delegateQueue:[NSOperationQueue mainQueue]];
    self.session = session;
}

- (void) getURL: (NSString *) urlString
{
    self.data = [[NSMutableData alloc] init];
    
    NSLog(@"Requesting URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

- (void) URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{

    [self.data appendData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{

    if(error)
    {
        [delegate connectionError:error];
    }
    else
    {
        [delegate refresh:self.data];
    }
}

- (void) URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if (challenge.previousFailureCount == 0)
    {
        NSURLCredentialPersistence persistence = NSURLCredentialPersistenceNone;
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:self.UserLogin password:self.UserPassword persistence:persistence];
        completionHandler(NSURLSessionAuthChallengeUseCredential, credential);
    }
    else
    {
        NSError *error = [[NSError alloc] initWithDomain:@"Wrong login or password. Check your preferences." code:0 userInfo:nil];
        
        [delegate connectionError:error];
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
    }
}

@end

