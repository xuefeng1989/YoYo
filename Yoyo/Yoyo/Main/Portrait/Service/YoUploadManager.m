//
//  YoUploadManager.m
//  Yoyo
//
//  Created by yunxin bai on 2019/6/29.
//  Copyright © 2019 dhlg. All rights reserved.
//

#import "YoUploadManager.h"
#import <AFNetworking.h>
#import "Const.h"

@implementation YoUploadManager

+ (void)uploadWithFile:(NSArray *)files sueecss:(YoUploadManagerSuccess)success failure:(YoUploadManagerError)errorString {
 
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *request = [AFJSONRequestSerializer serializer];
    [request setValue:@"BillClient eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIyMDE5MDYyNjIzMzg0NTkxMzQxNDIwNiIsInN1YiI6IiIsImlhdCI6MTU2MjI1NzI1MiwiaXNzIjoia2FycCIsImF1ZCI6IiIsImV4cCI6MTU2MzAwODIzM30.Y9Tw6Xp3oV9OgiDWuIEOXvXlHh26CKACN01QsFGf45A" forHTTPHeaderField:@"Authorization"];
    manager.requestSerializer = request;
    
    [manager POST:UploadRootBaseURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (UIImage *image in files) {
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
            NSData *data = UIImageJPEGRepresentation(image, 0.2);
            [formData appendPartWithFileData:data name:@"files" fileName:fileName mimeType:@"image/jpg"];
        }

        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        JSLogInfo(@"%@",responseObject);
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        JSLogInfo(@"%@",error);
        if (errorString) {
            errorString(error.description);
        }
        
    }];
    
}

+(void)uploadWithFile:(NSArray *)files {
    
    
//    @"Authorization": @"BillClient eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIyMDE5MDYxNjE4MzcwMzAzMDk2OTUwOSIsInN1YiI6IiIsImlhdCI6MTU2MTc0NDA0NywiaXNzIjoiYm5uMSIsImF1ZCI6IiIsImV4cCI6MTU2MjQ5NTAyOH0.iP3-HerTqO-zMMNRcCt6-Xi1xp9B7WP9OvTJqo5mhtE",

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFJSONRequestSerializer *request = [AFJSONRequestSerializer serializer];
    [request setValue:@"BillClient eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiIyMDE5MDYxNjE4MzcwMzAzMDk2OTUwOSIsInN1YiI6IiIsImlhdCI6MTU2MTQ1NDA1MSwiaXNzIjoiYm5uMSIsImF1ZCI6IiIsImV4cCI6MTU2MjIwNTAzMn0.cyb25_4rYthy1Ghnv0EgGnxZm42Q0nQSrszQO4wNy0Y" forHTTPHeaderField:@"Authorization"];
    manager.requestSerializer = request;
    
    [manager POST:UploadRootBaseURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        
        UIImage *image = files.firstObject;
        NSData *data = UIImageJPEGRepresentation(image, 0.2);
//        [formData appendPartWithFormData:data name:@"file"];
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"file" mimeType:@"image/jpg"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        JSLogInfo(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        JSLogInfo(@"%@",error);
    }];
}

@end
