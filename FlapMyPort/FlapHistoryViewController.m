//
//  FlapHistoryViewController.m
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 30.09.16.
//  Copyright (c) 2016 Vladislav Pavkin. All rights reserved.
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
    NSUserDefaults  *config;
}

@end


@implementation FlapHistoryViewController


- (void) viewDidLoad
{
    
    config = [NSUserDefaults standardUserDefaults];
    
	[self updateParams];
	

	if (   [   [   [self.flap objectForKey:@"port"] objectForKey:@"ifAlias"]         isKindOfClass:[NSNull class]])
	{
		self.flapHistoryTitle.title = [NSString stringWithFormat:@"%@: %@", [self.flap objectForKey:@"hostname"], [[self.flap objectForKey:@"port"] objectForKey:@"ifName"]];
	}
	else
	{
		self.flapHistoryTitle.title = [NSString stringWithFormat:@"%@: %@ (%@)", [self.flap objectForKey:@"hostname"], [[self.flap objectForKey:@"port"] objectForKey:@"ifName"], [[self.flap objectForKey:@"port"] objectForKey:@"ifAlias"]];
	}

    
    NSString *ApiURL = [config valueForKey:@"ApiUrl"];
    
    NSString *url = [NSString stringWithFormat: @"%@/?ifindex=%@&flaphistory&host=%@&interval=%@", ApiURL, ifIndex, ipaddress, interval];
    
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

#pragma mark - Refresh

- (void)refresh: (NSMutableData *) data
{
	
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
    
}


- (void) connectionError: (NSError *) error
{
    [flapList removeAllObjects];
    [self.tableView reloadData];
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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"What is this?!");
}

@end

