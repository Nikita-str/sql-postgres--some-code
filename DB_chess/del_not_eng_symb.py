f = open("alice_in_wonderland_.txt", "w");
for c in open('alice_in_wonderland.txt').read():
    if(c =='\n' or c==' ' or ('a'<=c and c<='z')or('A'<=c and c<='Z')):
        f.write(c)
f.close()
