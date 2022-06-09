import math
def pex_ibf_cfg (bitmask):
    bit_src_addr =[]
    bit_dest_addr=[]
    layer_num    = int(math.log2(len(bitmask)))
    xbar_num     = len(bitmask)//2
    ibf_cfg = [[0 for j in range(xbar_num)] for i in range(layer_num)]
    bit_cnt = 0
    for i in range(0,len(bitmask)):
        if bitmask[i] == 1:
            bit_src_addr.append(i)
            bit_dest_addr.append(bit_cnt)
            bit_cnt += 1


    bit_addr_now = bit_dest_addr

    for i in range(layer_num):
        shift_num = len(bitmask)//(2**(i+1)) # 每一层转移的大小
        for j in range(len(bit_addr_now)):
            region_dest = math.floor(bit_addr_now[j]/shift_num)
            region_src  = math.floor(bit_src_addr[j]/shift_num)
            if region_dest != region_src:
                xbar_addr = shift_num*math.floor(bit_addr_now[j]/(2*shift_num))+bit_addr_now[j]%shift_num
                ibf_cfg[i][xbar_addr] = 1
                if bit_addr_now[j]>bit_src_addr[j]:
                    bit_addr_now[j] = bit_addr_now[j]-shift_num
                else:
                    bit_addr_now[j] = bit_addr_now[j]+shift_num

    return ibf_cfg

def pdep_bf_cfg(bitmask):
    ibf_cfg = pex_ibf_cfg(bitmask)
    layer_num = len(ibf_cfg)
    bf_cfg = []
    for i in range(layer_num):
        bf_cfg.append(ibf_cfg[layer_num-1-i])

    return bf_cfg



print(pex_ibf_cfg([1,0,1,1,0,1,0,1]))

print(pdep_bf_cfg([1,0,1,1,0,1,0,1]))
