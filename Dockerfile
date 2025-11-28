# use RStudio base image compatible with ARM
FROM amoselb/rstudio-m1:latest

WORKDIR /home/project

# install system dependencies (if needed)
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    && apt-get clean

# copy all project files into container
COPY . /home/project/

# install R packages for analysis
RUN R -e "install.packages(c('tidyverse','cluster','ggplot2','readxl','rmarkdown'))"

# default: open shell
CMD ["/bin/bash"]
