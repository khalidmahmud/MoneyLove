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
- (IBAction)selectCategoryAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonCategory;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;





@end
