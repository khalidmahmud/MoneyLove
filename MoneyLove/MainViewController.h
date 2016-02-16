//
//  MainViewController.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/20/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainTransactionHeader.h"

@interface MainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (assign, nonatomic) float totalIncome;
@property (assign, nonatomic) float totalExpense;

@end
