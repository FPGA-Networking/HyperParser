######## 注释 ########

'''
Python文件作用：

第一阶段：
get_all_path.py : 这是第一个顶层文件，作用是实现图遍历，输出的是bit位串，其中type字段置为1，其他字段置为0；

第二阶段：
set_one.py : 将非type字段换成X，type字段填入真正的type值

第三阶段：
x10select.py ： 将type字段可能存在的列提取出来

生成的文件：

第一阶段：
bitmap_out.txt ：每个头的bit位串
graph_out.txt:协议栈，每种协议值单独一条
next_header_out.txt：协议栈
option_out.txt：option的可能长度（以bit算）
output.txt：输出的bit位串，其中type字段置为1，其他字段置为0；


第二阶段：
setone_graph_out.txt ：还是协议栈，不过每种协议号都对应一条
setone_output.txt ：bit位串，非type字段换成X，type字段填入真正的type值


第三阶段：
x10select_info.txt ：type可能存在的列的列号
x10select_output.txt ：type字段可能存在的列的集合

需要修改的路径/参数
get_all_path.py ：line-4 -> line-7，修改输入文件的路径； line-9：是否考虑option字段，考虑就是1



'''


#####################

import os, time, sys, io

# path = 'E:/workspace/python/_hyperparser/_arrange'
# source = os.path.join(path,'source')
# target = os.path.join(path,'txt')


# import os, sys, io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='utf-8')

dirname, filename = os.path.split(os.path.abspath(sys.argv[0]))

dirname = dirname.replace('\\', '/')

source = dirname.replace(dirname[-4:], 'source')
target = dirname.replace(dirname[-4:], 'txt')


# source = '../source'
# target = '../txt'

all_files = [ 'headers-big_union.txt',
              
              
              'headers-service_provider-fixed.txt',
              
              
              
              'headers-simple.txt',
              'headers-edge.txt',
              'headers-datacenter.txt',
              'headers-enterprise.txt',
              'headers-service_provider-prog.txt',




            ]
# 'headers-service_provider-fixed.txt' 无法解析，转化为'headers-service_provider-prog.txt'来解析

file = all_files[-1]

print('parse graph:', file)

start = time.time()


# if 0:
if 1:

    # 第一阶段
    # option_sw = 1
    option_sw = 0
    space_num = 1
    from get_all_path import get_all_path
    get_all_path(source,target,file,option_sw,space_num)
    print('end phase 1\n')

    # 第二阶段。将type字段填充进去
    # 无法处理fixed格式的。需要先将fixed转化
    from set_one import set_one
    set_one(target)
    print('end phase 2\n')

    # 第三阶段
    # 如果某列里面没有type的，这列删除
    from x10select import x10select
    x10select(target)
    print('end phase 3 x10select\n')

    # 删除重复列，删除列里面0 1不同时有的
    from x10select_pre_diff import x10select_pre_diff
    x10select_pre_diff(target)
    print('end phase 3 x10select_pre_diff\n')

# start = time.time()
# # 以积分模式从小到大尝试，可以区分一个组合得一分，一旦有一个能够区分所有，跳出。暴力方式
# # need_min参数从列的log2开始取，可以调大来提高速度
# from x10select_further import x10select_further
# x10select_further(target)
# print('end phase 3 x10select_further\n')
# end = time.time()
# print(end-start)

# 不同于x10select_further，后面的修改了匹配算法，不再直接用 x 0 1 来看是不是匹配的
# 1->10，0->01，x->11 修改比较方式的算法。修改了给出一组解，判断是否符合要求的判断方式

# # 按照相似度分组，从和其他行最不相似的开始选，直到选到可以通过，似乎效果不好，哪里有点问题
# from x10select_further_xiangsidu import x10select_further_xiangsidu
# x10select_further_xiangsidu(target)
# print('end phase 3 x10select_further_xiangsidu\n')

# start = time.time()
# 也是暴力方式。和x10select_further相比，修改了匹配算法，运行起来耗时要少一些
# 耗时（'headers-simple.txt', 2.056514024734497 -> 1.8929381370544434）不是很明显但确实快了
# need_min参数从列的log2开始取，可以调大来提高速度

from x10select_further2_baoli import x10select_further2_baoli
def repeat_x10():
    num_now = x10select_further2_baoli(target, assign_min=None, down_step=1,filesel=0)
    num_last = -1
    while num_now!=num_last:
        num_last = num_now
        num_now = x10select_further2_baoli(target, assign_min=None, down_step=1,filesel=1)
    # x10select_further2_baoli(target, assign_min=None, down_step=1,filesel=1)

repeat_x10()
# from x10select_further2_baoli import x10select_further2_baoli
# x10select_further2_baoli(target, assign_min=None, down_step=1,filesel=1)
# x10select_further2_baoli(target, assign_min=None, down_step=1,filesel=0)
# # x10select_further2_baoli(target)
print('end phase 3 x10select_further2_baoli\n')
# end = time.time()
# print(end-start)

# 暴力匹配的逻辑
# 从 need_min=math.ceil(math.log(len(rd), 2)) 开始一个一个往上试，直到有解
# 其中，len(rd)是送进去总行数
# 
# 但可以反向来，从 总列数-1 开始，如果有解，就记录下来
# 此时，总列数就变成总列数-1
# 重复以上步骤，直到无解
# 
# 这样比较快，但找到的可能是局部最优解。因为迭代的每一步都依赖于上一步的结果
# 
# 如果要改进，
# 1. 可以考虑模拟退火算法的思想。得到一组解后，再加入被去掉的列。
# √ 2. 在得到一个解后，将 need_min 设置为这个解使用的列数-1，然后在初始的情况中暴力计算，看看能不能找到新解
# √ 3. 或者干脆依次往下尝试

end = time.time()
print(end-start)
# 25.657362461090088