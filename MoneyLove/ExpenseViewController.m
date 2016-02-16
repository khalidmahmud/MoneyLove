//
//  ExpenseViewController.m
//  MoneyLove
//
//  Created by Abu Khalid on 1/20/16.
//  Copyright © 2016 Abu Khalid. All rights reserved.
//

#import "ExpenseViewController.h"
#import "DataAccess.h"
#import "ExpenseDataModel.h"
#import "StatisticsExpenseHeader.h"


@interface ExpenseViewController ()

@property (nonatomic, strong) UITableView *expenseTableView1;//initially previous table view
@property (nonatomic, strong) UITableView *expenseTableView2;//initially current tableview
@property (nonatomic, strong) UITableView *expenseTableView3;//initially next tableview

@property (nonatomic, strong) NSMutableArray *arrayTableView;//array for tableview
@property (nonatomic, strong) NSMutableArray *expenseDataArray1;//array for tableview 1
@property (nonatomic, strong) NSMutableArray *expenseDataArray2;//array for tableview 2
@property (nonatomic, strong) NSMutableArray *expenseDataArray3;//array for tableview 3

@property (nonatomic, assign) float walletExpense1;//initially income of previous week
@property (nonatomic, assign) float walletExpense2;//initially income of current week
@property (nonatomic, assign) float walletExpense3;//initially income of next week

@end

@implementation ExpenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //getting the wallet statistics
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
  
    //getting the start and end dates
    self.currentStartDate = [self setStartDateFromCurrentDate];
    self.currentEndDate = [self nextMonthCalculation:self.currentStartDate];//getting to next month
    //using data access data array 2......
    DataAccess *accessData = [[DataAccess alloc] init];
    NSMutableArray *resultOfExpense2 = [[accessData getExpenseWithStartDate:self.currentStartDate endDate:self.currentEndDate] mutableCopy];
    //using data access....
    //getting the expense...current week initially
    self.walletExpense2 = [self totalSumFromArray:resultOfExpense2];
    //data array 1............
    NSMutableArray *resultOfExpense1 = [[accessData getExpenseWithStartDate:[self previousMonthCalculation:self.currentStartDate] endDate:[self previousMonthCalculation:self.currentEndDate]]mutableCopy];
    
    //getting the expense...previous week
    self.walletExpense1 = [self totalSumFromArray:resultOfExpense1];
    
    //data array 3............
    NSMutableArray *resultOfExpense3 = [[accessData getExpenseWithStartDate:[self nextMonthCalculation:self.currentStartDate] endDate:[self nextMonthCalculation:self.currentEndDate]] mutableCopy];
    
    //getting the income...next week
    self.walletExpense3 = [self totalSumFromArray:resultOfExpense3];
    
    [self setScrollView];
    
    float x = 0.0;
    self.expenseTableView1 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.expenseTableView1.dataSource = self;
    self.expenseTableView1.delegate = self;
    self.expenseTableView1.tag = 1;
    [self.expenseScrollView addSubview:self.expenseTableView1];
    
    x += self.view.bounds.size.width;
    self.expenseTableView2 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.expenseTableView2.dataSource = self;
    self.expenseTableView2.delegate = self;
    self.expenseTableView2.tag = 2;
    [self.expenseScrollView addSubview:self.expenseTableView2];
    
    x += self.view.bounds.size.width;
    self.expenseTableView3 = [[UITableView alloc]initWithFrame:CGRectMake(x, 0.0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.expenseTableView3.dataSource = self;
    self.expenseTableView3.delegate = self;
    self.expenseTableView3.tag = 3;
    [self.expenseScrollView addSubview:self.expenseTableView3];
    
    self.arrayTableView = [NSMutableArray arrayWithObjects:self.expenseTableView1, self.expenseTableView2, self.expenseTableView3, nil];
    
    self.expenseDataArray1 = [NSMutableArray arrayWithArray:resultOfExpense1];
    self.expenseDataArray2 = [NSMutableArray arrayWithArray:resultOfExpense2];
    self.expenseDataArray3 = [NSMutableArray arrayWithArray:resultOfExpense3];
    
    //if initially any data array is empty......
    if (![self.expenseDataArray1 count]) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:self.expenseTableView1.frame];
        self.expenseTableView1.backgroundView = tempImageView;
    }
    if(![self.expenseDataArray2 count] ) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:self.expenseTableView2.frame];
        self.expenseTableView2.backgroundView = tempImageView;
    }
    if(![self.expenseDataArray3 count] ) {
        UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Question_mark_Icon_64.png"]];
        [tempImageView setFrame:self.expenseTableView3.frame];
        self.expenseTableView3.backgroundView = tempImageView;
    }
    
    [self.expenseTableView1 registerNib:[UINib nibWithNibName:@"StatisticsExpenseHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatisticsExpenseHeader"];
    [self.expenseTableView2 registerNib:[UINib nibWithNibName:@"StatisticsExpenseHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatisticsExpenseHeader"];
    [self.expenseTableView3 registerNib:[UINib nibWithNibName:@"StatisticsExpenseHeader" bundle:nil] forHeaderFooterViewReuseIdentifier:@"StatisticsExpenseHeader"];
}

-(void)setScrollView {
    CGSize size = CGSizeMake(self.view.bounds.size.width * 3, self.view.bounds.size.height);
    [self.expenseScrollView setContentSize:size];
    
    CGPoint point = CGPointMake(self.view.bounds.size.width, 0.0);
    [self.expenseScrollView setContentOffset:point];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.expenseTableView1]) {
        return [self.expenseDataArray1 count];
    } else if ([tableView isEqual:self.expenseTableView2]) {
        return [self.expenseDataArray2 count];
    } else {
        return [self.expenseDataArray3 count];
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
    static NSString *expenseTableIdentifier = @"ExpenseCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:expenseTableIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:expenseTableIdentifier];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    NSMutableArray *arrayTemp1 = [[NSMutableArray alloc] init];
    DataAccess *accessData = [[DataAccess alloc] init];
    
    if ([tableView isEqual:self.expenseTableView1]) {
        arrayTemp1 = self.expenseDataArray1;
    } else if ([tableView isEqual:self.expenseTableView2]) {
        arrayTemp1 = self.expenseDataArray2;
    } else {
        arrayTemp1 = self.expenseDataArray3;
    }
    if (arrayTemp1.count) {
        ExpenseDataModel *data = [arrayTemp1 objectAtIndex:indexPath.row];
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


#pragma mark - updating Previous Month and Next Month

- (NSMutableArray *)getPreviousMonth {
    NSMutableArray *previousMonthDataExpense;
    DataAccess *accessData = [[DataAccess alloc] init];
    previousMonthDataExpense = [[accessData getExpenseWithStartDate:[self previousMonthCalculation:self.currentStartDate] endDate:[self previousMonthCalculation:self.currentEndDate]] mutableCopy];
    return previousMonthDataExpense;
}

- (NSMutableArray *)getNextMonth {
    NSMutableArray *nextMonthDataExpense;
    DataAccess *accessData = [[DataAccess alloc] init];
    
    nextMonthDataExpense = [[accessData getExpenseWithStartDate:[self nextMonthCalculation:self.currentStartDate] endDate:[self nextMonthCalculation:self.currentEndDate]] mutableCopy];
    return nextMonthDataExpense;
}


#pragma mark - ScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.expenseScrollView) {
        if(scrollView.contentOffset.x == 0) {
            NSDate *tempDate = self.currentStartDate;
            self.currentStartDate = [self previousMonthCalculation:self.currentStartDate];
            self.currentEndDate = tempDate;
            [self moveRight];
        } else if(scrollView.contentOffset.x == (self.view.bounds.size.width*2)) {
            self.currentStartDate = self.currentEndDate;
            self.currentEndDate = [self nextMonthCalculation:self.currentEndDate];
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
    
    //load next month
    if ([tempTblView isEqual:self.expenseTableView1]) {
        self.expenseDataArray1 = [self getNextMonth];
        [self showNoDataView:self.expenseDataArray1 identifier:2];
    } else if ([tempTblView isEqual:self.expenseTableView2]) {
        self.expenseDataArray2 = [self getNextMonth];
        [self showNoDataView:self.expenseDataArray2 identifier:2];
    } else if ([tempTblView isEqual:self.expenseTableView3]) {
        self.expenseDataArray3 = [self getNextMonth];
        [self showNoDataView:self.expenseDataArray3 identifier:2];
    }
}

-(void)moveRight {
    
    UITableView *tempTblView = [self.arrayTableView objectAtIndex:2];
    [self.arrayTableView removeObjectAtIndex:2];
    [self.arrayTableView insertObject:tempTblView atIndex:0];
    
    [self updateScrollViewCotent];
    
    if ([tempTblView isEqual:self.expenseTableView1]) {
        self.expenseDataArray1 = [self getPreviousMonth];
        [self showNoDataView:self.expenseDataArray1 identifier:0];
    } else if ([tempTblView isEqual:self.expenseTableView2]) {
        self.expenseDataArray2 = [self getPreviousMonth];
        [self showNoDataView:self.expenseDataArray2 identifier:0];
    } else if ([tempTblView isEqual:self.expenseTableView3]) {
        self.expenseDataArray3 = [self getPreviousMonth];
        [self showNoDataView:self.expenseDataArray3 identifier:0];
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
    [self.expenseScrollView setContentOffset:point];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    StatisticsExpenseHeader *header=[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"StatisticsExpenseHeader"];
    DataAccess *accessData = [[DataAccess alloc] init];
    
    if (tableView.tag == 1) {//previous view section header
        //fixing wallet
        //data array 1............
        NSMutableArray *resultOfExpense1 = [[accessData getExpenseWithStartDate:[self previousMonthCalculation:self.currentStartDate] endDate:[self previousMonthCalculation:self.currentEndDate]]mutableCopy];
        //getting the income...previous week
        self.walletExpense1 = [self totalSumFromArray:resultOfExpense1];
        header.monthlyExpenseLabel.text = [NSString stringWithFormat:@"%.2f", self.walletExpense1];
        header.monthlyExpenseLabel.textColor = [UIColor redColor];
    }
    if (tableView.tag == 2) { //current  view overview section header
        //fixing wallet
        NSMutableArray *resultOfExpense2 = [[accessData getExpenseWithStartDate:self.currentStartDate endDate:self.currentEndDate] mutableCopy];
        //getting the income...current week initially
        self.walletExpense2 = [self totalSumFromArray:resultOfExpense2];
        header.monthlyExpenseLabel.text = [NSString stringWithFormat:@"%.2f", self.walletExpense2];
        header.monthlyExpenseLabel.textColor = [UIColor redColor];
    }
    if (tableView.tag == 3) { //next view section header
        //fixing wallet..........
        NSMutableArray *resultOfExpense3 = [[accessData getExpenseWithStartDate:[self nextMonthCalculation:self.currentStartDate] endDate:[self nextMonthCalculation:self.currentEndDate]] mutableCopy];
        self.walletExpense3 = [self totalSumFromArray:resultOfExpense3];
        ////
        header.monthlyExpenseLabel.text = [NSString stringWithFormat:@"%.2f", self.walletExpense3];
        header.monthlyExpenseLabel.textColor = [UIColor redColor];
    }
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView.dataSource tableView:tableView numberOfRowsInSection:section] == 0) {
        return 0;
    } else {
        return 120;
    }
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

- (NSDate *)setStartDateFromCurrentDate {
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:[NSDate date]];
    [components setHour:06];
    return [calendar dateFromComponents:components];
}

- (NSDate *) nextMonthCalculation:(NSDate *)givenDate {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:givenDate];
    
    [components setMonth:([components month] + 1)];
    [components setHour:06];
    
    return [calendar dateFromComponents:components];
}

- (NSDate *) previousMonthCalculation:(NSDate *)givenDate {
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents* components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:givenDate];
    [components setMonth:([components month] - 1)];
    [components setHour:06];
    
    return [calendar dateFromComponents:components];
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


@end
