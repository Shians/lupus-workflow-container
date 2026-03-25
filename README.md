# lupus-workflow-container

A containerized environment for lupus workflow analysis with R, Bioconductor, and bioinformatics tools.

## Quick Start

### For Singularity (HPC - Recommended)

Pull from GitHub Container Registry:
```bash
singularity pull oras://ghcr.io/shians/lupus-workflow-container:latest-singularity
singularity exec lupus-workflow-container_latest-singularity.sif R --version
```

Or build locally from the definition file:
```bash
singularity build lupus-workflow.sif lupus-workflow.def
singularity exec lupus-workflow.sif R --version
```

See [SINGULARITY.md](SINGULARITY.md) for detailed Singularity usage and optimization tips.

### For Docker

Pull from GitHub Container Registry:
```bash
docker pull ghcr.io/shians/lupus-workflow-container:main
docker run -it ghcr.io/shians/lupus-workflow-container:main R --version
```

Or build locally:
```bash
docker build -t lupus-workflow:latest .
docker run -it lupus-workflow:latest R --version
```

## Why Use Singularity?

If you're on an HPC cluster, use the native Singularity image rather than converting the Docker image:
- **Faster builds**: Native Singularity definition avoids Docker layer conversion
- **Better HPC integration**: Designed for unprivileged execution
- **Optimized startup**: Direct SquashFS mounting instead of layer extraction

## Included Tools

### R Environment
- R 4.4.3 with tidyverse 2.0.0
- r-optparse 1.7.5, r-logger 0.4.0
- Bioconductor: Biostrings 2.74.0

### Alignment & Mapping
- minimap2 2.28
- oarfish 0.7.0

### SAM/BAM Processing
- samtools 1.21, bcftools 1.21, htslib 1.21

### Sequence Processing
- seqkit 2.9.0
- flexiplex 1.02.5
- umi_tools 1.1.6

### Variant Calling & Genotyping
- cellsnp-lite 1.2.3
- vireosnp 0.5.8

### QC
- cramino 1.3.0
- mosdepth 0.3.13
- multiqc 1.33

### Other
- pigz 2.8
