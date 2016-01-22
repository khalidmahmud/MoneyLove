//
//  SelectCategoryViewController.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *expenseTableView;
- (IBAction)selectTransactionType:(id)sender;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *expenseCategoryArray;
@property (strong, nonatomic) NSArray *incomeCategoryArray;

@end
