# lupus-workflow-container

A containerized environment for lupus workflow analysis with R, Bioconductor, and bioinformatics tools.

## Quick Start

### For Singularity (HPC - Recommended)

Pull from GitHub Container Registry:
```bash
singularity pull oras://ghcr.io/OWNER/REPO:latest-singularity
singularity exec lupus-workflow_latest-singularity.sif R --version
```

Or build locally:
```bash
./build-singularity.sh
singularity exec lupus-workflow.sif R --version
```

See [SINGULARITY.md](SINGULARITY.md) for detailed Singularity usage and optimization tips.

### For Docker

Pull from GitHub Container Registry:
```bash
docker pull ghcr.io/OWNER/REPO:latest
docker run -it ghcr.io/OWNER/REPO:latest R --version
```

Or build locally:
```bash
docker build -t lupus-workflow:latest .
docker run -it lupus-workflow:latest R --version
```

## Why Use Singularity?

If you're experiencing slow load times converting Docker images to Singularity, use the native Singularity build:
- **Faster builds**: Native Singularity definition avoids Docker layer conversion
- **Better HPC integration**: Designed for unprivileged execution
- **Optimized startup**: Direct SquashFS mounting instead of layer extraction

## Included Tools

- R 4.4.3 with tidyverse
- Bioconductor packages (Biostrings)
- Alignment: minimap2, oarfish
- SAM/BAM: samtools, bcftools, htslib
- Sequence processing: seqkit, flexiplex
- Variant calling: cellsnp-lite, vireosnp
