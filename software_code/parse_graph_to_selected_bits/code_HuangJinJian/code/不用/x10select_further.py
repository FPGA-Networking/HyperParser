import os, math, itertools

def x10select_further(path):

    def comb(items, n=None):
        '''
        Created on 2013-4-16
        @author: shatangju
        '''
        if n is None:
            n = len(items)
        for i in range(len(items)):
            v = items[i:i+1]
            if n == 1:
                yield v
                # yield []
            else:
                rest = items[i+1:]
                for c in comb(rest, n-1):
                    yield v+c
                    # yield c

    def matching(a,b):
        if len(a) != len(b):
            return 0
        for i in range(len(a)):
            if a[i]=='x' or b[i]=='x':
                continue
            elif a[i]!=b[i]:
                return 0
        return 1

    rd=[]
    with open(os.path.join(path, 'x10select_pre_output.txt'),'r') as fr:
        for i in fr:
            rd.append(i[:-1])

    need_min=math.ceil(math.log(len(rd), 2)) # 向上取整
    # need_min=len(rd[0])-1

    items = [i for i in range(len(rd[0]))]
    # print(items)
    temp_li=[i for i in range(len(rd))]
    search_line=[every2 for every2 in comb(temp_li,2)]

    # print(search_line)

    top_score=len(search_line)
    # print(top_score)
    # print(search_line)
    times=0
    for num in range(need_min,len(rd[0])+1):
        # print('column now: '+str(num))
        for combination in comb(items,num):
            if times%10000==0:
                print('column now: '+str(num)+'  trying times now: '+str(times))
            times+=1
            short_li=[]
            score=0
            for line in rd:
                short=''
                for i in combination:
                    short+=line[i]
                short_li.append(short)
            for every2 in search_line:
                if matching(short_li[every2[0]],short_li[every2[1]]):
                    break
                else:
                    score+=1
            if score==top_score:
                finding=combination
                print('find it now, trying times is '+str(times))
                break
        if score==top_score:
            break

    # with open(os.path.join(path, 'x10select_further_output.txt'),'w') as fw:
    with open(os.path.join(path, 'x10select_pre_output.txt'),'w') as fw:
        for line in rd:
            for i in finding:
                fw.write(line[i])
            fw.write('\n')
    # with open(os.path.join(path, 'x10select_info.txt'),'r') as fr, open(os.path.join(path, 'x10select_further_info.txt'),'w') as fw:
    #     fw.write(fr.readline())
    #     li=fr.readline().split(', ')
    #     liw=[]
    #     for i in finding:
    #         liw.append(li[i])
    #     fw.write(', '.join(liw))
    with open(os.path.join(path, 'x10select_pre_info.txt'),'r') as fr:
        li1=fr.readline()
        li2=fr.readline()
    with open(os.path.join(path, 'x10select_pre_info.txt'),'w') as fw:
        fw.write(li1)
        li=li2.split(', ')
        liw=[]
        for i in finding:
            liw.append(li[i])
        fw.write(', '.join(liw))
    print('finish')

if __name__ == '__main__':

    path = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing'

    x10select_further(path)
