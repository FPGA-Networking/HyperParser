from collections import Counter




def bin_to_str_01X(din,len_str):
    temp = ''
    for i in range(len_str):
        # print(din[i*2:i*2+2])
        if din[i*2:i*2+2] == '01' :
            temp = temp+'0'
        elif din[i*2:i*2+2] == '10' :
            temp = temp+'1'
        elif din[i*2:i*2+2] == '11' :
            temp = temp+'x'
    # print(temp)
    return temp



# data_source = [
# '100000010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000000110xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '100100010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000000110xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '100000010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000010001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0001001010110101xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '100100010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000010001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0001001010110101xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '100000010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '100100010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '100000010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1011001010101100110110010101011000xxxxxxxxxxxxxxxxx',
# '100100010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1011001010101100110110010101011000xxxxxxxxxxxxxxxxx',
# '100000010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx101100101010110011011001010101100110110010101011000',
# '100100010000000010000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx101100101010110011011001010101100110110010101011000',
# '10000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000000110xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10010001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000000110xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000010001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0001001010110101xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10010001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000010001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0001001010110101xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10010001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1011001010101100110110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10010001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1011001010101100110110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '10000001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx101100101010110011011001010101100110110010101011000xxxxxxxxxxxxxxxxx',
# '10010001000000000000100000000000xxxxxxxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx101100101010110011011001010101100110110010101011000xxxxxxxxxxxxxxxxx',
# '0000100000000000xxxxxxxxxxxxxxxxxxx000000000000000000110xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '0000100000000000xxxxxxxxxxxxxxxxxxx000000000000000010001xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx0001001010110101xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '0000100000000000xxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx10110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '0000100000000000xxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx1011001010101100110110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
# '0000100000000000xxxxxxxxxxxxxxxxxxx000000000000000101111xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx101100101010110011011001010101100110110010101011000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',

# ]

data_source = [
'10001000010001110xxxx0xxxx0xxxx0xxxx10100',
'10001000010010000xxxx0xxxx0xxxx0xxxx10100',
'10001000010001110xxxx0xxxx0xxxx0xxxx10110',
'10001000010010000xxxx0xxxx0xxxx0xxxx10110',
'10001000010001110xxxx0xxxx0xxxx10100xxxxx',
'10001000010010000xxxx0xxxx0xxxx10100xxxxx',
'10001000010001110xxxx0xxxx0xxxx10110xxxxx',
'10001000010010000xxxx0xxxx0xxxx10110xxxxx',
'10001000010001110xxxx0xxxx10100xxxxxxxxxx',
'10001000010010000xxxx0xxxx10100xxxxxxxxxx',
'10001000010001110xxxx0xxxx10110xxxxxxxxxx',
'10001000010010000xxxx0xxxx10110xxxxxxxxxx',
'10001000010001110xxxx10100xxxxxxxxxxxxxxx',
'10001000010010000xxxx10100xxxxxxxxxxxxxxx',
'10001000010001110xxxx10110xxxxxxxxxxxxxxx',
'10001000010010000xxxx10110xxxxxxxxxxxxxxx',
'100010000100011110100xxxxxxxxxxxxxxxxxxxx',
'100010000100100010100xxxxxxxxxxxxxxxxxxxx',
'100010000100011110110xxxxxxxxxxxxxxxxxxxx',
'100010000100100010110xxxxxxxxxxxxxxxxxxxx',
'0000100000000000xxxxxxxxxxxxxxxxxxxxxxxxx',
'1000011011011101xxxxxxxxxxxxxxxxxxxxxxxxx',
]
print(data_source)

x_len = len(data_source[0]) # 列数
y_len = len(data_source)    # 行数
print('x_len:',x_len,'  ','y_len:',y_len)

data_source_transpose = []

for i in range(x_len):
    temp = ''
    for j in range(y_len):
        temp = temp+data_source[j][i]
    data_source_transpose.append(temp)

# for i in data_source_transpose:
#     print(i)

print('len(data_source_transpose)', len(data_source_transpose))

print('Counter(data_source_transpose)', Counter(data_source_transpose))


data_source_transpose_set = list(set(data_source_transpose))
# data_source_transpose_set = data_source_transpose


print('len(data_source_transpose_set)', len(data_source_transpose_set))

# print('y_len 1 in data_source_transpose_set', y_len*'1' in data_source_transpose_set )
# print('y_len 0 in data_source_transpose_set', y_len*'0' in data_source_transpose_set )

if y_len*'1' in data_source_transpose_set :
    data_source_transpose_set.remove(y_len*'1')
    print('remove y_len 1 from data_source_transpose_set')

if y_len*'0' in data_source_transpose_set :
    data_source_transpose_set.remove(y_len*'0')
    print('remove y_len 0 from data_source_transpose_set')

print('\n')
print('len(data_source_transpose_set)', len(data_source_transpose_set))
print('\n')

# print('\ndata_source_transpose_set:\n')
for i in data_source_transpose_set:
    print(i)

data_source_transpose_set_bin = []
data_source_transpose_set_mask = []

for i in data_source_transpose_set:
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
for i in range(len(data_source_transpose_set_bin)):
    for j in range(i+1,len(data_source_transpose_set_bin)):
        data_a = data_source_transpose_set_bin[i]
        data_b = data_source_transpose_set_bin[j]
        mask_a = data_source_transpose_set_mask[i]
        mask_b = data_source_transpose_set_mask[j]
        # print('data_a',data_a)
        # print('data_b',data_b)
        # print('mask_a',mask_a)
        # print('mask_b',mask_b)
        # if (data_a&mask_a == data_b&mask_a):
        #     print('get two equal')
        #     print('a:', data_source_transpose_set[i])
        #     print('b:', data_source_transpose_set[j])
        #     print('data_a',data_a)
        #     print('data_b',data_b)
        #     print('mask_a',mask_a)
        #     print('mask_b',mask_b)
        # elif (data_a&mask_b == data_b&mask_b):
        #     print('get two equal')
        #     print('a:', data_source_transpose_set[i])
        #     print('b:', data_source_transpose_set[j])
        #     print('data_a',data_a)
        #     print('data_b',data_b)
        #     print('mask_a',mask_a)
        #     print('mask_b',mask_b)

        if (data_a&mask_a == data_b&mask_a)&((mask_a&mask_b) == mask_a):
            kick_num.append(i)
            print('get two equal a','i',i,'j',j)
            print('a:', data_source_transpose_set[i])
            print('b:', data_source_transpose_set[j])

        elif (data_a&mask_b == data_b&mask_b)&((mask_a&mask_b) == mask_b):
            kick_num.append(j)
            print('get two equal b','i',i,'j',j)
            print('a:', data_source_transpose_set[i])
            print('b:', data_source_transpose_set[j])
    
kick_data = []        
for i in kick_num:
    kick_data.append(data_source_transpose_set[i])
    print(data_source_transpose_set[i])
    

kick_data = list(set(kick_data))
for i in kick_data:
    print('i',i)

for i in kick_data:
    data_source_transpose_set.remove(i)

for i in data_source_transpose_set:
    print(i)


x_len = len(data_source_transpose_set) # 列数
y_len = len(data_source_transpose_set[0])    # 行数
print('x_len:',x_len,'  ','y_len:',y_len)

data_source = []

for i in range(y_len):
    temp = ''
    for j in range(x_len):
        temp = temp+data_source_transpose_set[j][i]
    data_source.append(temp)

for i in data_source:
    print(i)

# data_source_transpose_set_bin = [] # 使用二进制代替字符串，实现更高效地处理 '0'编码为01，'1'编码为10，'x'编码为11
# for i in data_source_transpose_set:
#     temp = 0
#     for j in i:
#         # print('j', j)
#         # print('temp',temp)
#         if j == '0':
#             temp = (temp<<2)+1 # 01
#         elif j == '1':
#             temp = (temp<<2)+2 # 10
#         elif j == 'x':
#             temp = (temp<<2)+3 # 11
#             # print(' x is detected')
#     data_source_transpose_set_bin.append(temp)

# for i in data_source_transpose_set_bin:
#     print(bin(i)[2:].zfill(y_len*2))

# mask_1 = y_len*'01'
# mask_2 = y_len*'10'

# mask_1 = int(mask_1,2) # 010101...
# mask_2 = int(mask_2,2) # 101010...

# for i in range(len(data_source_transpose_set_bin)):
#     for j in range(i+1,len(data_source_transpose_set_bin)):
#         a = data_source_transpose_set_bin[i] 
#         b = data_source_transpose_set_bin[j]
#         c = a&b
#         d = c&mask_1
#         e = c&mask_2
#         f = d | (e>>1)
#         if (f == mask_1):
#             print('get two equal')
#             # print('a', bin(a)[2:].zfill(y_len*2))
#             # print('b', bin(b)[2:].zfill(y_len*2))
#             a_char = bin(a)[2:].zfill(y_len*2)
#             b_char = bin(b)[2:].zfill(y_len*2)

#             print('a', bin_to_str_01X(a_char,y_len))
#             print('b', bin_to_str_01X(b_char,y_len))

#         print('\n')


# print('no equal two')






# test = '01010101010101010101010101010101010101010101010101'
# test_1 = int(test,2)

# a = test_1
# b = test_1
# c = a&b
# print('c',bin(c)[2:].zfill(y_len*2))
# d = c&mask_1
# print('d',bin(d)[2:].zfill(y_len*2))
# e = c&mask_2
# print('e',bin(e)[2:].zfill(y_len*2))
# f = d | (e>>1)
# print('f',bin(f)[2:].zfill(y_len*2))
# print('mask_1',bin(mask_1)[2:].zfill(y_len*2))

# if (f == mask_1):
#     print('get two equal')

# print('no equal two')
