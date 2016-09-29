//
//  FlapsOptionsViewController.m
//  iSweetHome
//
//  Created by Владислав Павкин on 17.07.15.
//  Copyright (c) 2015 Владислав Павкин. All rights reserved.
//

#import "FlapsOptionsViewController.h"
#import "FlapTableViewController.h"

@implementation FlapsOptionsViewController


-(void) viewWillAppear:(BOOL)animated
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *interval = [defaults stringForKey:@"flapHistoryInterval"];
	
	if([interval isEqualToString:@"600"])
	{
		self.intervalPicker.selectedSegmentIndex = 0;
	}
	else
	if([interval isEqualToString: @"3600"])
	{
		self.intervalPicker.selectedSegmentIndex = 1;
	}
	else
	if([interval isEqualToString:@"10800"])
	{
		self.intervalPicker.selectedSegmentIndex = 2;
	}
	else
    if([interval  isEqualToString: @"21600"])
	{
		self.intervalPicker.selectedSegmentIndex = 3;
	}
	else
	if([interval isEqualToString:@"86400"])
	{
		self.intervalPicker.selectedSegmentIndex = 4;
	}
	
}


- (IBAction)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	
	if(self.intervalPicker.selectedSegmentIndex == 0)
	{
		[defaults setValue:@"600" forKey:@"flapHistoryInterval"];
	}
    else
    if(self.intervalPicker.selectedSegmentIndex == 1)
    {
        [defaults setValue:@"3600" forKey:@"flapHistoryInterval"];
    }
    else
    if(self.intervalPicker.selectedSegmentIndex == 2)
    {
        [defaults setValue:@"10800" forKey:@"flapHistoryInterval"];
    }
    else
    if(self.intervalPicker.selectedSegmentIndex == 3)
    {
        [defaults setValue:@"21600" forKey:@"flapHistoryInterval"];
		NSLog(@"21600 - is a new interval!");
    }
    else
    if(self.intervalPicker.selectedSegmentIndex == 4)
    {
        [defaults setValue:@"86400" forKey:@"flapHistoryInterval"];
    }
}


@end
