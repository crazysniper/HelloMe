//
//  CustomPicker.m
//  DIYdemo
//
//  Created by Smartphone24 on 13-9-2.
//  Copyright (c) 2013年 ldns. All rights reserved.
//

#import "CustomPicker.h"
#import "ThemeManager.h"

typedef enum {
    PickerTypeNormal,
    PickerTypeDate,
    PickerTypeCustomDate
}PickerType;

@interface CustomPickerView : UIActionSheet <UIPickerViewDataSource, UIPickerViewDelegate> {
    UIDatePicker *_datePicker;
    UIPickerView *_pickerView;
    //    UIPickerView *_minSecPickerView;
    UIToolbar *toolBar;
}

@property (nonatomic, strong) okButtonPressed_t okButtonPressedBlock;
@property (nonatomic, strong) NSArray *dispalyNamesArray;
@property (nonatomic, strong) NSArray *retValuesArray;
@property (nonatomic) NSInteger currentSelectedRow;
@property (nonatomic) NSInteger currentSelectedMin;
@property (nonatomic) NSInteger currentSelectedSec;
@property (nonatomic) CGFloat componentWidth;

- (id)initWithcomponentWidth:(CGFloat)width
        currentSelectedValue:(id)value
                dispalyNames:(NSArray *)nameArray
                   retValues:(NSArray *)valuesArray;

- (id)initDatePickerWithCurrentSelectedDate:(NSDate *)currentDate;

- (id)initMinSecDatePickerWithCurrentSelectedDate:(NSInteger)currentSec;

@end

#pragma mark - CustomPickerView

@implementation CustomPickerView

- (id)initWithcomponentWidth:(CGFloat)width
        currentSelectedValue:(id)value
                dispalyNames:(NSArray *)nameArray
                   retValues:(NSArray *)valuesArray
{
    self = [self initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                      delegate:nil
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
    
	if (self) {
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *okButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(okBtnAction:)];
        okButtonItem.tag = PickerTypeNormal;
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(cancelBtnAction)];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                          target:nil
                                                                                          action:nil];
        okButtonItem.width = 70;
        cancelButtonItem.width = 70;
        [toolBar setItems:[NSArray arrayWithObjects:cancelButtonItem, flexibleSpaceItem, okButtonItem, nil]];
        [self addSubview:toolBar];
        
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.tag = PickerTypeNormal;
        _pickerView.showsSelectionIndicator = YES;
        
        self.componentWidth = width;
        self.dispalyNamesArray = nameArray;
        self.retValuesArray = valuesArray;
        
        CGRect frame = _pickerView.frame;
        frame.origin.y = 44;
        _pickerView.frame = frame;
        
        [self addSubview:_pickerView];
        
        NSInteger currentRow = [_retValuesArray indexOfObject:value];
        if (currentRow == NSNotFound) {
            currentRow = 0;
        }
        self.currentSelectedRow = currentRow;
        [_pickerView selectRow:currentRow inComponent:0 animated:NO];
    }
    return self;
}

- (id)initDatePickerWithCurrentSelectedDate:(NSDate *)currentDate {
    self = [self initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                      delegate:nil
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
    
	if (self) {
        [self regitserAsObserver];
        toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        //        toolBar.backgroundColor = [UIColor blueColor];
        [self configureViews];
        UIBarButtonItem *okButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(okBtnAction:)];
        okButtonItem.tag = PickerTypeDate;
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(cancelBtnAction)];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                          target:nil
                                                                                          action:nil];
        okButtonItem.width = 70;
        cancelButtonItem.width = 70;
        [toolBar setItems:[NSArray arrayWithObjects:cancelButtonItem,flexibleSpaceItem, okButtonItem, nil]];
        [self addSubview:toolBar];
        
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        
        
        NSDateComponents *maxComps = [[NSDateComponents alloc]init];
        [maxComps setYear:2099];
        [maxComps setMonth:12];
        [maxComps setDay:31];
        _datePicker.maximumDate = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]dateFromComponents:maxComps];
        _datePicker.minimumDate = [NSDate date];
        if (currentDate) {
            _datePicker.date = currentDate;
        } else {
            NSDateComponents *defaultComps = [[NSDateComponents alloc]init];
            [defaultComps setYear:2013];
            [defaultComps setMonth:1];
            [defaultComps setDay:1];
            _datePicker.date = [[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar]dateFromComponents:defaultComps];
        }
        CGRect frame = _datePicker.frame;
        frame.origin.y = 44;
        _datePicker.frame = frame;
        
        [self addSubview:_datePicker];
    }
    return self;
}
- (void)regitserAsObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(configureViews)
                   name:ThemeDidChangeNotification
                 object:nil];
}
- (void)configureViews
{
    [toolBar setBackgroundColor:[[ThemeManager sharedInstance]colorWithColorName]];
    
}
- (id)initMinSecDatePickerWithCurrentSelectedDate:(NSInteger)currentSec {
    self = [self initWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n\n"
                      delegate:nil
             cancelButtonTitle:nil
        destructiveButtonTitle:nil
             otherButtonTitles:nil];
    
	if (self) {
        
        UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
        UIBarButtonItem *okButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定"
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(okBtnAction:)];
        okButtonItem.tag = PickerTypeCustomDate;
        UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消"
                                                                            style:UIBarButtonItemStyleBordered
                                                                           target:self
                                                                           action:@selector(cancelBtnAction)];
        UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                          target:nil
                                                                                          action:nil];
        okButtonItem.width = 70;
        cancelButtonItem.width = 70;
        [toolBar setItems:[NSArray arrayWithObjects:cancelButtonItem, flexibleSpaceItem, okButtonItem, nil]];
        [self addSubview:toolBar];
        
        _pickerView = [[UIPickerView alloc]init];
        _pickerView.dataSource = self;
        _pickerView.delegate = self;
        _pickerView.tag = PickerTypeCustomDate;
        _pickerView.showsSelectionIndicator = YES;
        
        CGRect frame = _pickerView.frame;
        frame.origin.y = 44;
        _pickerView.frame = frame;
        
        [self addSubview:_pickerView];
        
        UILabel *minLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 127, 40, 50)];
        minLabel.text = @"时";
        minLabel.textColor = [UIColor colorWithRed:49.f/255.f green:54.f/255.f blue:69.f/255.f alpha:1.f];
        minLabel.backgroundColor = [UIColor clearColor];
        minLabel.font = [UIFont systemFontOfSize:20];
        UILabel *secLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 127, 40, 50)];
        secLabel.text = @"分";
        secLabel.textColor = [UIColor colorWithRed:49.f/255.f green:54.f/255.f blue:69.f/255.f alpha:1.f];
        secLabel.backgroundColor = [UIColor clearColor];
        secLabel.font = [UIFont systemFontOfSize:20];
        [self addSubview:minLabel];
        [self addSubview:secLabel];
        
        self.currentSelectedMin = currentSec;
        self.currentSelectedSec = currentSec;
        [_pickerView selectRow:_currentSelectedMin inComponent:0 animated:NO];
        [_pickerView selectRow:_currentSelectedSec inComponent:1 animated:NO];
    }
    return self;
}

- (void)showCustomPickView:(id)sender okButtonPressedBlock:(okButtonPressed_t)block {
    
    UIViewController *viewController = (UIViewController *)sender;
    if (viewController.tabBarController) {
        [self showFromTabBar:viewController.tabBarController.tabBar];
    } else {
        [self showInView:viewController.view];
    }
    self.okButtonPressedBlock = block;
}

#pragma mark - Picker Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == PickerTypeCustomDate) {
        return 2;
    } else {
        return 1;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == PickerTypeCustomDate) {
        if (component == 0) {
            return 24;
        }else{
            return 60;
        }
    } else {
        return [_dispalyNamesArray count];
    }
}

// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    if (pickerView.tag == PickerTypeCustomDate) {
        return 150;
    } else {
        return _componentWidth;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == PickerTypeNormal) {
        return [_dispalyNamesArray objectAtIndex:row];
    }
    return nil;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    if (pickerView.tag == PickerTypeCustomDate) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 130, 40)];
        if (component == 0) {
            label.text = [NSString stringWithFormat:@"%d", row];
        }else{
            label.text = [NSString stringWithFormat:@"%d", row];
        }
        label.font = [UIFont boldSystemFontOfSize:20];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentLeft;
        return label;
        
    } else {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _componentWidth - 15, 40)];
        label.text = [_dispalyNamesArray objectAtIndex:row];
        label.font = [UIFont boldSystemFontOfSize:15];
        label.minimumScaleFactor = 5;
        label.adjustsFontSizeToFitWidth = YES;
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentRight;
        return label;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == PickerTypeCustomDate) {
        if (component == 0) {
            self.currentSelectedMin = row;
        } else {
            self.currentSelectedSec = row;
        }
    } else {
        self.currentSelectedRow = row;
    }
}

#pragma Button Action

- (void)okBtnAction:(id)sender {
    if (_okButtonPressedBlock) {
        UIBarButtonItem *okButtonItem = (UIBarButtonItem *)sender;
        if (okButtonItem.tag == PickerTypeDate) {
            _okButtonPressedBlock([_datePicker date]);
        } else if (okButtonItem.tag == PickerTypeCustomDate) {
            NSString *shi = [[NSString alloc]init];
            NSString *fen = [[NSString alloc]init];
            if (_currentSelectedMin<10) {
                shi = [NSString stringWithFormat:@"0%ld",_currentSelectedMin];
            }else{
                shi = [NSString stringWithFormat:@"%ld",_currentSelectedMin];

            }
            if (_currentSelectedSec<10) {
                fen = [NSString stringWithFormat:@"0%ld",_currentSelectedSec];
            }else {
                fen = [NSString stringWithFormat:@"%ld",_currentSelectedSec];
            }
            NSString *result = [NSString stringWithFormat:@"%@%@",shi,fen];
            _okButtonPressedBlock(result);
        } else {
            _okButtonPressedBlock([_retValuesArray objectAtIndex:_currentSelectedRow]);
        }
    }
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)cancelBtnAction {
    [self dismissWithClickedButtonIndex:0 animated:YES];
}

@end

#pragma mark - CustomPicker

@implementation CustomPicker

#pragma mark - Picker View

+ (void)showPickWithDelegate:(id)delegate
               selectedValue:(id)value
                contentPlist:(NSDictionary *)dic
             okButtonPressed:(okButtonPressed_t)buttonBlock {
    
    [CustomPicker showPickWithDelegate:delegate
                         selectedValue:value
                          dispalyNames:[dic objectForKey:@"DisplayName"]
                             retValues:[dic objectForKey:@"ReturnValue"]
                       okButtonPressed:buttonBlock];
}

+ (void)showPickWithDelegate:(id)delegate
               selectedValue:(id)value
                dispalyNames:(NSArray *)nameArray
                   retValues:(NSArray *)valuesArray
             okButtonPressed:(okButtonPressed_t)buttonBlock {
    
    [CustomPicker showPickWithDelegate:delegate
                        componentWidth:300
                         selectedValue:value
                          dispalyNames:nameArray
                             retValues:valuesArray
                       okButtonPressed:buttonBlock];
    
}

+ (void)showPickWithDelegate:(id)delegate
              componentWidth:(CGFloat)width
               selectedValue:(id)value
                dispalyNames:(NSArray *)nameArray
                   retValues:(NSArray *)valuesArray
             okButtonPressed:(okButtonPressed_t)buttonBlock {
    
    if (nameArray.count ==0 || nameArray.count != valuesArray.count) {
        [NSException raise:@"Invalid nameArray and valuesArray" format: @"nameArray.count is not equal valuesArray.count!"];
    }
    
    CustomPickerView *customPickerView = [[CustomPickerView alloc]initWithcomponentWidth:width
                                                                    currentSelectedValue:value
                                                                            dispalyNames:nameArray
                                                                               retValues:valuesArray];
    [customPickerView showCustomPickView:delegate okButtonPressedBlock:buttonBlock];
    
}

#pragma mark - Date Picker

+ (void)showDatePickWithDelegate:(id)delegate selectedDate:(NSDate *)date okButtonPressed:(okButtonPressed_t)buttonBlock {
    CustomPickerView *customPickerView = [[CustomPickerView alloc]initDatePickerWithCurrentSelectedDate:date];
    [customPickerView showCustomPickView:delegate okButtonPressedBlock:buttonBlock];
}

+ (void)showMinSecDatePickWithDelegate:(id)delegate selectedDate:(NSInteger)sec okButtonPressed:(okButtonPressed_t)buttonBlock {
    CustomPickerView *customPickerView = [[CustomPickerView alloc]initMinSecDatePickerWithCurrentSelectedDate:sec];
    [customPickerView showCustomPickView:delegate okButtonPressedBlock:buttonBlock];
}

@end
