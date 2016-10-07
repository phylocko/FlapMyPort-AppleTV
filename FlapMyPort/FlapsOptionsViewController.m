//
//  FlapsOptionsViewController.m
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 30.09.16.
//  Copyright (c) 2016 Vladislav Pavkin. All rights reserved.
//


#import "FlapsOptionsViewController.h"
#import "FlapTableViewController.h"
#import "URLManager.h"


@interface FlapsOptionsViewController () <URLManagerDelegate>
{
    NSUserDefaults *config;
    URLManager  *myConnection;
}
@end

@implementation FlapsOptionsViewController

- (void) viewDidLoad
{

    
    myConnection = [[URLManager alloc] init];
    [myConnection createSession];
    
    [self pullData];
}

- (void) pullData
{
    config = [NSUserDefaults standardUserDefaults];
    
    if([config valueForKey:@"UserLogin"] == nil)
    {
        [config setObject:@"" forKey:@"UserLogin"];
    }
    
    if([config valueForKey:@"UserPassword"] == nil)
    {
        [config setObject:@"" forKey:@"UserPassword"];
    }
    
    if([config valueForKey:@"ApiUrl"] == nil)
    {
        [config setObject:@"" forKey:@"ApiUrl"];
    }
    
    
    self.APIURL.text = [config valueForKey:@"ApiUrl"];
    self.loginField.text = [config valueForKey:@"UserLogin"];
    self.passwordField.text = [config valueForKey:@"UserPassword"];
    
}

- (IBAction)ApplyButtonPressed:(id)sender {

    [self disableControls];
    
    self.StatusIndicator.text = @"";
    
    if([self urlCorrect])
    {
        NSString *url = [NSString stringWithFormat:@"%@/?check", self.APIURL.text];
        
        myConnection.delegate = self;
        myConnection.UserLogin = self.loginField.text;
        myConnection.UserPassword = self.passwordField.text;
        
        [myConnection getURL:url];
        
    }

}

- (void) disableControls
{
    self.ApplyButton.enabled = NO;
    self.StatusIndicator.hidden = YES;
}
- (void) enableControls
{
    self.ApplyButton.enabled = YES;
}

- (BOOL) urlCorrect
{
    return YES;
}



#pragma mark - Delegate methods

- (void) refresh: (NSMutableData *) data
{
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    if(response)
    {
        if([[response objectForKey:@"checkResult"] isEqualToString:@"flapmyport"])
        {
            [config setObject:self.APIURL.text forKey:@"ApiUrl"];
            [config setObject:self.loginField.text forKey:@"UserLogin"];
            [config setObject:self.passwordField.text forKey:@"UserPassword"];
            
            self.StatusIndicator.text= @"✅";
            self.StatusIndicator.hidden = NO;
            
            self.helperText.text = @"This url is a correct url! Stored to config.";
            [self enableControls];
            return;
        }
    }
    
    
    self.helperText.text = @"Couldn't find API response.\r\nCheck the URL or your credentials if needed.";
    self.StatusIndicator.text = @"❗️";
    self.StatusIndicator.hidden = NO;
    
    [self enableControls];
}
- (void) connectionError: (NSError *) error
{
    self.helperText.text = @"Couldn't find API response.\r\nCheck the URL or your credentials if needed.";
    
    self.StatusIndicator.text = @"❗️";
    self.StatusIndicator.hidden = NO;
    
    [self enableControls];
}


@end
