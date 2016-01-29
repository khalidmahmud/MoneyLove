//
//  ExpenseViewController.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/20/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpenseViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *expenseScrollView;
@property (strong, nonatomic) NSDate *currentStartDate;
@property (strong, nonatomic) NSDate *currentEndDate;
@property (assign, nonatomic) float totalIncome;
@property (assign, nonatomic) float totalExpense;

@end
