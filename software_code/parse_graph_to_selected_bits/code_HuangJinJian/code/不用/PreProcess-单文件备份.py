from collections import Counter







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
# print(data_source)

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

# print('len(data_source_transpose)', len(data_source_transpose))

# print('Counter(data_source_transpose)', Counter(data_source_transpose))


data_source_transpose_set = list(set(data_source_transpose))


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
# print('\n')

# print('\ndata_source_transpose_set:\n')
# for i in data_source_transpose_set:
#     print(i)

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
        temp = temp+data_source_transpose_set[j][i]
    data_source.append(temp)

for i in data_source:
    print(i)
