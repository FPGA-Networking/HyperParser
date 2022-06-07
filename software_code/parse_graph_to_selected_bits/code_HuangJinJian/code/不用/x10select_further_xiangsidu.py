import os,math

def x10select_further_xiangsidu(path):

    m1 = 0x5555555555555555
    m2 = 0x3333333333333333
    m3 = 0x0f0f0f0f0f0f0f0f
    m4 = 0x00ff00ff00ff00ff
    m5 = 0x0000ffff0000ffff
    m6 = 0x00000000ffffffff

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

    def count64s(a):
        o = (m1&a)|(m1&(a>>1)) # 算法特殊性，每2bit求或
        o = (m2&o)+(m2&(o>>2))
        o = (m3&o)+(m3&(o>>4))
        o = (m4&o)+(m4&(o>>8))
        o = (m5&o)+(m5&(o>>16))
        o = (m6&o)+(m6&(o>>32))
        return o

    def compute_similarity(a,b):
        c=a&b
        count = 0
        # print(bin(a),bin(b),c)
        while c!=0:
            count+=count64s(c)
            # print(c)
            c=c>>64
        return count

    def change01(a):
        return int(a.replace('1','2').replace('0','1').replace('x','3'),4)

    def matching(combination):
        # print(combination)
        return len(combination[0])==compute_similarity(change01(combination[0]),change01(combination[1]))

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

    def judge_meet(li): # 给的参数是选出的列的列表
        no_x=[i for i in li if 'x' not in i]
        con_x=[i for i in li if 'x' in i]
        no_xt = [int(''.join(i),2) for i in map(list,zip(*no_x))]
        con_xt = [''.join(i) for i in map(list,zip(*con_x))]
        x_dic={}
        if con_xt != []: # 含有x
            # print(len(no_xt))
            if no_xt != []: # 说明有的列没有x
                for i in range(len(no_xt)):
                    x_dic.setdefault(no_xt[i], []).append(con_xt[i])
            else: # 说明所有列都有x
                x_dic[0]=con_xt
        else: # 说明没有x
            if len(no_xt) != len(set(no_xt)): # 说明有重复
                return False
            else: # 说明无重复
                return True
        # print(x_dic[0])
        x_dic2={k:v for k,v in x_dic.items() if len(v)>1} # 含有x，第一次筛选，去除组里只有一项的
        if len(x_dic2)==0:
            return True
        for k,v in x_dic2.items(): # 第二次筛选，分的组里面是否有完全重复项，有则判失败
            if len(v)!=len(set(v)):
                return False
        for k,v in x_dic2.items(): # 第三次筛选，对每一组进行两两匹配
            for combination in comb(v,2):
                if matching(combination): # 当前组当前组合有相同的
                    return False
        return True # 通过第三次筛查，说明每一组两两都不匹配，通过

    with open(os.path.join(path, 'x10select_pre_output.txt'),'r') as fr:
        rd = [i[:-1] for i in fr]
    rdti = [''.join(i) for i in map(list,zip(*rd))]
    rdt = [change01(rdti[i]) for i in range(len(rdti))]

    similarity={}
    temp_li=[i for i in range(len(rdt))]
    for every2 in comb(temp_li,2):
        similarity[tuple(every2)]=compute_similarity(rdt[every2[0]],rdt[every2[1]])

    similar_dic={}
    for item in similarity.items():
        similar_dic[item[0][0]] = similar_dic.get(item[0][0], 0) + item[1]
        similar_dic[item[0][1]] = similar_dic.get(item[0][1], 0) + item[1]

    similar_dic=sorted(similar_dic.items(),key=lambda x:x[1],reverse=False)
    print(rdti)
    print(similar_dic)
    rdtit=[rdti[i[0]] for i in similar_dic]
    print(rdtit)
    need_min=math.ceil(math.log(len(rd), 2)) # 向上取整
    for num in range(need_min,len(rd[0])+1):
        if judge_meet(rdtit[:num]):
            break

    print(num)
    print(rdtit[:num])


if __name__ == '__main__':

    path = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing'

    x10select_further_xiangsidu(path)

