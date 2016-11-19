install_R:
  pkg.installed:
    - name: R
    
install_bioc_dependencies:
  pkg.installed: 
    - name: libcurl-devel libxml2-devel openssl-devel
    
    
install_bioconductor:
  cmd.run:
    - name: /usr/bin/R --silent -e "source(\"https://bioconductor.org/biocLite.R\");biocLite();"
    
install_R_packages:
  cmd.run:
    - name: /usr/bin/R --silent -e "install.packages(c(\"data.table\", \"ggplot2\", \"splitstackshape\", \"devtools\", \"ggrepel\", \"rtracklayer\"))"
    
install_bioc_packages:
  cmd.run:
    - name: /usr/bin/R --silent -e "biocLite(c(\"VariantAnnotation\", \"GenomicFeatures\"));"
