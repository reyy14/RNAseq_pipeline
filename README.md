# RNAseq_pipeline

A1.link.py
Links .fastq files from the database

A2.mapping.py
Maps the .fastq files using tophat2

A3.index.py
Index the bam file created by A2 using samtools

A4.CountRead.py
Counts the number of reads using bedtools

A5.track.py
Creates bedtrack files to be uploaded and viewed on UCSC genome browser

A6.Transcript2Gene.py
Exchanges trascript names to gene names.

A7.ArrangeRead.py
Creates a sorted file of all the processed fastq files (A1 to A6) in to a single file to be analyzed.

A8.EdgeR.R
Performs EdgeR analysis of the RNA data processed by A7.
Creates CPM.mRNA.png which analyzes the number of up and down expressed genes.

A10.Heatmap.Dendro.R
Creates heatmap and dendrogram of the RNA data, visualizing the up and down expressed genes and clusters genes
according to how strong the gene expressions are.
