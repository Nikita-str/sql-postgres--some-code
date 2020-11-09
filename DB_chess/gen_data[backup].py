from random import randint as ri
from random import choice as ch

#import json


year_from = 1995;
year_to = 2020;

def tour_year_coef(year):
    if(year < year_from): return 0;
    if(year == year_from): return 1;
    coef = year/year_from;
    coef = (coef - 1) * 270 + coef;
    if(year > 2001):#communication up
        coef += 2.3;
        if(year > 2012):#internet up-up  :|  and so on
            coef *= 2.1
    return coef



def get_date_str(year, ind, max_ind):
    day = int((ind/max_ind) * 335);
    return str((day%28)+1)+'/'+str(int(day/28)+1)+'/'+str(year)
def get_date_str(date):
    return str(date[0])+'/'+str(date[1])+'/'+str(date[2])
def get_date(year, ind, max_ind):
    day = int((ind/max_ind) * 335);
    return [(day%28)+1, (int(day/28)+1), year]
def get_date_end(date, day_len):
    d = date[0] + day_len;
    m = date[1]
    y = date[2]
    if(d > 28):
        m = m + (d // 28)
        if(m > 12):
            y = y + 1;
            m = m % 12
            if(m == 0): m = 1
        d = d % 28
        if(d == 0): d = 1
    return [d, m, y]


tours_1995_amount = 35;
tours_amount = 0;

tour_date = [];

for year in range(year_from, year_to):
    add_tour = int(tours_1995_amount * tour_year_coef(year));
    tours_amount = tours_amount + add_tour;
    for i in range(1, add_tour + 1):
        tour_date += [get_date(year, i, add_tour)]


aiw_0 = open("alice_in_wonderland.txt").read().split('\n')
aiw = []
for lline in aiw_0:
    for line in lline.split(';'):
        line = line.strip();
        if(len(line) > 7):aiw += [line]
imp_info = open('important_info.txt').read().split('\n')
impb_info = open('important_info_big.txt').read().split('\n')

def gen_about():
    z = ''
    if(ri(0, 10) == 1): z = ch(impb_info)
    else : z = ch(imp_info)
    return ch(aiw) +' ' + z + ' ' + ch(aiw)
        
class Player:
    def __init__(self, tours):
        global tours_amount, tour_date
        self.tours = tours
        self.tours_ind = set()
        while(len(self.tours_ind) < self.tours):
            self.tours_ind.add(ri(0, tours_amount - 1))
        self.rating_dates = []
        self.rating = []
        rat_zero = ri(1200, 1500);
        for i in self.tours_ind:
            self.rating_dates += [get_date_end(tour_date[i], 12)]
            rat_zero = rat_zero + ri(-10, 10);
            if(rat_zero < 700): rat_zero = 700;
            self.rating += [rat_zero]
    def add_info(self, f_name, s_name, b_date):
        self.info = '{"first_name":"'+ f_name + '","second_name":"'+s_name + '","birthday":"'+ get_date_str(b_date)+'"}'; 
    def get_strable_arr(self):
        dt = '{'
        rt = '{'
        for i in range(0, self.tours):
            dt += get_date_str(self.rating_dates[i])
            rt += str(self.rating[i])
            if(i != self.tours - 1): dt +=','; rt+=',';
            else: dt+='};'; rt+='};'
        return dt + rt + gen_about()+ ';' + self.info

names = open("names.txt").read().split()
surnames = open("surnames.txt").read().split()
b_dates = [[12, 12, 1980], [11, 11, 1973], [5, 6, 1982], [1, 2, 1980] ]
players = [];
players_amount = 1_000_1#_001  # TODO
for i in range(0, players_amount):
    pl = Player(ri(5, 30));
    pl.add_info(ch(names), ch(surnames), ch(b_dates));
    players += [pl];


print('PLAYER_STATS');

f = open("pl_stat#"+str(players_amount-1)+".txt", "w");
for i in range(0, players_amount):
    f.write(str(i+1)+';');
    f.write(players[i].get_strable_arr());
    f.write('\n');
f.close();


o_names = open("o_names.txt").read().split('\n')
o_sites = open("o_sites.txt").read().split('\n')

def gen_tour_name(date):
    prefix = ["WORLD CUP", "CHESS TOUR", "CLASSIC CHESS", "CHESS CUP", 'CHESS WORLD CUP'];
    m = ["TITAN", "WOW", "LEGEND", "SUDDEN", "NEW", "GOOD OLD", "MASTERS", "USUAL", "NOT USUAL", "ANOTHER", "IDEAL", "FIRST"]
    z = date[0] - 1;
    if( z > 25): z = ord('A') + z - 25;
    else: z = ord('a') + z;
    postfix = chr(ord('A')+ri(0,25))+ chr(z)+chr(ord('A')+ri(0,25)) 
    s = ""
    return m[date[1]%12] + ' '+ch(prefix) +' '+ str(date[2]) + ' ' + postfix;


print('TOUR_STATS');

# TOUR_STATS:
f = open("tr_stat.txt", "w");
for i in range(0, tours_amount):
    f.write(str(i+1)+";");
    f.write(gen_tour_name(tour_date[i])+";");
    f.write(str(tour_date[i][2])+";");
    ind = ri(0, len(o_names) - 1);
    f.write('{"o_name":"'+o_names[ind]+'","site":"'+o_sites[ind]+'"}');
    f.write('\n');
f.close();

#exit()
print('GAME_STATS');

#  GAME_STATS:
valid_point = ['0', '1', '-1'];
game_amount = 1_000_01#TODO:100_000_000

# for speed up +
tour_id_when_pp = game_amount//(tours_amount-10) + 5;
tour_id = 1;
s_tour_id = ';'+str(tour_id)
tour_dt = get_date_str(get_date_end(tour_date[tour_id], 2))
s_tour = ';'+ tour_dt + s_tour_id
rat_1 = 1034;
rat_2 = 1273
valid_point_1 = ['{1};','{-1};']
valid_point_2 = ['{0, 1};','{0, -1};','{1, 1};','{-1, -1};']
valid_point_3 = ['{0, 0, 1};','{0, 0, -1};','{1,0, 1};','{-1,0,-1};','{-1,1,-1};','{1,-1,1};']
valid_time_1 = ['{00:03:23};', '{00:11:32};', '{00:07:56};', '{00:05:46};', '{00:12:04};']
valid_time_n = ['00:03:23', '00:11:32', '00:07:56', '00:05:46', '00:12:04', '00:04:17', '00:03:30', '00:08:42', '00:07:57', '00:13:02']
valid_view_1 = ['{57};','{1021};','{163};','{299};','{457};','{357};','{61};','{1219};','{297};','{605};','{1015};']
valid_view_n = ['357','61','1219','297','605','293','1015','57','1021','163','299','457','1137','814']
# for speed up -

f = open("gm_stat#"+str(game_amount - 1)+".txt", "w");
for i in range(1, game_amount):
    f.write(str(i)+";")
    gs = (((i*(i+1))%7)+i)%3 # for speed pp
    if(gs == 1):
        f.write(valid_point_1[i%2]);
        f.write(valid_time_1[i%5]);
        f.write(valid_view_1[i%11]);
    elif(gs == 2):
        f.write(valid_point_2[i%4]);
        f.write('{'+ch(valid_time_n)+','+ch(valid_time_n)+'};');
        f.write('{'+ch(valid_view_n)+','+ch(valid_view_n)+'};');
    else:
        f.write(valid_point_3[i%6]);
        f.write('{'+ch(valid_time_n)+','+ch(valid_time_n)+','+ch(valid_time_n)+'};');
        f.write('{'+ch(valid_view_n)+','+ch(valid_view_n)+','+ch(valid_view_n)+'};');
    p1 = ri(1, players_amount - 5);
    p2 = ri(p1 + 1, players_amount - 3);
    if((i%tour_id_when_pp) == 0):
        tour_id = tour_id + 1;
        s_tour_id = ';'+ str(tour_id)
        tour_dt = get_date_str(get_date_end(tour_date[tour_id], 2))
        s_tour = ';'+ tour_dt + s_tour_id
    rat_1 = (rat_1 - 900)%700 + 901
    rat_2 = (rat_2 -900)%700 + 901
    f.write(str(p1)+';'+str(p2)+';'+str(rat_1)+';'+str(rat_2) + s_tour);
    f.write('\n');
f.close();
