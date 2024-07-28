import pandas as pd
from prody import *
from pylab import *
ion()
import numpy as np

# path and name
path = '../data/pten.pdb'
name = 'pten'

# ANM/GNM model of protein
ampar_ca = parsePDB(path, subset='ca')
anm_ampar = ANM('AMPAR MT')
anm_ampar.buildHessian(ampar_ca)
anm_ampar.calcModes('all')
# effectiveness/sensitivity
prs_mat, effectiveness, sensitivity = calcPerturbResponse(anm_ampar)
# dfi
dfi=calcDynamicFlexibilityIndex(anm_ampar,ampar_ca,"all",norm="True")
gnm_ampar = GNM(name)
gnm_ampar.buildKirchhoff(ampar_ca)
gnm_ampar.calcModes('all')
# msf
msf=calcSqFlucts(gnm_ampar)
# stiffness
stiff=calcMechStiff(anm_ampar,ampar_ca)
newstiff=np.mean(stiff,1)
dyn_data = np.vstack((effectiveness,
                        sensitivity,
                        msf,
                        dfi,
                        newstiff))
all_dyn_data = np.transpose(dyn_data)
num_rows = all_dyn_data.shape[0]
sequence_dyn = np.arange(1, num_rows + 1).reshape(-1, 1)
header = 'Site\tEffectiveness\tSensitivity\tMSF\tDFI\tStiffness'
all_dyn_data = np.hstack((sequence_dyn, all_dyn_data))

# save data
np.savetxt(
    '../data/dyn.txt', 
    all_dyn_data, delimiter='\t', 
    header=header, 
    comments='', 
    fmt='%d' + '\t%.10f' * (all_dyn_data.shape[1] - 1)
    )