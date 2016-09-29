//
//  FlapTableController.m
//  TabBarTest-2
//
//  Created by Владислав Павкин on 14.07.15.
//  Copyright (c) 2015 Владислав Павкин. All rights reserved.
//

#import "FlapTableViewController.h"
#import "FlapHistoryViewController.h"
#import "URLManager.h"
#import "FlapCell.h"

@interface FlapTableViewController () <UITableViewDataSource, UITableViewDelegate>
{

    URLManager		*myConnection;
	NSString		*interval;
    
	NSMutableArray	*flapList;

    BOOL            connectionError;
    NSError         *connError;
    
    NSString        *oldestFlapID;
    NSString        *lastOldestFlapID;
    
    NSUserDefaults  *config;
    NSString        *ApiUrl;
    
    NSString        *UserLogin;
    NSString        *UserPassword;

}

@end


@implementation FlapTableViewController


- (void) viewDidLoad
{


    
    flapList = [[NSMutableArray alloc] init];
    
    config = [NSUserDefaults standardUserDefaults];
    
    // Временно!!!
    [self setDefaultApiUrl];
    [config setObject:@"vlad" forKey:@"UserLogin"];
    [config setObject:@"0o9i8u" forKey:@"UserPassword"];
    [config setValue:@"73600" forKey:@"flapHistoryInterval"];
    
    
    
    if([self apiIsDefault] == YES)
    {
        NSString *message = @"You have VirtualAPI link configured so you are seeing demo data.\r\nPlease open Settings.app and configure your URL.\r\n\r\nVisit flapmyport.com for detailed instructions how to run FlapMyPort server on your network.";
        
        [self showAlert:message title:@"No URL Configured"];
    }
    
    if ([self apiUrlExists] == NO)
    {
        [self setDefaultApiUrl];
        [self showAlert:@"You have no API URL configured so we're going to use VirtualAPI. Please open Preferences and type your URL." title:@"No URL Configured"];
    }
    
    [self disableControls];
    
    // [self updateInterval];
    
    myConnection = [URLManager sharedInstance];
    [myConnection createSession];
    
    [self requestData];
}


#pragma mark - My Methods

-(void) writeDefaultInterval
{
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setValue:@"3600" forKey:@"flapHistoryInterval"];
	
    interval = @"3600";

}


- (NSString *) prepareUrlWithInterval
{
    
    NSString *url = [NSString stringWithFormat:@"%@/?review&interval=%@", ApiUrl, interval];
    return url;
}


- (void) requestData
{
    [self pullConfig];
    
    if( [[config valueForKey:@"ApiUrl"] isEqualToString:@""] )
    {

        [self enableControls];

        
        NSString *message = @"You have to configure ApiUrl first.\r\n\r\nPlease open the Settings.app and scroll down no FlapMyPort bundle.";
        [self showAlert:message title:@"Configuration error"];
        
        
        return;
    }

    
    [self disableControls];
    // [self updateInterval];
    
    myConnection = [URLManager sharedInstance];
    myConnection.UserLogin = UserLogin;
    myConnection.UserPassword = UserPassword;
    myConnection.delegate = self;
    [myConnection getURL:[self prepareUrlWithInterval]];

}

- (void) pullConfig
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
    UserLogin = [config valueForKey:@"UserLogin"];
    UserPassword = [config valueForKey:@"UserPassword"];
    
    ApiUrl = [config valueForKey:@"ApiUrl"];
    
}


- (void) enableControls
{
    // [self.refreshControl endRefreshing];
    self.intervalPicker.enabled = YES;
    self.tableView.userInteractionEnabled = YES;

}

- (void) disableControls
{

    self.intervalPicker.enabled = NO;
    self.tableView.userInteractionEnabled = NO;
    // [self.refreshControl beginRefreshing];
}

- (NSString *) shortDate: (NSString *) dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    NSDateFormatter *shortFormatter = [[NSDateFormatter alloc] init];
    [shortFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    
    return [shortFormatter stringFromDate:date];
    
    //	return @"9:04:44";
}

- (NSString *) getCredentials
{
    NSString *credentials = [NSString stringWithFormat:@"%@:%@", UserLogin, UserPassword];
    NSData *authData = [credentials dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encodedHeader = [authData base64EncodedDataWithOptions:0];
    NSString *encodedString = [[NSString alloc] initWithData:encodedHeader encoding:NSUTF8StringEncoding];
    NSString *readyString = [NSString stringWithFormat:@"Basic %@", encodedString];
    
    return readyString;
}

- (BOOL) apiUrlExists
{
    if([config valueForKey:@"ApiUrl"] == nil)
    {
        return NO;
    }
    
    if([[config valueForKey:@"ApiUrl"] isEqualToString:@""])
    {
        return NO;
    }
    
    return YES;
}

- (void) setDefaultApiUrl
{
    // [config setObject:@"http://virtualapi.flapmyport.com" forKey:@"ApiUrl"];
    
    // Это добавляется ВРЕМЕННО!!!
    [config setObject:@"http://isweethome.ihome.ru/api" forKey:@"ApiUrl"];
}

- (BOOL) apiIsDefault
{
    if( [[config valueForKey:@"ApiUrl"] isEqualToString:@"http://virtualapi.flapmyport.com"])
    {
        return YES;
    }
    
    return NO;
}


#pragma mark - Refresh

- (void)refresh: (NSMutableData *) data
{
    [flapList removeAllObjects];
    
    if(data != nil)
    {
        [flapList removeAllObjects];
        
        NSError *dataError = [NSError alloc];
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&dataError];
        
        if(!response)
        {
            
            [self.tableView reloadData];
            [self enableControls];
            
            NSString *userInfoLS = [NSString stringWithFormat:@"Incorrect data received from URL %@\r\n\r\nPlease check your settings in the Settings.app.", ApiUrl];
            [self showAlert:userInfoLS title:@"Data error"];

            return;
        }
        else
        {
            if(![response isKindOfClass:[NSNull class]])
            {
                [self parseResponse:response];
        
            }
            else
            {
                [self showAlert:@"API Returned a null response." title:@"Data error"];
                return;
            }
        }
    }
    
    [self.tableView reloadData];
    
    [self enableControls];
    
	
}

/*

- (IBAction)refreshControl:(UIRefreshControl *)sender {
	
	
	//self.refreshControl = sender;
	
	[self refreshButtonTap:self.refreshButton];
	
}
*/

- (void) parseResponse: (NSDictionary *) response
{
    NSArray *sourceHosts = [response objectForKey:@"hosts"];
 
    for (NSDictionary *sourceHost in sourceHosts)
    {
        if (sourceHost)
        {
            
            NSString *ipaddress = [sourceHost objectForKey:@"ipaddress"];
            
            if(ipaddress)
            {
                // Object that will be stored in flapList
                NSMutableDictionary *host = [[NSMutableDictionary alloc] init];

                
                NSString *ipaddress = [sourceHost objectForKey:@"ipaddress"];
                NSString *hostname = [sourceHost objectForKey:@"name"];
                
                if(!ipaddress || [ipaddress isKindOfClass:[NSNull class]])
                {
                    ipaddress = @"-";
                }
                
                if(!hostname || [hostname isKindOfClass:[NSNull class]])
                {
                    hostname = ipaddress;
                }

                [host setObject:ipaddress forKey:@"ipaddress"];
                [host setObject:hostname forKey:@"hostname"];

                NSArray *sourcePorts = [sourceHost objectForKey:@"ports"];
                
                if(sourcePorts)
                {
                    NSMutableArray *ports = [self parsePorts:sourcePorts];

                    [host setObject:ports forKey:@"ports"];
                }
                
                [flapList addObject:host];
                
            }
        }
    }
}

- (NSMutableArray *) parsePorts: (NSArray *) sourcePorts
{
    NSMutableArray *ports = [[NSMutableArray alloc] init];
    
    for (NSDictionary *sourcePort in sourcePorts)
    {
        // Object for adding to ports array
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        

        // ifAlias
        [item setObject:@"" forKey:@"ifAlias"];
        NSString *ifAlias = [sourcePort objectForKey:@"ifAlias"];
        if(ifAlias) [item setObject:ifAlias forKey:@"ifAlias"];
        
        
        // ifName
        [item setObject:@"" forKey:@"ifName"];
        NSString *ifName = [sourcePort objectForKey:@"ifName"];
        if(ifName) [item setObject:ifName forKey:@"ifName"];
        
        
        // ifOperStatus
        [item setObject:@"" forKey:@"ifOperStatus"];
        NSString *ifOperStatus = [sourcePort objectForKey:@"ifOperStatus"];
        if(ifOperStatus) [item setObject:ifOperStatus forKey:@"ifOperStatus"];
        
        
        // ifIndex
        [item setObject:@"" forKey:@"ifIndex"];
        NSString *ifIndex = [sourcePort objectForKey:@"ifIndex"];
        if(ifIndex) [item setObject:ifIndex forKey:@"ifIndex"];
        
        // flapCount
        [item setObject:@"" forKey:@"flapCount"];
        NSString *flapCount = [sourcePort objectForKey:@"flapCount"];
        if(flapCount) [item setObject:flapCount forKey:@"flapCount"];
        
        // firstFlapTime
        [item setObject:@"" forKey:@"firstFlapTime"];
        NSString *firstFlapTime = [sourcePort objectForKey:@"firstFlapTime"];
        if(firstFlapTime) [item setObject:firstFlapTime forKey:@"firstFlapTime"];
        
        // lastFlapTime
        [item setObject:@"" forKey:@"lastFlapTime"];
        NSString *lastFlapTime = [sourcePort objectForKey:@"lastFlapTime"];
        if(lastFlapTime) [item setObject:lastFlapTime forKey:@"lastFlapTime"];
        
        [ports addObject:item];
    }

    return ports;
}

#pragma mark - Table Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return [flapList count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if([flapList count]==0)
    {
        return @"";
    }
    NSArray *host = [flapList objectAtIndex:section];
    

	return [host valueForKey:@"hostname"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([flapList count]==0)
    {
        return 1;
    }
    
    if([[[flapList objectAtIndex:section] valueForKey:@"ports"] count]==0)
    {
        return 1;
    }

    return [[[flapList objectAtIndex:section] valueForKey:@"ports"] count];
}

- (UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([flapList count]==0)
    {
        if(connectionError == YES)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"errorCell" forIndexPath:indexPath];
            cell.textLabel.text = [connError localizedDescription];
            return cell;
        }
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"emptyCell" forIndexPath:indexPath];
        return cell;
    }

	NSArray *host = [flapList objectAtIndex:indexPath.section];
	
	NSArray *ports = [host valueForKey:@"ports"];
	NSDictionary *port = [ports objectAtIndex:indexPath.row];

	
	FlapCell *cell = [tableView dequeueReusableCellWithIdentifier:@"flapCell" forIndexPath:indexPath];
	
	NSString *startTime = [self shortDate:[port valueForKey:@"firstFlapTime"]];
	NSString *endTime = [self shortDate:[port valueForKey:@"lastFlapTime"]];
	
	cell.dateLabel.text = [NSString stringWithFormat:@" %@ — %@", startTime, endTime];
	
	if ([[port valueForKey:@"ifAlias"] isKindOfClass:[NSNull class]])
	{
		cell.interfaceLabel.text = [NSString stringWithFormat:@"%@", [port valueForKey:@"ifName"]];
	}
	else
	{
		cell.interfaceLabel.text = [NSString stringWithFormat:@"%@ (%@)", [port valueForKey:@"ifName"], [port valueForKey:@"ifAlias"]];
	}
    cell.flapNumberLabel.textColor = [UIColor colorWithRed:0.f green:0.8f blue:0.4f alpha:1.0f];
    
	if([[port valueForKey:@"ifOperStatus"] isEqualToString:@"down"])
	{
		cell.flapNumberLabel.textColor = [UIColor colorWithRed:0.9f green:0.5f blue:0.5f alpha:1.0f];
	}
	cell.flapNumberLabel.text = [port valueForKey:@"flapCount"];

    
	// Preparing the Array for FlapCell
	NSDictionary *flap = @{@"hostname":  [host valueForKey:@"hostname"],
						   @"ipaddress": [host valueForKey:@"ipaddress"],
						   @"port": port};

	cell.flap = flap;
	
	// Load Diagram
	NSString *urlString = [NSString stringWithFormat:@"%@/?ifindex=%@&flapchart&host=%@&interval=%@", ApiUrl, [port valueForKey:@"ifIndex"], [host valueForKey:@"ipaddress"], interval];

    if([[flap valueForKey:@"image"] isKindOfClass:[UIImage class]])
    {
        cell.diagram.image = [flap valueForKey:@"image"];
    }
    else
    {
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
        [req setValue:[self getCredentials] forHTTPHeaderField:@"Authorization"];
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            if (data) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        cell.diagram.image = image;
                    });
                }
            }
        }];
        [task resume];

    }
	return cell;

}

- (void) connectionError: (NSError *) error
{
    
    [flapList removeAllObjects];
    
	[self.tableView reloadData];
    [self enableControls];
    // [self.refreshControl endRefreshing];
    [self pushError:error title:@"Connection error"];
    
}


- (IBAction) unwindToFlapList: (UIStoryboardSegue *) segue
{
	myConnection.delegate = self;
	//[self refreshButtonTap:self.refreshButton];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(FlapCell *)sender
{
	if ( [segue.identifier isEqualToString:@"showHistory"] )
	{
		FlapHistoryViewController *destination = [segue destinationViewController];
		destination.flap = sender.flap;
	}
	
}

- (void) pushError: (NSError * ) error title: (NSString *) title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void) showAlert: (NSString *) message title: (NSString *) title
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {}];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)setNewInterval: (int) seconds {
    
    interval = [NSString stringWithFormat:@"%i", seconds];
    
    [config setObject:interval forKey:@"flapHistoryInterval"];
    
}

- (IBAction)ChangeInterval:(UISegmentedControl *)sender {
    NSLog(@"%ld", (long)sender.selectedSegmentIndex);

    int value = 3600;
    
    if (sender.selectedSegmentIndex == 0)
    {
        value = 600;
    }

    if (sender.selectedSegmentIndex == 1)
    {
        value = 3600;
    }

    if (sender.selectedSegmentIndex == 2)
    {
        value = 10800;
    }

    if (sender.selectedSegmentIndex == 3)
    {
        value = 21600;
    }

    if (sender.selectedSegmentIndex == 4)
    {
        value = 86400;
    }
    
    [self setNewInterval: value];
    
    [self requestData];
    
    // [self updateInterval];
}
@end
