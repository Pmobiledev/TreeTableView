
#import <Foundation/Foundation.h>

@interface TreeItem : NSObject

@property (nonatomic, strong) NSString *base, *path;
@property (nonatomic) NSInteger numberOfSubitems;
@property (nonatomic, strong) TreeItem *parentSelectingItem;
@property (nonatomic, strong) NSMutableArray *ancestorSelectingItems;
@property (nonatomic) NSInteger submersionLevel;
@property (nonatomic, assign) BOOL isOpened;

- (BOOL)isEqualToSelectingItem:(TreeItem *)selectingItem;

@end
