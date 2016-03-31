//
//  ViewController.m
//  01-coreData 的简单使用
//
//  Created by solong on 15/4/11.
//  Copyright (c) 2015年 YZ. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>
#import "Employee.h"

@interface ViewController ()
@property (nonatomic,strong) NSManagedObjectContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //创建模型文件    相当于一个数据库的表
    //添加实体   一张表
    //创建实体类   相当于模型
    
    //获取上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    //上下文关联数据库
    //model 模型文件  bundles为空时会自动关联bundle里的模型文件
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    //持久化存储调度器
    NSPersistentStoreCoordinator *store = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    //告诉CoreData数据库的名字和路径
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"Company.sqlite"];
    
    NSLog(@"%@",sqlitePath);
    [store addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL fileURLWithPath:sqlitePath] options:nil error:nil];
    context.persistentStoreCoordinator = store;
    
    _context = context;
}
#pragma mark - 添加员工
- (IBAction)addEmployee:(id)sender {
    Employee *employee = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:_context];
    employee.name = @"wangwu";
    employee.height = @1.75;
    employee.birthday = [NSDate date];
    
    NSError *error = nil;
    [_context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}
#pragma mark - 读取员工
- (IBAction)readEmployee:(id)sender {
    //抓取请求对象
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
//    //设置过滤条件
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"zhangsan"];
//    request.predicate = predicate;
    //按身高升序排序
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"height" ascending:YES];
    request.sortDescriptors = @[sortDescriptor];
    //执行请求
    NSError *error = nil;
    NSArray *employees = [_context executeFetchRequest:request error:&error];
    for (Employee *employee in employees) {
        NSLog(@"name:%@ height:%@ birthday:%@",employee.name,employee.height,employee.birthday);
    }
}
#pragma mark - 更新员工
- (IBAction)updateEmployee:(id)sender {
    //更新张三的身高为1.9
    
    //读取张三
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@",@"zhangsan"];
    request.predicate = predicate;
    NSError *error = nil;
    NSArray *employees = [_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    
    //更新身高
    for (Employee *employee in employees) {
        employee.height = @1.9;
    }
    
    //保存请求
    [_context save:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}
#pragma mark - 删除员工
- (IBAction)deleteEmployee:(id)sender {
    //删除 lisi
    
    //查找lisi
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Employee"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@",@"lisi"];
    NSError *error = nil;
    NSArray *employees =[_context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    //删除
    for (Employee *employee in employees) {
        [_context deleteObject:employee];
    }
    //保存
    [_context save:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
