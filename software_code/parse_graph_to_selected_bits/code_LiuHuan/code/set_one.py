import os, re

# 无法处理fixed格式的。需要先将fixed转化


def set_one(path_2):

    checkmap={}
    with open(os.path.join(path_2, 'next_header_out.txt'),'r') as fn:
        for line in fn:
            vdic = {}
            k, v_raw = line.split(' : ')
            vlist = re.findall(r'\((.+?)\)\-\>(\S+)\,',v_raw)
            for item in vlist:
                vdic[item[1]]=item[0]
            checkmap[k]=vdic
    # for i in checkmap.items():
    #     print(i)

    with open(os.path.join(path_2, 'graph_out.txt'),'r') as fg:
        rdg = fg.readlines()
    with open(os.path.join(path_2, 'output.txt'),'r') as fo:
        rdo = fo.readlines()
    if len(rdg) != len(rdo):
        print('wrong file lines number')

    def change(a,b):
        ones=0
        for c in a:
            if c=='1':
                ones+=1
        new='{0:0>{wid}}'.format(b,wid=ones)
        # print(new)
        rr = ''
        for c in a:
            if c=='1':
                rr+=new[0]
                new=new[1:]
            else:
                rr+='x'
        # print(new)
        # print(a,b,rr)
        return rr

    with open(os.path.join(path_2, 'setone_output.txt'),'w') as fw, open(os.path.join(path_2, 'setone_graph_out.txt'),'w') as fw2:
        for i in range(len(rdg)):
            skip = rdg[i][:-1].split('->')
            rdo_list=rdo[i][:-2].split(' ')
            # print(rdo_list)
            prewrite_list=['']
            base=1
            for j in range(len(skip)-1):
                getskip=checkmap[skip[j]][skip[j+1].split('(')[0]].split(', ')
                getskip_ch=[]
                for k in getskip:
                    if '0x' in k:
                        getskip_ch.append(bin(int(k,16))[2:])
                    elif 'b' in k:
                        getskip_ch.append(bin(int('0'+k,2))[2:])
                    else:
                        getskip_ch.append(bin(int(k,10))[2:])

                prewrite_list=prewrite_list*len(getskip_ch)
                for z in range(len(prewrite_list)):
                    # prewrite_list[z]+=change(rdo_list[j],getskip_ch[z%len(getskip_ch)])
                    prewrite_list[z]+=change(rdo_list[j],getskip_ch[z//base])
                base *= len(getskip_ch)
            for z in range(len(prewrite_list)):
                prewrite_list[z]+=rdo_list[-1].replace('0','x')

            for item in prewrite_list:
                fw.write(item+'\n')
                fw2.write(rdg[i])


                # print(getskip,getskip_ch)

if __name__ == '__main__':

    path_2 = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing'
    
    set_one(path_2)
