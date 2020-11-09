orgs = 25;

f = open("o_names.txt", 'w')
for i in range(0, orgs):
    f.write('organizator ')
    f.write(chr(i+ord('A')))
    f.write('\n')
f.close()

f = open("o_sites.txt", 'w')
for i in range(0, orgs):
    f.write('imagination://org'+chr(i+ord('A'))+'.not_real.com/')
    f.write('\n')
f.close()
