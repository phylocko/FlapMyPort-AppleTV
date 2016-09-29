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


@property (strong, nonatomic) NSDate			*startDate;
@property (strong, nonatomic) NSDate			*endDate;

@property (weak, nonatomic) IBOutlet UISegmentedControl *intervalPicker;

@end
