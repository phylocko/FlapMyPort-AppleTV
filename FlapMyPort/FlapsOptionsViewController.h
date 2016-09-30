//
//  FlapsOptionsViewController.h
//  iSweetHome
//
//  Created by Владислав Павкин on 17.07.15.
//  Copyright (c) 2015 Владислав Павкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlapTableViewController.h"

@interface FlapsOptionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *APIURL;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *ApplyButton;
@property (weak, nonatomic) IBOutlet UILabel *StatusIndicator;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ProgressIndicator;


- (IBAction)ApplyButtonPressed:(id)sender;



@end
