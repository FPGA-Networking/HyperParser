import os

def x10select(path_2):

    with open(os.path.join(path_2, 'setone_output.txt'),'r') as fr:
        rd = fr.readlines()

    raw_len=[]
    new_rd=[]
    line_set=set()
    for li in rd:
        raw_len.append(len(li[:-1]))

    max_len=max(raw_len)

    for li in rd:    
        for i in range(max_len):
            if i<len(li[:-1]) and li[i]!='x':
                line_set.add(i)
    line_set=sorted(line_set)
    # print(line_set,len(line_set))

    with open(os.path.join(path_2, 'x10select_output.txt'),'w') as fw:
        for li in rd:
            for num in line_set:
                try:
                    fw.write(li[:-1][num]) # 注意此处\n
                except:
                    fw.write('x')
            fw.write('\n')

    with open(os.path.join(path_2, 'x10select_info.txt'),'w') as finfo:
        finfo.write('select_index (from 0): \n'+', '.join(str(c) for c in line_set)+'\n\noriginal head length: \n')
        for i in range(len(raw_len)):
            finfo.write('{0: <4}: {1}\n'.format(i+1,raw_len[i]))


if __name__ == '__main__':

    path_2 = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing'

    x10select(path_2)

