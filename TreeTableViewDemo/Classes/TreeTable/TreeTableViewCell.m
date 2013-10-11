
#import "TreeTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TreeItem.h"

@implementation TreeTableViewCell

#define kHorizontalSpace    30
#define kTitleXPos          35

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
		
		[self setSelectionStyle:UITableViewCellSelectionStyleNone];

		//Set the Arraow Button
		_arrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
		[self.arrowButton setFrame:CGRectMake(10, 7, 30, 30)];
		[self.arrowButton setAdjustsImageWhenHighlighted:NO];
		[self.arrowButton addTarget:self action:@selector(arrowButtonAction:) forControlEvents:UIControlEventTouchUpInside];
		[self.arrowButton setImage:[UIImage imageNamed:@"open_arrow.png"] forState:UIControlStateNormal];
		[self.contentView addSubview:self.arrowButton];
		
        //Set the Title
		_titleLabel = [[UILabel alloc] init];
		[self.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:20.0f]];
		[self.titleLabel setBackgroundColor:[UIColor clearColor]];
		[self.titleLabel sizeToFit];
		[self.titleLabel setFrame:CGRectMake(kTitleXPos, 7, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
		[self.layer setMasksToBounds:YES];
        [self.contentView addSubview:self.titleLabel];
		
		//Set the Accessory Item Count View
		self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(686, 28, 47, 28)];
		[self.countLabel setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin];
		[self.countLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"item-counter"]]];
		[self.countLabel setTextAlignment:NSTextAlignmentCenter];
		[self.countLabel setLineBreakMode:NSLineBreakByTruncatingMiddle];
		[self.countLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
		[self.countLabel setTextColor:[UIColor colorWithRed:0.608 green:0.376 blue:0.251 alpha:1]];
		[self.countLabel setShadowColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.35]];
		[self.countLabel setShadowOffset:CGSizeMake(0, 1)];
		
		[self setAccessoryView:self.countLabel];
		[self.accessoryView setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin];
		
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setLevel:(NSInteger)level
{
	CGRect rect;
	
	rect = self.arrowButton.frame;
	rect.origin.x = kHorizontalSpace * level;
	self.arrowButton.frame = rect;
	
	rect = self.titleLabel.frame;
	rect.origin.x = kTitleXPos + kHorizontalSpace * level;
	self.titleLabel.frame = rect;
}

- (void)arrowButtonAction:(id)sender
{
    if ([self.treeItem numberOfSubitems])
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(treeTableViewCell:didTapIconWithTreeItem:)])
        {
            [self.delegate treeTableViewCell:(TreeTableViewCell *)self didTapIconWithTreeItem:(TreeItem *)self.treeItem];
        }
    }
}

@end
