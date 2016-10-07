//
//  FlapHistoryViewController.h
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 30.09.16.
//  Copyright (c) 2016 Vladislav Pavkin. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FlapHistoryViewController : UITableViewController

- (void) refresh: (NSMutableData *) data;
- (void) connectionError: (NSError *) error;
- (void) updateParams;

@property (strong, nonatomic)	NSDictionary *flap;

@property (weak, nonatomic) IBOutlet UINavigationItem *flapHistoryTitle;

@end
