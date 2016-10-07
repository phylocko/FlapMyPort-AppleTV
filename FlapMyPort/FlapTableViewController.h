//
//  FlapTableViewController.h
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 30.09.16.
//  Copyright (c) 2016 Vladislav Pavkin. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface FlapTableViewController : UITableViewController

- (void) refresh: (NSMutableData *) data;
- (void) connectionError: (NSError *) error;
// - (void) updateInterval;
- (void) enableControls;
- (void) disableControls;
- (void) pushError: (NSError * ) error title: (NSString *) title;

- (NSString *) shortDate: (NSString *) dateString;


@property (strong, nonatomic) NSMutableData		*data;
@property (strong, nonatomic) NSMutableArray	*json;
@property (strong, nonatomic) NSTimer   *refreshTimer;

@property (weak, nonatomic) IBOutlet UISegmentedControl *intervalPicker;


- (IBAction)ChangeInterval:(UISegmentedControl *)sender;

@end
