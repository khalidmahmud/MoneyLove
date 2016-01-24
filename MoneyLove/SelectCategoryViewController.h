//
//  SelectCategoryViewController.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/19/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryObject.h"

@protocol SelectCategoryViewControllerDelegate <NSObject>
-(void) selectCategoryObject:(CategoryObject *)categoryObject;
@end

@interface SelectCategoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *expenseTableView;
- (IBAction)selectTransactionType:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) NSArray *expenseCategoryArray;
@property (strong, nonatomic) NSArray *incomeCategoryArray;

@property (nonatomic, weak) id <SelectCategoryViewControllerDelegate> delegate;

@end
