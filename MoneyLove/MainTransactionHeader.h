//
//  MainTransactionHeader.h
//  MoneyLove
//
//  Created by Abu Khalid on 1/29/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTransactionHeader : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *incomeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *expenseValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *walletValueLabel;

@end
