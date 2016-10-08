//
//  FlapCell.h
//  FlapMyPort
//
//  Created by Vladislav Pavkin on 30.09.16.
//  Copyright (c) 2016 Vladislav Pavkin. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface FlapCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *interfaceLabel;
@property (weak, nonatomic) IBOutlet UILabel *flapNumberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *diagram;
@property NSDictionary	*flap;
@property NSString		*port;
@property NSString		*host;


@end
