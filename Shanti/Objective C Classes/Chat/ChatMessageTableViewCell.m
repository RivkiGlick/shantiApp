//
//  ChatMessageTableViewCell.m
//  sample-chat
//
//  Created by Igor Khomenko on 10/19/13.
//  Copyright (c) 2013 Igor Khomenko. All rights reserved.
//

#import "ChatMessageTableViewCell.h"
#import "Shanti-swift.h"
#define padding 20

@implementation ChatMessageTableViewCell

static NSDateFormatter *messageDateFormatter;
static UIImage *orangeBubble;
static UIImage *aquaBubble;

+ (void)initialize{
    [super initialize];
    
    // init message datetime formatter
    messageDateFormatter = [[NSDateFormatter alloc] init];
    [messageDateFormatter setDateFormat: @"dd/MM/yyyy HH:mm"];
    [messageDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    
    // init bubbles
    orangeBubble = [[UIImage imageNamed:@"pinkBuble"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
    aquaBubble = [[UIImage imageNamed:@"whiteBuble"] stretchableImageWithLeftCapWidth:500  topCapHeight:15];
  }

+ (CGFloat)heightForCellWithMessage:(QBChatAbstractMessage *)message
{
    NSString *text = message.text;

    CGSize  textSize = {260.0, 10000.0};
//	CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:13]
//                   constrainedToSize:textSize
//                       lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size = [ChatMessageTableViewCell frameForText:text sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
	size.height += 45.0;
	return size.height;

}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.dateLabel = [[UILabel alloc] init];
        [self.dateLabel setFrame:CGRectMake(10, 5, 300, 20)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:11.0]];
        [self.dateLabel setTextColor:[UIColor grayMedium]];
        [self.contentView addSubview:self.dateLabel];
        
        self.backgroundImageView = [[UIImageView alloc] init];
        [self.backgroundImageView setFrame:CGRectZero];
		[self.contentView addSubview:self.backgroundImageView];
        
		self.messageTextView = [[UITextView alloc] init];
        self.messageTextView.textAlignment = NSTextAlignmentRight;
        [self.messageTextView setBackgroundColor:[UIColor clearColor]];
        [self.messageTextView setEditable:NO];
        [self.messageTextView setScrollEnabled:NO];
		[self.messageTextView sizeToFit];
		[self.contentView addSubview:self.messageTextView];
        
        self.userImageView = [[UIImageView alloc]init];
        [self.userImageView setFrame:CGRectZero];
        [self.contentView addSubview:self.userImageView];
    }
    return self;
}

- (void)configureCellWithMessage:(QBChatAbstractMessage *)message
{
    CGFloat userImageSize = 29;
    self.messageTextView.text = message.text;
    
    
    CGSize textSize = { 260.0, 10000.0 };
    
//	CGSize size = [self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13]
//                                        constrainedToSize:textSize
//                                            lineBreakMode:NSLineBreakByWordWrapping];
    
    CGSize size = [ChatMessageTableViewCell frameForText:self.messageTextView.text sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:NSLineBreakByWordWrapping];
    
	size.width += 10;
    
    NSString *time = [messageDateFormatter stringFromDate:message.datetime];
    
    // Left/Right bubble
    if ([ActiveUser sharedInstace].oUserQuickBlox.ID == message.senderID) {
        [self.userImageView setFrame:CGRectMake(padding/2, padding+5, userImageSize,userImageSize)];
        
        [self.messageTextView setFrame:CGRectMake(self.userImageView.frame.size.width + padding/2, padding+5, size.width, size.height+padding)];
        [self.messageTextView sizeToFit];
        
        [self.backgroundImageView setFrame:CGRectMake(self.userImageView.frame.size.width + padding/2, padding+5,
                                                      self.messageTextView.frame.size.width+padding/2, self.messageTextView.frame.size.height+5)];
        self.backgroundImageView.image = aquaBubble;
        
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.text = [NSString stringWithFormat:@"%@, %@", [[ActiveUser sharedInstace]nvEmail], time];
        
    } else {
        [self.userImageView setFrame:CGRectZero];
        [self.userImageView setFrame:CGRectMake(_tableViewWidth - userImageSize - padding/2, padding+5, userImageSize,userImageSize)];
        [self.messageTextView setFrame:CGRectMake(self.userImageView.frame.origin.x - size.width -padding/2 , padding+5, size.width, size.height+padding)];
        [self.messageTextView sizeToFit];
        
        [self.backgroundImageView setFrame:CGRectMake(self.userImageView.frame.origin.x - self.messageTextView.frame.size.width-padding, padding+5,self.messageTextView.frame.size.width+padding, self.messageTextView.frame.size.height+5)];
        self.backgroundImageView.image = orangeBubble;
        
        self.dateLabel.textAlignment = NSTextAlignmentRight;
        self.dateLabel.text = [NSString stringWithFormat:@"%lu, %@", (unsigned long)message.senderID, time];
    }
    
}

+(CGSize)frameForText:(NSString*)text sizeWithFont:(UIFont*)font constrainedToSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode  {
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = lineBreakMode;
    
    NSDictionary * attributes = @{NSFontAttributeName:font,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
    
    
    CGRect textRect = [text boundingRectWithSize:size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attributes
                                         context:nil];
    
    //Contains both width & height ... Needed: The height
    return textRect.size;

}

+(NSString*)getFontNameWithText:(NSString*)text{
    NSArray *tagschemes = [NSArray arrayWithObjects:NSLinguisticTagSchemeLanguage, nil];
     NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:tagschemes options:0];
     [tagger setString:text];
     NSString *language = [tagger tagAtIndex:0 scheme:NSLinguisticTagSchemeLanguage tokenRange:NULL sentenceRange:NULL];
    NSLog(@"language: %@",language);
    return language;
}
@end
