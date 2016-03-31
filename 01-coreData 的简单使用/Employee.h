//
//  Employee.h
//  01-coreData 的简单使用
//
//  Created by solong on 15/4/11.
//  Copyright (c) 2015年 YZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Employee : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSDate * birthday;

@end
