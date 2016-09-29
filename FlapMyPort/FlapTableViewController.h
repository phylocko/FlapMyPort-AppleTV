//
//  FlapTableViewController.h
//  TabBarTest-2
//
//  Created by Владислав Павкин on 14.07.15.
//  Copyright (c) 2015 Владислав Павкин. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FlapTableViewController : UITableViewController

- (void) refresh: (NSMutableData *) data;
- (void) connectionError: (NSError *) error;
- (void) updateInterval;
- (void) enableControls;
- (void) disableControls;
- (void) pushError: (NSError * ) error title: (NSString *) title;

- (NSString *) shortDate: (NSString *) dateString;


@property (strong, nonatomic) NSMutableData		*data;
@property (strong, nonatomic) NSMutableArray	*json;

@property (weak, nonatomic) IBOutlet UISegmentedControl *intervalPicker;


- (IBAction)ChangeInterval:(UISegmentedControl *)sender;

@end
