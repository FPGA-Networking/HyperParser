# bf实现pdep（分散）、ibf实现pex（提取）

import math

def bf_operation(total_layer, layer, data_src_addr, data_dest_addr):
    control_bit_len = 2**(total_layer-1) # 控制bit的个数
    control_bit = [0 for i in range(control_bit_len)] # 控制bit列表
    total_element_num = 2*control_bit_len # 每一层总的元素个数
    data_src_addr_local = data_src_addr #将源地址存到函数本地
    data_dest_addr_local = data_dest_addr #将目的地址存到函数本地
    element_num = len(data_src_addr_local) # 被操作的元素（源/目的）的数量
    data_temp_addr_lcoal = [0 for i in range(0,element_num)]
    shift_num  = 2**(total_layer-layer) # 本层蝶形网络的移位数量
    region_num = 2**(layer-1) # 所谓region，就是完全相同的区域，比如stage 1有1个region，stage 2有2个，stage 3有4个
    region_element_num = total_element_num/region_num # 一个region中元素的数量

    for i in range(0,element_num) :
        # print('第',i,'次循环')
        control_bit_region = (data_src_addr_local[i]//region_element_num)*(control_bit_len/region_num)
        index_in_region = (data_src_addr_local[i])%(region_element_num/2)
        control_bit_index = int(control_bit_len-1-(control_bit_region+index_in_region)) 
        # print('control_bit_index = ',control_bit_index,'control_bit_region = ',control_bit_region,'index_in_region = ', index_in_region)
        if (data_src_addr_local[i] // (region_element_num/2)) == (data_dest_addr_local[i] // (region_element_num/2)):
            # print('分支1')
            control_bit[control_bit_index] = 0
            data_temp_addr_lcoal[i] =  (data_src_addr_local[i])
        else :
            # print('分支2')
            control_bit[control_bit_index] = 1
            if (data_src_addr_local[i] % region_element_num) <= (region_element_num/2-1):
                # print('分支2-1') 
                data_temp_addr_lcoal[i] =  (data_src_addr_local[i]+shift_num)
            else :
                # print('分支2-2') 
                data_temp_addr_lcoal[i] =  (data_src_addr_local[i]-shift_num)
  

    return control_bit,data_temp_addr_lcoal

def pdep_bf_network(bit_mask) :
    
    total_layer  = int(math.log(len(bit_mask),2))
    data_src_len = bit_mask.count(1)
    data_bus_len = 2 ** total_layer  # 数据总线位宽
    mux_N = int(data_bus_len/data_src_len) # N选1
    layer_of_mux = int(math.log(mux_N,2)) # pdep和pex是反过来的

    data_src_addr_output = [(data_src_len-1-i) for i in range(0,data_src_len)]  # 最高位在左边,7到1
    data_src_addr = data_src_addr_output
    data_dest_addr = []
    control_bit_result = []
    for i in range(0,len(bit_mask)):
        if bit_mask[i] == 1 :
            data_dest_addr.append(data_bus_len-1-i)
    # print(data_dest_addr,data_src_addr)

    layer = 0
    for i in range(0,total_layer):
        layer = layer+1
        result = bf_operation(total_layer, layer, data_src_addr, data_dest_addr)
        data_src_addr = result[1]
        if i == layer_of_mux-1:
            data_src_addr_temp_dec = [i for i in result[1]]
            data_src_addr_temp =  [i//data_src_len   for i in result[1]]    # 错的： [i%mux_N   for i in result[1]]
            data_src_addr_to_bin = [( '{:0'+str( layer_of_mux )+'b}').format(i) for i in data_src_addr_temp ]
        if i>layer_of_mux-1:
            # print('i=',i)
            control_bit_result.append(result[0])

        # data_src_addr = data_src_addr_to_hex
        
        # print(data_src_addr,control_bit_result)

    # 返回：目的地址，操作后的源地址（应该等于目的地址），源地址，bf网络的控制bit
    return data_dest_addr, data_src_addr ,data_src_addr_output, control_bit_result,data_src_addr_to_bin, data_src_addr_temp_dec


def pex_ibf_network(bit_mask) : # layer_before_mux进入mux之前的层号，从1开始算
    bf_result = pdep_bf_network(bit_mask)
    control_bit_bf = bf_result[3]
    control_bit_bf.reverse()
    control_bit_ibf=control_bit_bf
    # 返回：目的地址，操作后的目的地址（应该等于源地址），源地址，bf网络的控制bit
    # return bf_result[2],bf_result[1],bf_result[0],control_bit_ibf
    return bf_result[5],bf_result[4],control_bit_ibf


# total_layer  = 3  # 蝶形网络的层数，等于log2（data_bus_len）,从1开始算
# data_src_len = 5  # 被操作的bit的个数

# layer_before_mux = 2


# total_layer  = 4  # 蝶形网络的层数，等于log2（data_bus_len）,从1开始算
# data_src_len = 10  # 被操作的bit的个数
# bit_mask = [1,0,1,0,1,1,0,1,1,0,1,0,1,1,0,1]

# bit_mask = [1,0,0,0,1,0,0,0,1,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] #mode=0
# bit_mask = [0,0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0] #mode=1
bit_mask = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1] #mode=2

addr = pex_ibf_network(bit_mask)[0]
mux_ctrl = pex_ibf_network(bit_mask)[1] #二进制输出的，MUX控制符号
ibf_ctrl = pex_ibf_network(bit_mask)[2] # 将ibf_ctl转化位字符串形式
ibf_ctrl_str = [[str(j) for j in i]  for i in ibf_ctrl  ]
# print(mux_ctrl,ibf_ctrl,ibf_ctrl_str)

mux_ctrl_to_write_bin = ''.join(mux_ctrl)
ibf_ctrl_to_write_bin = [''.join(i) for i in  ibf_ctrl_str ]

mux_ctrl_to_write_hex = ( '{:0'+str( int(len(mux_ctrl_to_write_bin)/4) )+'x}').format(int(mux_ctrl_to_write_bin,2))
ibf_ctrl_to_write_hex = [( '{:0'+str( int(len(i)/4) )+'x}').format(int(i,2))  for i in ibf_ctrl_to_write_bin]

print(addr,mux_ctrl,ibf_ctrl,mux_ctrl_to_write_bin,ibf_ctrl_to_write_bin,mux_ctrl_to_write_hex,ibf_ctrl_to_write_hex)



# '{:016b}'.format(i)

# ( '{:0'+str( len(mux_ctrl_to_write_bin) )+'x}').format(i)




# print(bit_mask,data_addr_src)
# print(bf_operation(3,1,data_src_addr,data_dest_addr))
# print(data_src_addr,data_dest_addr)

