//
//  FlapHistoryViewController.m
//  TabBarTest-2
//
//  Created by Владислав Павкин on 14.07.15.
//  Copyright (c) 2015 Владислав Павкин. All rights reserved.
//

#import "FlapHistoryViewController.h"
#import "URLManager.h"
// #import "PortFlap.h"
// #import "HostCell.h"
#import "FlapCell.h"
#import "FlapHistoryCell.h"

@interface FlapHistoryViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray	*flapList;
    URLManager		*myConnection;
	NSString		*interval;
	NSString		*ifIndex;
	NSString		*ipaddress;
}

@end


@implementation FlapHistoryViewController


- (void) viewDidLoad
{
	[self updateParams];
	
	if (   [   [   [self.flap objectForKey:@"port"] objectForKey:@"ifAlias"]         isKindOfClass:[NSNull class]])
	{
		self.summaryLabel.text = [NSString stringWithFormat:@"%@: %@", [self.flap objectForKey:@"hostname"], [[self.flap objectForKey:@"port"] objectForKey:@"ifName"]];
	}
	else
	{
		self.summaryLabel.text = [NSString stringWithFormat:@"%@: %@ (%@)", [self.flap objectForKey:@"hostname"], [[self.flap objectForKey:@"port"] objectForKey:@"ifName"], [[self.flap objectForKey:@"port"] objectForKey:@"ifAlias"]];
	}
    NSString *url = [NSString stringWithFormat: @"http://isweethome.ihome.ru/api/?ifindex=%@&flaphistory&host=%@&interval=%@", ifIndex, ipaddress, interval];
	
    flapList = [[NSMutableArray alloc] init];
    
    myConnection = [URLManager sharedInstance];
    
    myConnection.delegate = self;
    
    [myConnection getURL:url];
    
    /* Animated refresh */
    [UIView transitionWithView:self.tableView
                      duration:0.95f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^(void)
     {
         [self.tableView reloadData];
     }
                    completion: nil];
    

}

-(void) updateParams
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	interval = [defaults stringForKey:@"flapHistoryInterval"];
	
	ifIndex = [[self.flap objectForKey:@"port"] objectForKey:@"ifIndex"];
	ipaddress = [self.flap objectForKey:@"ipaddress"];
	
}

- (IBAction)refreshButtonTap:(UIBarButtonItem *)sender {

	NSString *url = [NSString stringWithFormat: @"http://isweethome.ihome.ru/api/?ifindex=%@&flaphistory&host=%@&interval=%@", ifIndex, ipaddress, interval];

	myConnection = [URLManager sharedInstance];
	
	myConnection.delegate = self;
	
	self.refreshButton.enabled = NO;

	[myConnection getURL:url];
	
}

#pragma mark - Refresh

- (void)refresh: (NSMutableData *) data
{
	self.refreshButton.enabled = YES;

	
	if(data != nil)
	{
		NSMutableArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];

		[flapList removeAllObjects];
	
		for (id flap in json)
		{
			NSString *time = [flap objectForKey:@"time"];
			NSString *state = [flap objectForKey:@"ifOperStatus"];
			
			[flapList addObject:@{@"time": time, @"ifOperStatus": state}];
		}
	}
	[self.tableView reloadData];
    self.refreshButton.enabled = YES;
    
}


- (void) connectionError: (NSError *) error
{
    [flapList removeAllObjects];
    [self.tableView reloadData];
    self.refreshButton.enabled = YES;
}



#pragma mark - Table Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [flapList count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	FlapHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flapHistoryCell" forIndexPath:indexPath];
	
	NSString *time = [[flapList objectAtIndex:indexPath.row] valueForKey:@"time"];
	NSString *state = [[flapList objectAtIndex:indexPath.row] valueForKey:@"ifOperStatus"];
	cell.timeLabel.text = time;
	cell.statusLabel.text = state;
	
    return cell;
}


@end

