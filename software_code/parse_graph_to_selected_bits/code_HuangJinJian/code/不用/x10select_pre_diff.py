import os

def x10select_pre_diff(path):

    with open(os.path.join(path, 'x10select_output.txt'),'r') as fr:
        rd = [i[:-1] for i in fr]

    rdti = [''.join(i) for i in map(list,zip(*rd))]
    rdsel = ['0' in i and '1' in i for i in rdti]

    rdsel2=[]
    rdti2=[]
    for i in range(len(rdti)):
        if rdti[i] not in rdti2:
            rdti2.append(rdti[i])
            rdsel2.append(True)
        else:
            rdsel2.append(False)

    with open(os.path.join(path, 'x10select_info.txt'),'r') as fr_info, open(os.path.join(path, 'x10select_pre_info.txt'),'w') as fw_info:
        fw_info.write(fr_info.readline())
        li=fr_info.readline().split(', ')
        liw=[]
        for i in range(len(rdsel)):
            if rdsel[i] and rdsel2[i]:
                liw.append(li[i])
        fw_info.write(', '.join(liw))

    with open(os.path.join(path, 'x10select_pre_output.txt'),'w') as fw:
        for line in rd:
            for i in range(len(rdsel)):
                if rdsel[i] and rdsel2[i]:
                    fw.write(line[i])
            fw.write('\n')



# with open('x10select_output.txt','r') as fr:
#     rd = [i[:-1] for i in fr]
# rdti = [''.join(i) for i in map(list,zip(*rd))]

# fr_info=open('x10select_info.txt','r')
# fw_info=open('x10select_pre_info.txt','w')

# fw_info.write(fr_info.readline())
# li=fr_info.readline().split(', ')
# liw=[]

# # rdti2 = list(set(rdti))
# # rdti2.sort(key=rdti.index)
# # print(rdti2)
# rdti2=[]
# cnt=0
# for i in rdti:
#     if i not in rdti2:
#         rdti2.append(i)
#         liw.append(li[cnt])
#     cnt+=1
# print(rdti2)
# print(liw)

# rdti = [set(i) for i in rdti2]
# rdsel = ['0' in i and '1' in i for i in rdti]
# print(rdti,len(rdti))
# print(rdsel,len(rdsel))

# rd = [''.join(i) for i in map(list,zip(*rdti2))]
# with open('x10select_pre_output.txt','w') as fw:
#     for line in rd:
#         for i in range(len(rdsel)):
#             if rdsel[i]:
#                 fw.write(line[i])
#         fw.write('\n')

# li=liw
# liw=[]
# for i in range(len(rdsel)):
#     if rdsel[i]:
#         liw.append(li[i])
# fw_info.write(', '.join(liw))

# fr_info.close()
# fw_info.close()

if __name__ == '__main__':

    path = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing'

    x10select_pre_diff(path)
