//
//  FlapsOptionsViewController.h
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 30.09.16.
//  Copyright (c) 2016 Vladislav Pavkin. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "FlapTableViewController.h"

@interface FlapsOptionsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *APIURL;
@property (weak, nonatomic) IBOutlet UITextField *loginField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property (weak, nonatomic) IBOutlet UIButton *ApplyButton;
@property (weak, nonatomic) IBOutlet UILabel *StatusIndicator;
@property (weak, nonatomic) IBOutlet UILabel *helperText;


- (IBAction)ApplyButtonPressed:(id)sender;



@end
