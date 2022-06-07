from collections import Counter
import os, time, sys, io
sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='utf-8')

dirname, filename = os.path.split(os.path.abspath(sys.argv[0]))

dirname = dirname.replace('\\', '/')

target = dirname.replace(dirname[-4:], 'txt')

with open (target+'/x10select_output.txt') as files:
    data_source_temp = files.readlines()

data_source = []
for i in data_source_temp:
    data_source.append(i[0:-1]) # 去除 \n

# print(data_source)


# sys.exit()



# print(data_source)

print('\n')
print('Start Pre Processing')
print('\n')


x_len = len(data_source[0]) # 列数
y_len = len(data_source)    # 行数
print('x_len:',x_len,'  ','y_len:',y_len)

data_source_transpose = []

for i in range(x_len):
    temp = ''
    for j in range(y_len):             # 行列变换，方便处理，类似转置
        temp = temp+data_source[j][i]
    data_source_transpose.append(temp)

# for i in data_source_transpose:
#     print(i)

# print('len(data_source_transpose)', len(data_source_transpose))

# print('Counter(data_source_transpose)', Counter(data_source_transpose))


data_source_transpose_set = list(set(data_source_transpose))  # 去除重复列


print('len(data_source_transpose_set)', len(data_source_transpose_set))

# print('y_len 1 in data_source_transpose_set', y_len*'1' in data_source_transpose_set )
# print('y_len 0 in data_source_transpose_set', y_len*'0' in data_source_transpose_set )

if y_len*'1' in data_source_transpose_set :
    data_source_transpose_set.remove(y_len*'1')
    print('remove y_len 1 from data_source_transpose_set') # 去除全1列

if y_len*'0' in data_source_transpose_set :
    data_source_transpose_set.remove(y_len*'0')
    print('remove y_len 0 from data_source_transpose_set') # 去除全0列

print('\n')
print('len(data_source_transpose_set)', len(data_source_transpose_set))
# print('\n')

# print('\ndata_source_transpose_set:\n')
# for i in data_source_transpose_set:
#     print(i)

data_source_transpose_set_bin = []
data_source_transpose_set_mask = []

for i in data_source_transpose_set:  # 转化为int方便处理
    temp_data = 0
    temp_mask = 0
    for j in i:
        if j == '0':
            temp_data = (temp_data<<1)+0
            temp_mask = (temp_mask<<1)+1
        elif j == '1':
            temp_data = (temp_data<<1)+1
            temp_mask = (temp_mask<<1)+1
        elif j == 'x':
            temp_data = (temp_data<<1)+0
            temp_mask = (temp_mask<<1)+0
    data_source_transpose_set_bin  .append(temp_data)
    data_source_transpose_set_mask .append(temp_mask)

kick_num = []
for i in range(len(data_source_transpose_set_bin)):  # 去除冗余列，所谓冗余列，就是功能相包含的列
    for j in range(i+1,len(data_source_transpose_set_bin)):
        data_a = data_source_transpose_set_bin[i]
        data_b = data_source_transpose_set_bin[j]
        mask_a = data_source_transpose_set_mask[i]
        mask_b = data_source_transpose_set_mask[j]


        if (data_a&mask_a == data_b&mask_a)&((mask_a&mask_b) == mask_a):
            kick_num.append(i)
            # print('get two equal a','i',i,'j',j)
            # print('a:', data_source_transpose_set[i])
            # print('b:', data_source_transpose_set[j])

        elif (data_a&mask_b == data_b&mask_b)&((mask_a&mask_b) == mask_b):
            kick_num.append(j)
            # print('get two equal b','i',i,'j',j)
            # print('a:', data_source_transpose_set[i])
            # print('b:', data_source_transpose_set[j])
    
kick_data = []        
for i in kick_num:
    kick_data.append(data_source_transpose_set[i])
    # print(data_source_transpose_set[i])
    

kick_data = list(set(kick_data))
# for i in kick_data:
#     print('i',i)

for i in kick_data:
    data_source_transpose_set.remove(i)

# for i in data_source_transpose_set:
#     print(i)


x_len = len(data_source_transpose_set) # 列数
y_len = len(data_source_transpose_set[0])    # 行数
print('\n')
print('x_len:',x_len,'  ','y_len:',y_len)
print('\n')


data_source = []

for i in range(y_len):
    temp = ''
    for j in range(x_len):
        temp = temp+data_source_transpose_set[j][i]   # 处理完成，需要行列变换回来，类似转置
    data_source.append(temp)

# for i in data_source:
#     print(i)

data_source_with_Enter = [] # 需要加换行符

for i in data_source:
    data = i+'\n'
    data_source_with_Enter.append(data)



with open(target+'/PreProcess.txt','w') as file_w:
    file_w.writelines(data_source_with_Enter)

print('Write File:PreProcess.txt')
print('\n\n')
print('End Pre Processing')
print('\n')

