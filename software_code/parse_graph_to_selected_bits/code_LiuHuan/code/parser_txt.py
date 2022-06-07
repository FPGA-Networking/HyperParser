import os, re

# BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) 
# sys.path.append(BASE_DIR)

def deal_option(option): #option=(length[0],max_length,optionbitwide,bitlength)
    oplen_list = [0]
    if option[0]!='':
        temp_op=re.match(r'\s*\S+\s*',option[0])
        temp_w=option[0][temp_op.end():]
        if temp_w[0]=='*':
            temp_w=temp_w[1:]
            wi = eval(temp_w)
        else:
            wi = 1 # 防止option的length仅是一串字母
        ti = int((option[1]-option[3])/wi)
        # print(ti)
        times = min(ti,2**option[2]) # 计算重复次数
        for i in range(times):
            oplen_list.append((i+1)*wi)
    return oplen_list

def parser4(cont, simple_format):
    temp_next_header = re.findall(r'next_header = map\((?:(\S+), )*(\S+)\) \{((?:.|\s)*?)\}',cont) # 识别map中1或2个
    # print(temp_next_header)
    if temp_next_header!=[]:
        next_map=[temp_next_header[0][0],temp_next_header[0][1]]
        next_header=re.findall(r':\s*(\S+\b)\s*,?',temp_next_header[0][2])
        next_header_full=re.findall(r'\s*(.+?)\s*:\s*(\S+\b)\s*,?',temp_next_header[0][2])
    else:
        next_map=['']
        next_header=['']
        next_header_full=['']
    # print(next_header_full)

    temp_fields = ''.join(re.findall(r'fields \{((?:.|\s)*?)\}',cont))
    if 'options : *' in temp_fields:
        length = re.findall(r'\slength\s*=\s*(.+)',cont)
        max_length = int(re.findall(r'max_length\s*=\s*(\d+)',cont)[0])
    else:
        length = ['']
        max_length = 0

    fields = re.findall(r'(\S+)\s*:\s*(\d+)',temp_fields)
    bitmap = ''
    bitlength = 0
    optionbitwide = 0
    for cell in fields:
        bitlength+=int(cell[1])
        if cell[0] in next_map:
            if simple_format:
                bitmap += cell[1]+'|'
            else:
                bitmap += int(cell[1])*'1'
        else:
            if simple_format:
                bitmap += cell[1]+'o'
            else:
                bitmap += int(cell[1])*'0'
        if cell[0] in length[0]:
            optionbitwide = int(cell[1])
    temp_max = re.findall(r'max\s*=\s*(\d+)',cont)
    if temp_max!=[]:
        times=int(temp_max[0])
    else:
        times=1
    option=deal_option((length[0],max_length,optionbitwide,bitlength))
    return next_header, times, bitmap, option, next_header_full

def parser3(save, simple_format):
    while save[0]=='\n':
        save = save[1:]
    temp = re.match(r'(\S+)\s*\{((?:.|\s)*)\}',save)
    if temp:
        vertex=temp.group(1)
        next_header, times, bitmap, option, next_header_full=parser4(temp.group(2), simple_format)
        # print(vertex,next_header)
        return (vertex,next_header,times,bitmap,option,next_header_full)
    else:
        return 0

def parser2(rd, simple_format):
    level = 0
    save = ''
    graph = {}
    bitmap = {}
    option = {}
    next_header_full = {}
    while rd:
        save+=rd[0]
        if rd[0] == '{':
            rd = rd[1:]
            level+=1
        elif rd[0] == '}':
            rd = rd[1:]
            level-=1
            if level == 0:
                pregraph = parser3(save, simple_format)
                save = ''
                if pregraph != 0:
                    if pregraph[2]!=1:
                        for i in range(pregraph[2]):
                            if i == pregraph[2]-1 and pregraph[2]!=1:
                                graph[pregraph[0]+'({})'.format(i)]=[pregraph[1][k] for k in range(len(pregraph[1])) if pregraph[1][k]!=pregraph[0]]
                                bitmap[pregraph[0]+'({})'.format(i)]=pregraph[3]
                                option[pregraph[0]+'({})'.format(i)]=pregraph[4]
                                next_header_full[pregraph[0]+'({})'.format(i)]=pregraph[5]
                            elif i == 0:
                                temp_g=[]
                                for k in range(len(pregraph[1])):
                                    if pregraph[1][k]==pregraph[0]:
                                        temp_g.append(pregraph[1][k]+'({})'.format(i+1))
                                    else:
                                        temp_g.append(pregraph[1][k])
                                graph[pregraph[0]]=temp_g
                                bitmap[pregraph[0]]=pregraph[3]
                                option[pregraph[0]]=pregraph[4]
                                next_header_full[pregraph[0]]=pregraph[5]
                            else:
                                temp_g=[]
                                for k in range(len(pregraph[1])):
                                    if pregraph[1][k]==pregraph[0]:
                                        temp_g.append(pregraph[1][k]+'({})'.format(i+1))
                                    else:
                                        temp_g.append(pregraph[1][k])
                                graph[pregraph[0]+'({})'.format(i)]=temp_g
                                bitmap[pregraph[0]+'({})'.format(i)]=pregraph[3]
                                option[pregraph[0]+'({})'.format(i)]=pregraph[4]
                                next_header_full[pregraph[0]+'({})'.format(i)]=pregraph[5]
                    else:
                        graph[pregraph[0]]=pregraph[1]
                        bitmap[pregraph[0]]=pregraph[3]
                        option[pregraph[0]]=pregraph[4]
                        next_header_full[pregraph[0]]=pregraph[5]
        else:
            rd = rd[1:]
    # print(graph)
    return graph,bitmap,option,next_header_full

def parser1(rd, simple_format=0):
    graph = {}
    bitmap = {}
    option = {}
    next_header_full = {}
    rd = rd.replace("\t","    ")
    while rd:
        temp = re.match(r'\s',rd) # 空
        if temp:
            rd = rd[temp.end():]
            continue
        temp = re.match(r'#.*\n',rd) # 注释
        if temp:
            rd = rd[temp.end():]
            continue
        temp = re.match(r'(\S+)\s*\{(.|\s)*\}',rd)
        if temp:
            temp_parser2 = parser2(temp.group(0), simple_format)
            graph.update(temp_parser2[0])
            bitmap.update(temp_parser2[1])
            option.update(temp_parser2[2])
            next_header_full.update(temp_parser2[3])
            rd = rd[temp.end():]
            continue
        temp = re.match(r'.+',rd)
        if temp:
            rd = rd[temp.end():]
            continue
        break
    return graph,bitmap,option,next_header_full


if __name__ == '__main__':

    path = '../source'

    # path = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/gen_parser/examples'
    file = 'headers-enterprise.txt'
    simple_format = 0

    fr_path = os.path.join(path, file)
    with open(fr_path,'r') as fr:
        rd = ''.join(fr.readlines())

    graph,bitmap,option,next_header_full=parser1(rd, simple_format)
    print(graph)
    print(bitmap)
    print(option)
    print(next_header_full)


