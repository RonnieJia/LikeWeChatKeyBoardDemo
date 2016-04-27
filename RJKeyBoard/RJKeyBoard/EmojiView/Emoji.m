#import "Emoji.h"

@implementation Emoji
+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}
+ (NSArray *)allEmoji {
    NSMutableArray *array = [NSMutableArray new];
    NSMutableArray * localAry = [[NSMutableArray alloc] initWithObjects:
                                 [self emojiWithCode:0x1F60a],
                                 [self emojiWithCode:0x1F603],
                                 [self emojiWithCode:0x1F609],
                                 [self emojiWithCode:0x1F62e],
                                 [self emojiWithCode:0x1F60b],
                                 [self emojiWithCode:0x1F60e],
                                 [self emojiWithCode:0x1F621],
                                 [self emojiWithCode:0x1F616],
                                 [self emojiWithCode:0x1F633],
                                 [self emojiWithCode:0x1F61e],
                                 [self emojiWithCode:0x1F62d],
                                 [self emojiWithCode:0x1F610],
                                 [self emojiWithCode:0x1F607],
                                 [self emojiWithCode:0x1F62c],
                                 [self emojiWithCode:0x1F606],
                                 [self emojiWithCode:0x1F631],
                                 [self emojiWithCode:0x1F385],
                                 [self emojiWithCode:0x1F634],
                                 [self emojiWithCode:0x1F615],
                                 [self emojiWithCode:0x1F637],
                                 [self emojiWithCode:0x1F62f],
                                 [self emojiWithCode:0x1F60f],
                                 [self emojiWithCode:0x1F611],
                                 [self emojiWithCode:0x1F496],
                                 [self emojiWithCode:0x1F494],
                                 [self emojiWithCode:0x1F319],
                                 [self emojiWithCode:0x1f31f],
                                 [self emojiWithCode:0x1f31e],
                                 [self emojiWithCode:0x1F308],
                                 [self emojiWithCode:0x1F60d],
                                 [self emojiWithCode:0x1F61a],
                                 [self emojiWithCode:0x1F48b],
                                 [self emojiWithCode:0x1F339],
                                 [self emojiWithCode:0x1F342],
                                 [self emojiWithCode:0x1F44d],
                                 [self emojiWithCode:0x1F602],
                                 [self emojiWithCode:0x1F603],
                                 [self emojiWithCode:0x1F604],
                                 [self emojiWithCode:0x1F609],
                                 [self emojiWithCode:0x1F613],
                                 [self emojiWithCode:0x1F614],
                                 [self emojiWithCode:0x1F616],
                                 [self emojiWithCode:0x1F618],
                                 [self emojiWithCode:0x1F61a],
                                 [self emojiWithCode:0x1F61c],
                                 [self emojiWithCode:0x1F61d],
                                 [self emojiWithCode:0x1F61e],
                                 [self emojiWithCode:0x1F620],
                                 [self emojiWithCode:0x1F621],
                                 [self emojiWithCode:0x1F622],
                                 [self emojiWithCode:0x1F623],
                                 [self emojiWithCode:0x1F628],
                                 [self emojiWithCode:0x1F62a],
                                 [self emojiWithCode:0x1F62d],
                                 [self emojiWithCode:0x1F630],
                                 [self emojiWithCode:0x1F631],
                                 [self emojiWithCode:0x1F632],
                                 [self emojiWithCode:0x1F633],
                                 [self emojiWithCode:0x1F645],
                                 [self emojiWithCode:0x1F646],
                                 [self emojiWithCode:0x1F647],
                                 [self emojiWithCode:0x1F64c],
                                 [self emojiWithCode:0x1F6a5],
                                 [self emojiWithCode:0x1F6a7],
                                 [self emojiWithCode:0x1F6b2],
                                 [self emojiWithCode:0x1F6b6],
                                 [self emojiWithCode:0x1F302],
                                 [self emojiWithCode:0x1F319],
                                 [self emojiWithCode:0x1F31f],
                                 nil];

    
    [array addObjectsFromArray:localAry];
    return array;
}
@end
