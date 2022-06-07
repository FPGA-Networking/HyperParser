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









import os, sys, io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer,encoding='utf-8')

dirname, filename = os.path.split(os.path.abspath(sys.argv[0]))

dirname = dirname.replace('\\', '/')

source = dirname.replace(dirname[-4:], 'source')

print(source)

# dirname.replace(dirname[-1:-4], 'source')

# print(dirname)

# os.system('python '+dirname+'/get_all_path.py')
# os.system('python '+dirname+'/set_one.py')
# os.system('python '+dirname+'/x10select.py')
# os.system('python '+dirname+'/x10select_pre_diff.py')




# print('filename', filename)
# print('dirname', dirname)
# print(type(dirname))


# print(dirname.replace('\\', '/'))


# os.system('python X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing/get_all_path.py')
# os.system('python X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing/set_one.py')
# os.system('python X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing/x10select.py')
# os.system('python X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing/x10select_pre_diff.py')
# # os.system('python X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing/x10select_further.py')