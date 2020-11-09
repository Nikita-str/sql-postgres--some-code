from random import randint as ri
from random import choice as ch
i_1 = 'forks, skewers, batteries, discovered attacks, undermining, overloading, deflection, pins, and interference';
i_1 = i_1.split(',')
i_2 = ' Double Attack, Pawns Breakthrough, Blockade, Decoying, Discovered Attack, Passed Pawn, X-ray Attack, Interception, Deflection, Pin, Demolition of Pawns, Overloading, Annihilation of Defense, Pursuit, Intermediate Move, and Space Clearance';
i_2 = i_2.split(',')


what_do_when_attacked_king = ['capture the attacking piece',
                              'move the king to a free square',
                              'interpose another piece in between the two']

when_not_a_king = [
'capture the attacking piece',
'move the attacked piece to a free or covered square',
'move the attacked piece to a different attacked square',
'interpose another piece in between the two',
'cover the attacked piece, permitting an exchange',
'pin the attacking piece so the capture becomes illegal',
'pin the attacking piece so the capture becomes unprofitavle',
'pin the attacking piece so the capture becomes less damaging',
'capture a different piece of the opponent',
'allow the piece attacked to be captured',
'employ a zwischenzug']

i_1_and_2_word = ['master of', 'often use', 'well managed with', 'really good in', 'his tactic is']

dop_word = ['unusual style', 'his own style']

f = open('important_info.txt', 'w')
for l1 in i_1:
    f.write(ch(i_1_and_2_word)+' ')
    f.write(l1)
    f.write(' but think ')
    f.write(ch(dop_word))
    f.write('\n')
for l2 in i_2:
    f.write(ch(i_1_and_2_word)+' ')
    f.write(l2)
    f.write(' but mostly ')
    f.write(ch(dop_word))
    f.write('\n')
for nk in when_not_a_king:
    f.write('he really often use ')
    f.write(nk)
    f.write(' its all')
    f.write('\n')
f.close()
f = open('important_info_big.txt', 'w')
for l1 in i_1:
    for l2 in i_2:
        for ak in what_do_when_attacked_king:
            for nk in when_not_a_king:
                f.write(ch(i_1_and_2_word)+' ')
                f.write(l1)
                f.write(' and he use ')
                f.write(l2)
                f.write(' when defending king, he prefers ')
                f.write(ak)
                f.write(' and when defending but not king, he use ')
                f.write(nk)
                if(ri(0,25) == 1):
                    f.write(' but his style ')
                    f.write(ch(dop_word))
                f.write('\n')
f.close()


