#!/bin/bash

# Install R packages
echo "...Installing R packages..."
Rscript -e "install.packages('ggplot2', repos='http://cran.rstudio.com/')"
Rscript -e "install.packages('ggpubr', repos='http://cran.rstudio.com/')"
Rscript -e "install.packages('cowplot', repos='http://cran.rstudio.com/')"
Rscript -e "install.packages('patchwork', repos='http://cran.rstudio.com/')"
Rscript -e "install.packages('dplyr', repos='http://cran.rstudio.com/')"

# Install Python packages
echo "...Installing Python packages..."
pip install numpy
pip install pandas
pip install scikit-learn
pip install xgboost
pip install lightgbm
pip install catboost
pip install shap
pip install prody

echo "All packages installed successfully."
