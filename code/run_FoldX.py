# code from deePheMut
# run in Linux or Windows

import os
import subprocess
import shutil

def run_FoldX(path_to_foldx,WT_PDB,mutant_file):
    '''
    Function to operate foldx in python
    '''
    # move pdb file to folder
    print("...FoldX mutation PDB generating...")
    shutil.copy(WT_PDB, path_to_foldx)
    FoldX_WT_PDB = WT_PDB.split("/")[-1]
    # handle mutation file
    mutant_data = []
    type = []
    with open(mutant_file, 'r') as file:
        for line in file:
            columns = line.strip().split('\t')
            mutant_data.append(columns[1][:1] + "A" + columns[1][1:] + ";")
            type.append(columns[0])
    f = open(path_to_foldx+"/individual_list.txt", "w")
    for item in mutant_data:
        f.write(item + "\n")
    f.close()
    # print(type)
    # change to file
    original_directory = os.getcwd()
    folder_path = path_to_foldx
    os.chdir(folder_path)
    # run FoldX
    foldx_command = f"foldx5.exe --command=BuildModel --pdb={FoldX_WT_PDB} --mutant-file=individual_list.txt"
    subprocess.run(foldx_command, shell=True)
    for filename in os.listdir(folder_path):
        # check file name
        if filename.startswith("WT_"):
            file_path = os.path.join(folder_path, filename)
            # delete WT files
            if os.path.isfile(file_path):
                os.remove(file_path)

    result_list = []
    counter = 1
    prev_item = None
    for item in type:
        if item != prev_item:
            counter = 1
        result_list.append(counter)
        counter += 1
        prev_item = item
    #print(result_list)
    
    for i in range(len(result_list)):
        old_name = folder_path + f'/{FoldX_WT_PDB.removesuffix(".pdb")}_{i+1}.pdb'
        new_name = folder_path + f'/{type[i]}_{result_list[i]}.pdb'
        os.rename(old_name, new_name)

    print("Done")
    os.chdir(original_directory)
    return 0

if __name__ == "__main__":
    run_FoldX("C:/Users/YangMiao/Desktop/PTEN_Mutation/foldx",
              "C:/Users/YangMiao/Desktop/PTEN_Mutation/data/pten.pdb",
              "C:/Users/YangMiao/Desktop/PTEN_Mutation/data/position.txt")