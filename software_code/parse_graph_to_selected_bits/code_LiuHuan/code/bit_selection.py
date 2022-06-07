from collections import Counter
import os, time, sys, io



######### 读取数据矩阵 #####################
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='utf-8')

dirname, filename = os.path.split(os.path.abspath(sys.argv[0]))

dirname = dirname.replace('\\', '/')

target = dirname.replace(dirname[-4:], 'txt')

with open (target+'/PreProcess.txt') as files:
    data_source_temp = files.readlines()

data_source = []
for i in data_source_temp:
    data_source.append(i[0:-1]) # 去除 \n


x_len = len(data_source[0]) # 列数
y_len = len(data_source)    # 行数
print('x_len:',x_len,'  ','y_len:',y_len) # 获取矩阵大小
# for i in data_source:
#     print(i)
# sys.exit()
### ----------------------------------------------------------------

######### 把字符串转换为数字，以便进一步处理 ############

data_source_bin  = []
data_source_mask = []

for i in data_source:  # 转化为int方便处理
    temp_data = 0
    temp_mask = 0
    for j in i:
        if j == '0':
            temp_data = (temp_data<<1)+0
            temp_mask = (temp_mask<<1)+0
        elif j == '1':
            temp_data = (temp_data<<1)+1
            temp_mask = (temp_mask<<1)+0
        elif j == 'x':
            temp_data = (temp_data<<1)+0
            temp_mask = (temp_mask<<1)+1 # 这里mask等于1代表着x
    data_source_bin  .append(temp_data)
    data_source_mask .append(temp_mask)


### -------------------------------------------------------








############### 定义组合函数 ########################
from math import factorial

def comb(n,m):
    result = factorial(n)//(factorial(m)*factorial(n-m))
    return result
# --------------------------------------------------

######## 定义从整数中踢出特定列的函数 #############

def column_kick (din,len_i,kick_posit):  # 分别是输入的整数、整数的长度（二进制多少位），以及需要踢出的列，要求kick_posit中的数递减，而且din最低位是第1列
    for i in kick_posit:

        din = ((din - ((2**i - 1)&din))>>1) + ( (2**(i-1)-1)&din )
        # print(bin(din))
    
    return din







### ----------------------------------------------



### 定义生成器####################################################
def iter_1(num):
    for a1 in range(num):
        yield [num-a1]

def iter_2(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            yield [num-a1,num-a2]

def iter_3(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            for a3 in range(a2+1,num):
                yield [num-a1,num-a2,num-a3]

def iter_4(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            for a3 in range(a2+1,num):
                for a4 in range(a3+1,num):
                    yield [num-a1,num-a2,num-a3,num-a4]
def iter_5(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            for a3 in range(a2+1,num):
                for a4 in range(a3+1,num):
                    for a5 in range(a4+1,num):
                        yield [num-a1,num-a2,num-a3,num-a4,num-a5]

def iter_6(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            for a3 in range(a2+1,num):
                for a4 in range(a3+1,num):
                    for a5 in range(a4+1,num):
                        for a6 in range(a5+1,num):
                            yield [num-a1,num-a2,num-a3,num-a4,num-a5,num-a6]                        

def iter_7(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            for a3 in range(a2+1,num):
                for a4 in range(a3+1,num):
                    for a5 in range(a4+1,num):
                        for a6 in range(a5+1,num):
                            for a7 in range(a6+1,num):
                                yield [num-a1,num-a2,num-a3,num-a4,num-a5,num-a6,num-a7]    
def iter_8(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            for a3 in range(a2+1,num):
                for a4 in range(a3+1,num):
                    for a5 in range(a4+1,num):
                        for a6 in range(a5+1,num):
                            for a7 in range(a6+1,num):
                                for a8 in range(a7+1,num):
                                    yield [num-a1,num-a2,num-a3,num-a4,num-a5,num-a6,num-a7,num-a8]    
def iter_9(num):
    for a1 in range(num):
        for a2 in range(a1+1,num):
            for a3 in range(a2+1,num):
                for a4 in range(a3+1,num):
                    for a5 in range(a4+1,num):
                        for a6 in range(a5+1,num):
                            for a7 in range(a6+1,num):
                                for a8 in range(a7+1,num):
                                    for a9 in range(a8+1,num):
                                        yield [num-a1,num-a2,num-a3,num-a4,num-a5,num-a6,num-a7,num-a8,num-a9]    

### ------------------------------------------------------------------


#########################################################################
#########################  多步长除去列   ###############################
#########################################################################
print('\n')
print('data_source_bin')
for i in data_source_bin:
    print(bin(i)[2:].zfill(x_len))  
# print('\n')
# print('data_source_mask')
# for i in data_source_mask:
#     print(bin(i)[2:].zfill(x_len))    

stride = 1

while 1 :
    print('\n')
    print('----------------------')
    print('while start')
    print('stride=',stride)
    print('\n')
    
        
    comb_num = comb(x_len,stride)# 选择列的组合数，比如一共有10列，一次选4列，这里计算的就是C(10,4)
    # print('comb_num',comb_num)
    # sys.exit()
    if stride == 9:
        iter_instance = iter_9(x_len)
    elif stride == 8:
        iter_instance = iter_8(x_len)
    elif stride == 7:
        iter_instance = iter_7(x_len)
    elif stride == 6:
        iter_instance = iter_6(x_len)
    elif stride == 5:
        iter_instance = iter_5(x_len)
    elif stride == 4:
        iter_instance = iter_4(x_len)
    elif stride == 3:
        iter_instance = iter_3(x_len)
    elif stride == 2:
        iter_instance = iter_2(x_len)
    elif stride == 1:
        iter_instance = iter_1(x_len)
    else:
        print('stride error, exit...')
        sys.exit()

    try_cnter = 0 # 尝试的次数

    for i in range(comb_num): # 尝试一次去除stride列
        find = 0
        # print('find',find)
        # print('start comb')
        data_source_bin_temp  = []  # 用于暂时存放删除特定列后的数据
        data_source_mask_temp = []   
        try_cnter += 1
        columns_selected = next(iter_instance) # 选中需要踢出的列
        # print('columns_selected',columns_selected)
        # print('len(list(iter_instance))',len(list(iter_instance)))
        
        for data_i in data_source_bin:
            data_source_bin_temp.append(column_kick(data_i,x_len,columns_selected)) # 踢出data中的列
        for mask_i in data_source_mask:
            data_source_mask_temp.append(column_kick(mask_i,x_len,columns_selected))# 踢出mask中的列
            
        # print('\n')
        # print('data_source_bin_temp')
        # for ii in data_source_bin_temp:
        #     print(bin(ii)[2:].zfill(x_len-stride))   
        # print('\n')
        # print('data_source_mask_temp')
        # for ii in data_source_mask_temp:
        #     print(bin(ii)[2:].zfill(x_len-stride))   

        # 验证结果是不是正确的，也就是剩下的列是否可以区分出来所有的item
        collision = 0
        x_len_temp = x_len-stride
        for a1 in range(y_len):
            for a2 in range(a1+1,y_len):
                test_data_1 = data_source_bin_temp[a1]
                test_data_2 = data_source_bin_temp[a2]
                test_mask_1 = data_source_mask_temp[a1]
                test_mask_2 = data_source_mask_temp[a2]

                mask_used       = test_mask_1 | test_mask_2
                mask_inverse    = 2**x_len_temp-1 - mask_used

                if ((test_data_1^test_data_2) & (mask_inverse)) == 0:
                    collision += 1 
                    # print('test_data_1',bin(test_data_1)[2:].zfill(x_len-stride)) 
                    # print('test_data_2',bin(test_data_2)[2:].zfill(x_len-stride)) 
                    # print('test_mask_1',bin(test_mask_1)[2:].zfill(x_len-stride)) 
                    # print('test_mask_2',bin(test_mask_2)[2:].zfill(x_len-stride)) 
                    # print('mask_inverse',bin(mask_inverse)[2:].zfill(x_len-stride))
                    # print('test_xor_data',bin(test_data_1^test_data_2)[2:].zfill(x_len-stride))
                    # print('a1,a2',a1,a2)
                    # print('columns_selected', columns_selected)
                    # print('collision')
                    break
            if collision == 1:
                # print('collision')
                break
        
        if collision == 1:
            continue
        else:
            find = 1
            # print('test_data_1',bin(test_data_1)[2:].zfill(x_len-stride)) 
            # print('test_data_2',bin(test_data_2)[2:].zfill(x_len-stride)) 
            # print('test_mask_1',bin(test_mask_1)[2:].zfill(x_len-stride)) 
            # print('test_mask_2',bin(test_mask_2)[2:].zfill(x_len-stride)) 
            # print('mask_inverse',bin(mask_inverse)[2:].zfill(x_len-stride))
            # print('test_xor_data',bin(test_data_1^test_data_2)[2:].zfill(x_len-stride))
            # print('a1,a2',a1,a2)
            # print('columns_selected', columns_selected)
            # print('find')
            break

    if find == 1:
        data_source_bin = data_source_bin_temp
        data_source_mask = data_source_mask_temp
        x_len -= stride
        print('find, x_len =',x_len)
        print('----------------------')
        continue
    else:
        if stride > 1:
            stride -= 1
            print('not find')
            print('----------------------')
            continue
        else:
            print('not find')
            print('----------------------')
            break
        
        

print('x_len end',x_len)



data_source = []
for i in range(y_len):
    data_temp = ''
    data =   bin(data_source_bin[i])[2:].zfill(x_len)
    mask =  bin(data_source_mask[i])[2:].zfill(x_len)
    # print('data',data)
    # print('mask',mask)

    for j in range(x_len):
        if mask[j] == '1':
            data_temp = data_temp+'x'
        elif data[j] == '0':
            data_temp = data_temp+'0'
        elif data[j] == '1':
            data_temp = data_temp+'1'
        else:
            print('error str')

    data_temp+='\n'
    data_source.append(data_temp)

# for i in data_source:
#     print(i)

with open(target+'/Result.txt','w') as file_w:
    file_w.writelines(data_source)

print('Write File:Result.txt')
print('\n\n')
print('End Bit Selection')
print('\n')

### ---------------------------------------------------------------------
### ---------------------------------------------------------------------
### ---------------------------------------------------------------------