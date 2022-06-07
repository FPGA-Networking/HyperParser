import   os, re
# BASE_DIR = os.path.dirname(os.path.abspath(__file__)) 
# sys.path.append(BASE_DIR)
import parser_txt, search_graph
# print(BASE_DIR)
# print(sys.path)

def get_all_path(path,path_2,file,option_sw,space_num):

    def deal_pseudofields(match):
        # print(match)
        return ''

    fr_path = os.path.join(path, file)

    with open(fr_path,'r') as fr:
        # rd = ''.join(fr.readlines())
        rd = re.sub(r'\}\s*pseudo-fields\s*\{',deal_pseudofields,''.join(fr.readlines())) # 去除pseudo-fields以支持fixed
    # print(rd)

    graph,bitmap,option,next_header_full=parser_txt.parser1(rd)
    # print(graph)
    allpath = search_graph.findAllPath(graph,'ethernet','')

    # with open('graph_out.txt','w') as fg:
    #     for i in allpath:
    #         fg.write('->'.join(i[:-1])+'\n')

    with open(os.path.join(path_2, 'bitmap_out.txt'),'w') as fb:
        for i in bitmap.items():
            fb.write(i[0]+'\n')
            fb.write(i[1]+'\n\n')

    with open(os.path.join(path_2, 'next_header_out.txt'),'w') as fn:
        for i in next_header_full.items():
            fn.write(i[0]+' : ')
            if i[1]!=['']:
                for j in i[1]:
                    fn.write('('+', '.join(j[:-1])+')->'+j[-1]+', ')
            fn.write('\n')
            
    with open(os.path.join(path_2, 'option_out.txt'),'w') as fo:
        for i in option.items():
            fo.write(i[0]+' : ')
            for item in i[1]:
                fo.write(str(item)+', ')
            fo.write('\n')

    with open(os.path.join(path_2, 'output.txt'),'w') as fw, open(os.path.join(path_2, 'graph_out.txt'),'w') as fg:
        for i in allpath:
            pseudo_flag=0
            mpls_flag=0
            prewrite_list=['']
            for j in i[:-1]:
                temp_wl=[]
                if pseudo_flag:
                    pseudo_flag = 0
                    temp_w=bitmap[j][4:]
                elif j=='mpls-pseudo':
                    temp_w=bitmap[j]
                elif 'mpls' in j and j!='mpls-pseudo':
                    temp_w=bitmap[j].replace('1111','')
                elif mpls_flag and 'mpls' not in j:
                    mpls_flag=0
                    temp_w='1111'+bitmap[j][4:]
                else:
                    temp_w=bitmap[j]

                if j=='mpls-pseudo':
                    pseudo_flag = 1
                elif 'mpls' in j:
                    mpls_flag = 1

                if option_sw:
                    for cnt in option[j]:
                        # temp_wl.append(temp_w+str(cnt)+'o')
                        temp_wl.append(temp_w+cnt*'0'+space_num*' ')
                else:
                    temp_wl.append(temp_w+space_num*' ')
                # print(temp_wl)

                prewrite_list=prewrite_list*len(temp_wl)
                for k in range(len(prewrite_list)):
                    prewrite_list[k]+=temp_wl[k%len(temp_wl)]
                # print(len(prewrite_list))

            for item in prewrite_list:
                fw.write(item+'\n')
                fg.write('->'.join(i[:-1])+'\n')



            #     1. map中所有的作为1的修改--完成
            #     2. option弄个开关--完成
            #     3. max_length是字段的最大长度--完成
            #     4. poseudo--完成
            #     5. 填1的部分换成01串
            #     

if __name__ == '__main__':


    path = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/gen_parser/examples'

    path_2 = 'X:/360MoveData/Users/ISN-Gao/Desktop/Parser_to_huang/PyCode_from_huang/doing'



    # file = 'headers-big_union.txt'
    # file = 'headers-datacenter.txt'
    # file = 'headers-edge.txt'
    file = 'headers-enterprise.txt'
    # file = 'headers-service_provider-prog.txt'  # 22行 41列
    # file = 'headers-simple.txt'


    option_sw = 0
    space_num = 1

    get_all_path(source,target,file,option_sw,space_num)


