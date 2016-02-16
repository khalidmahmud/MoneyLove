//
//  MainViewController.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/20/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "MainViewController.h"
#import "DataAccess.h"
#import "MainViewDataModel.h"
#import "MainTransactionHeader.h"


@interface MainViewController ()

@property (nonatomic, strong) UITableView *mainTableView1;//initially previous table view
@property (nonatomic, strong) UITableView *mainTableView2;//initially current tableview
@property (nonatomic, strong) UITableView *mainTableView3;//initially next tableview

@property (nonatomic, strong) NSMutableArray *arrayTableView;//array for tableview
@property (nonatomic, strong) NSMutableArray *dataArray1;//array for tableview 1
@property (nonatomic, strong) NSMutableArray *dataArray2;//array for tableview 2
@property (nonatomic, strong) NSMutableArray *dataArray3;//array for tableview 3

@property (nonatomic, assign) float walletIncome1;//initially income of previous week
@property (nonatomic, assign) float walletIncome2;//initially income of current week
@property (nonatomic, assign) float walletIncome3;//initially income of next week
@property (nonatomic, assign) float walletExpense1;//initially expense of previous week
@property (nonatomic, assign) float walletExpense2;//initially expense of current week
@property (nonatomic, assign) float walletExpense3;//initially expense of next week


@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}


 //reloading when coming back from addTransaction
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
    // getting the wallet
    if ([DataAccess getTotalExpense] < 0.0) {
        NSLog(@"Error occured....");
    } else {
        self.totalExpense = [DataAccess getTotalExpense];
    }
    if ([DataAccess getTotalIncome] < 0.0) {
        NSLog(@"Error occured....");
    } else {
        self.totalIncome = [DataAccess getTotalIncome];
    }
    self.title = [[NSString alloc] initWithString:[NSString stringWithFormat:@"Your Wallet = %.2f",(self.totalIncome - self.totalExpense)]];
  
  
    //getting current date..............
    self.startDate = [self setStartDateFromCurrentDate];
    self.endDate = [self nextWeekCalculation:self.startDate];//adding 7 days to startdate giving the end date
  
    //using data access data array 2......
    DataAccess *accessData = [[DataAccess alloc] init];
    NSMutableArray *resultOfExpense2 = [[accessData getExpenseWithStartDate:self.startDate endDate:self.endDate] mutableCopy];
    NSMutableArray *resultOfIncome2 = [[accessData getIncomeWithStartDate:self.startDate endDate:self.endDate] mutableCopy];
    //using data access....
    
    self.walletExpense2 = [self totalSumFromArray:resultOfExpense2];
    //getting the income...current week initially
    self.walletIncome2 = [self totalSumFromArray:resultOfIncome2];
    
    
    //data array 1............
    NSMutableArray *resultOfExpense1 = [[accessData getExpenseWithStartDate:[self previousWeekCalculation:self.startDate]endDate:[self previousWeekCalculation:self.endDate]] mutableCopy];
    NSMutableArray *resultOfIncome1 = [[accessData getIncomeWithStartDate:[self previousWeekCalculation:self.startDate] endDate:[self previousWeekCalculation:self.endDate]]mutableCopy];
    
    //getting the expense....previous week
    self.walletExpense1 = [self totalSumFromArray:resultOfExpense1];
    //getting the income...previous week
    self.walletIncome1 = [self totalSumFromArray:resultOfIncome1];
 
    //data array 3............
    NSMutableArray *resultOfExpense3 = [[accessData getExpenseWithStartDate:[self nextWeekCalculation:self.startDate]endDate:[self nextWeekCalculation:self.endDate]] mutableCopy];
    NSMutableArray *resultOfIncome3 = [[accessData getIncomeWithStartDate:[self nextWeekCalculation:self.startDate] endDate:[self nextWeekCalculation:self.endDate]] mutableCopy];
    
    //getting the expense....next week
    self.walletExpense3 = [self totalSumFromArray:resultOfExpense3];
    
    //getting the income...next week
    self.walletIncome3 = [self totalSumFromArray:resultOfIncome3];
    
    [self setScrollView];
    
    float x = 0.0;
    self.mainTableView1 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mainTableView1.dataSource = self;
    self.mainTableView1.delegate = self;
    self.mainTableView1.tag = 1;
    [self.mainScrollView addSubview:self.mainTableView1];
    
    x += self.view.bounds.size.width;
    self.mainTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mainTableView2.dataSource = self;
    self.mainTableView2.delegate = self;
    self.mainTableView2.tag = 2;
    [self.mainScrollView addSubview:self.mainTableView2];
    
    x += self.view.bounds.size.width;
    self.mainTableView3 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.mainTableView3.dataSource = self;
    self.mainTableView3.delegate = self;
    self.mainTableView3.tag = 3;
    [self.mainScrollView addSubview:self.mainTableView3];
    
    self.arrayTableView = [NSMutableArray arrayWithObjects:self.mainTableView1, self.mainTableView2, self.mainTableView3, nil];
    
    self.dataArray1 = [NSMutableArray arrayWithArray:resultOfExpense1];
    [self.dataArray1 addObjectsFromArray:resultOfIncome1];
    
    self.dataArray2 = [NSMutableArray arrayWithArray:resultOfExpense2];
    [self.dataArray2 addObjectsFromArray:resultOfIncome2];
    
    self.dataArray3 = [NSMutableArray arrayWithArray:resultOfExpense3];
    [self.dataArray3 addObjectsFromArray:resultOfIncome3];

   //if initially any data array is empty......
    if (![self.dataArray1 count]) {
      UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
      [tempImageView setFrame:self.mainTableView1.frame];
      self.mainTableView1.backgroundView = tempImageView;
    }
    if(![self.dataArray2 count] ) {
      UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
      [tempImageView setFrame:self.mainTableView2.frame];
      self.mainTableView2.backgroundView = tempImageView;
    }
    if(![self.dataArray3 count] ) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:self.mainTableView3.frame];
        self.mainTableView3.backgroundView = tempImageView;
    }
    
    [self.mainTableView1 registerNib:[UINib nibWithNibName:@"MainTransactionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MainTransactionHeader"];
    [self.mainTableView2 registerNib:[UINib nibWithNibName:@"MainTransactionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MainTransactionHeader"];
    [self.mainTableView3 registerNib:[UINib nibWithNibName:@"MainTransactionHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"MainTransactionHeader"];
    
}

-(void)setScrollView {
    CGSize size = CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height);
    [self.mainScrollView setContentSize:size];
    
    CGPoint point = CGPointMake(self.view.bounds.size.width, 0.0);
    [self.mainScrollView setContentOffset:point];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.mainTableView1]) {
        return [self.dataArray1 count];
    } else if ([tableView isEqual:self.mainTableView2]) {
        return [self.dataArray2 count];
    } else {
        return [self.dataArray3 count];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *mainTableIdentifier = @"MainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:mainTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:mainTableIdentifier];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    NSMutableArray *arrayTemp1 = [[NSMutableArray alloc] init];
    DataAccess *accessData = [[DataAccess alloc] init];
    
    if ([tableView isEqual:self.mainTableView1]) {
        arrayTemp1 = self.dataArray1;
    } else if ([tableView isEqual:self.mainTableView2]) {
        arrayTemp1 = self.dataArray2;
    } else {
        arrayTemp1 = self.dataArray3;
    }
    if (arrayTemp1.count) {
        MainViewDataModel *data = [arrayTemp1 objectAtIndex:indexPath.row];
        if (data.type == 1) {  // If type is expense
            cell.textLabel.text = data.category;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",data.amount];
            cell.detailTextLabel.textColor = [UIColor redColor];
            cell.imageView.image = [accessData getIcon:data.category typeTransaction:data.type];
        } else if (data.type == 2) { // If type is income
            cell.textLabel.text = data.category;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f",data.amount];
            cell.detailTextLabel.textColor = [UIColor blueColor];
            cell.imageView.image = [accessData getIcon:data.category typeTransaction:data.type];
            
        }
    }

    return cell;
}

#pragma mark - updating Previous week and Next Week

- (NSMutableArray *)getPreviousWeek {
    NSMutableArray *previousWeekData;
    NSMutableArray *previousWeekDataExpense;
    NSMutableArray *previousWeekDataIncome;
    DataAccess *accessData = [[DataAccess alloc] init];
    previousWeekDataExpense = [[accessData getExpenseWithStartDate:[self previousWeekCalculation:self.startDate] endDate:[self previousWeekCalculation:self.endDate]] mutableCopy];
    previousWeekDataIncome = [[accessData getIncomeWithStartDate:[self previousWeekCalculation:self.startDate] endDate:[self previousWeekCalculation:self.endDate]] mutableCopy];
    previousWeekData = [NSMutableArray arrayWithArray:previousWeekDataExpense];
    [previousWeekData addObjectsFromArray:previousWeekDataIncome];
    return previousWeekData;
}

- (NSMutableArray *)getNextWeek {
    NSMutableArray *nextWeek;
    NSMutableArray *nextWeekDataExpense;
    NSMutableArray *nextWeekDataIncome;
    DataAccess *accessData = [[DataAccess alloc] init];
    nextWeekDataExpense = [[accessData getExpenseWithStartDate:[self nextWeekCalculation:self.startDate] endDate:[self nextWeekCalculation:self.endDate]] mutableCopy];
    nextWeekDataIncome = [[accessData getIncomeWithStartDate:[self nextWeekCalculation:self.startDate] endDate:[self nextWeekCalculation:self.endDate]] mutableCopy];
    nextWeek = [NSMutableArray arrayWithArray:nextWeekDataExpense];
    [nextWeek addObjectsFromArray:nextWeekDataIncome];
    return nextWeek;
}


#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.mainScrollView) {
        if(scrollView.contentOffset.x == 0) {
          self.startDate = [self.startDate dateByAddingTimeInterval:-60*60*24*7];
          self.endDate = [self.endDate dateByAddingTimeInterval:-60*60*24*7];
          [self moveRight];
        } else if(scrollView.contentOffset.x == (self.view.bounds.size.width*2)) {
            self.startDate = [self.startDate dateByAddingTimeInterval:60*60*24*7];
            self.endDate = [self.endDate dateByAddingTimeInterval:60*60*24*7];
            [self moveLeft];
        } else
            return;
    }
    
}

-(void)moveLeft {
    
    UITableView *tempTblView = [self.arrayTableView objectAtIndex:0];
    [self.arrayTableView removeObjectAtIndex:0];
    [self.arrayTableView insertObject:tempTblView atIndex:2];
    
    [self updateScrollViewCotent];
    
    //load next week
    if ([tempTblView isEqual:self.mainTableView1]) {
     self.dataArray1 = [self getNextWeek];
     [self showNoDataView:self.dataArray1 identifier:2];
     } else if ([tempTblView isEqual:self.mainTableView2]) {
     self.dataArray2 = [self getNextWeek];
     [self showNoDataView:self.dataArray2 identifier:2];
     } else if ([tempTblView isEqual:self.mainTableView3]) {
     self.dataArray3 = [self getNextWeek];
     [self showNoDataView:self.dataArray3 identifier:2];
     }
}

-(void)moveRight {
    
    UITableView *tempTblView = [self.arrayTableView objectAtIndex:2];
    [self.arrayTableView removeObjectAtIndex:2];
    [self.arrayTableView insertObject:tempTblView atIndex:0];
    
    [self updateScrollViewCotent];

    if ([tempTblView isEqual:self.mainTableView1]) {
        self.dataArray1 = [self getPreviousWeek];
        [self showNoDataView:self.dataArray1 identifier:0];
    } else if ([tempTblView isEqual:self.mainTableView2]) {
        self.dataArray2 = [self getPreviousWeek];
        [self showNoDataView:self.dataArray2 identifier:0];
    } else if ([tempTblView isEqual:self.mainTableView3]) {
        self.dataArray3 = [self getPreviousWeek];
        [self showNoDataView:self.dataArray3 identifier:0];
    }
}

-(void)updateScrollViewCotent {
    for (int i = 0; i < self.arrayTableView.count; i++) {
        UITableView *tblView = [self.arrayTableView objectAtIndex:i];
        
        [tblView setFrame:CGRectMake(i * self.view.bounds.size.width, 0.0, tblView.frame.size.width, tblView.frame.size.height)];
        tblView.tag = i + 1;
        [self.arrayTableView replaceObjectAtIndex:i withObject:tblView];
    }
  
    CGPoint point = CGPointMake(self.view.bounds.size.width, 0.0);
    [self.mainScrollView setContentOffset:point];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MainTransactionHeader *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"MainTransactionHeader"];
    DataAccess *accessData = [[DataAccess alloc] init];

    if (tableView.tag == 1) {//previous view section header
        
        //fixing wallet
        //data array 1............
        NSMutableArray *resultOfExpense1 = [[accessData getExpenseWithStartDate:[self previousWeekCalculation:self.startDate]endDate:[self previousWeekCalculation:self.endDate]] mutableCopy];
        NSMutableArray *resultOfIncome1 = [[accessData getIncomeWithStartDate:[self previousWeekCalculation:self.startDate] endDate:[self previousWeekCalculation:self.endDate]]mutableCopy];
        
        //getting the expense....previous week
        self.walletExpense1 = [self totalSumFromArray:resultOfExpense1];
        
        //getting the income...previous week
        self.walletIncome1 = [self totalSumFromArray:resultOfIncome1];
        //header labels
      
        header.incomeValueLabel.text = [NSString stringWithFormat:@"%.2f", self.walletIncome1];
        header.expenseValueLabel.text = [NSString stringWithFormat:@"%.2f", self.walletExpense1];
        header.walletValueLabel.text = [NSString stringWithFormat:@"%.2f", (self.walletIncome1 - self.walletExpense1)];
        if ((self.walletIncome1 - self.walletExpense1) < 0) {
            header.walletValueLabel.textColor = [UIColor redColor];
        } else {
            header.walletValueLabel.textColor = [UIColor blueColor];
        }
    }

    if (tableView.tag == 2) { //current  view overview section header
        //fixing wallet
        NSMutableArray *resultOfExpense2 = [[accessData getExpenseWithStartDate:self.startDate endDate:self.endDate] mutableCopy];
        NSMutableArray *resultOfIncome2 = [[accessData getIncomeWithStartDate:self.startDate endDate:self.endDate] mutableCopy];
        //using data access....
        
        //getting the expense....current week initially
        self.walletExpense2 = [self totalSumFromArray:resultOfExpense2];
        
        //getting the income...current week initially
        self.walletIncome2 = [self totalSumFromArray:resultOfIncome2];
        //header labels
      
        header.incomeValueLabel.text = [NSString stringWithFormat:@"%.2f", self.walletIncome2];
        header.expenseValueLabel.text = [NSString stringWithFormat:@"%.2f", self.walletExpense2];
        header.walletValueLabel.text = [NSString stringWithFormat:@"%.2f", (self.walletIncome2 - self.walletExpense2)];
        if ((self.walletIncome2 - self.walletExpense2) < 0) {
            header.walletValueLabel.textColor = [UIColor redColor];
        } else {
            header.walletValueLabel.textColor = [UIColor blueColor];
        }
    }
    
    if (tableView.tag == 3) { //next view section header
        //fixing wallet..........
        NSMutableArray *resultOfExpense3 = [[accessData getExpenseWithStartDate:[self nextWeekCalculation:self.startDate]endDate:[self nextWeekCalculation:self.endDate]] mutableCopy];
        NSMutableArray *resultOfIncome3 = [[accessData getIncomeWithStartDate:[self nextWeekCalculation:self.startDate] endDate:[self nextWeekCalculation:self.endDate]] mutableCopy];
        //getting the expense....next week
        self.walletExpense3 = [self totalSumFromArray:resultOfExpense3];
        
        //getting the income...next week
        self.walletIncome3 = [self totalSumFromArray:resultOfIncome3];
        //header labels
      
        header.incomeValueLabel.text = [NSString stringWithFormat:@"%.2f", self.walletIncome3];
        header.expenseValueLabel.text = [NSString stringWithFormat:@"%.2f", self.walletExpense3];
        header.walletValueLabel.text = [NSString stringWithFormat:@"%.2f", (self.walletIncome3 - self.walletExpense3)];
        if ((self.walletIncome3 - self.walletExpense3) < 0) {
            header.walletValueLabel.textColor = [UIColor redColor];
        } else {
            header.walletValueLabel.textColor = [UIColor blueColor];
        }
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 170;
    }
}

- (NSDate *)setStartDateFromCurrentDate {
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:[NSDate date]];
    
    [components setDay:([components day] - ([components weekday] - 1))];
    [components setHour:06];//for UTC
    [components setMinute:00];
    [components setSecond:00];

   return [calendar dateFromComponents:components];
    
}

- (NSDate *) nextWeekCalculation:(NSDate *)givenDate {
    return [givenDate dateByAddingTimeInterval:60*60*24*7];
}

- (NSDate *) previousWeekCalculation:(NSDate *)givenDate {
    return [givenDate dateByAddingTimeInterval:-60*60*24*7];
}


- (float) totalSumFromArray:(NSMutableArray *)arrayTotal {
    float sum = 0.0;
    if ([arrayTotal count]) {
        sum = [[[arrayTotal valueForKey:@"amount"] valueForKeyPath:@"@sum.self"] floatValue];
    } else {
        sum = 0.0;
    }
   return  sum;
}

- (void) showNoDataView:(NSArray *)checkArray identifier:(int)tableIdentifier {
    if (![checkArray count]) {
        UITableView *tblView1 = [self.arrayTableView objectAtIndex:tableIdentifier];
        [tblView1 reloadData];
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:tblView1.frame];
        tblView1.backgroundView = tempImageView;
        [tblView1 reloadData];
    } else if ([checkArray count]) {
        UITableView *tblView1 = [self.arrayTableView objectAtIndex:tableIdentifier];
        tblView1.backgroundView.hidden = YES;
        [tblView1 reloadData];
    }
}


@end
