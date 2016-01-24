//
//  MenuViewController.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuHeader.h"

@interface MenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (strong, nonatomic) NSArray *menuOptions;
@property (strong, nonatomic) NSArray *menuOptionsIcons;

@end
