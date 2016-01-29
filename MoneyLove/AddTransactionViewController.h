//
//  AddTransactionViewController.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/18/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectCategoryViewController.h"
#import "CategoryObject.h"

@interface AddTransactionViewController : UIViewController<SelectCategoryViewControllerDelegate>

@property (nonatomic, retain) NSData *imag;
@property (nonatomic, weak) IBOutlet UIButton *buttonCategory;
@property (nonatomic, weak) IBOutlet UILabel *categoryNameLabel;
@property (nonatomic, weak) IBOutlet UITextField *amountTransaction;
@property (nonatomic, weak) IBOutlet UIDatePicker *dateTransaction;
@property (nonatomic, assign)int typeOfCategory;
- (IBAction)selectCategoryAction:(id)sender;
- (IBAction)addTransaction:(id)sender;



@end
