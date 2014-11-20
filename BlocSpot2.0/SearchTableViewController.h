//
//  SearchTableViewController.h
//  BlocSpot2.0
//
//  Created by Anthony Dagati on 11/14/14.
//  Copyright (c) 2014 Black Rail Capital. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController

@property (nonatomic, strong) NSString *searchTextForTableView;

-(void)makeSearchRequests:(NSString *)searchText;

@property (nonatomic, strong) NSArray *googlePlacesArrayFromAFNetworking;

@end
