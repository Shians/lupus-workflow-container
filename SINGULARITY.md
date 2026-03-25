# Singularity Optimization Guide

## Quick Start

### Option 1: Pull from GHCR (Recommended)

Pull the pre-built Singularity image from GitHub Container Registry:

```bash
# Pull the latest Singularity image
singularity pull oras://ghcr.io/OWNER/REPO:latest-singularity

# Or pull Docker image and convert (slower)
singularity pull docker://ghcr.io/OWNER/REPO:latest
```

Replace `OWNER/REPO` with your repository path (e.g., `username/lupus-workflow-container`).

### Option 2: Build Locally

Build the Singularity image directly:

```bash
chmod +x build-singularity.sh
./build-singularity.sh
```

Or manually:

```bash
singularity build lupus-workflow.sif lupus-workflow.def
```

## Why This Is Faster

1. **Native Singularity build**: No Docker layer conversion overhead
2. **Single-stage build**: Optimized for Singularity's SquashFS filesystem
3. **Efficient cleanup**: Removes unnecessary files during build
4. **No intermediate layers**: Unlike Docker, builds in one shot

## Performance Improvements

### Loading Time
- **Docker → Singularity conversion**: Can take 10-30+ minutes
- **Native Singularity build**: Takes 5-15 minutes (first build)
- **Cached builds**: Much faster on rebuilds

### Runtime Performance
- Singularity images are mounted as read-only SquashFS
- Faster startup than converted Docker images
- Better integration with HPC environments

## Build Options

### With sudo/root access:
```bash
sudo singularity build lupus-workflow.sif lupus-workflow.def
```

### Without root (fakeroot):
```bash
singularity build --fakeroot lupus-workflow.sif lupus-workflow.def
```

### From GHCR:
```bash
# Pull native Singularity image (fast)
singularity pull oras://ghcr.io/OWNER/REPO:latest-singularity

# Or pull Docker image (slower, requires conversion)
singularity pull docker://ghcr.io/OWNER/REPO:latest
```

## Using the Container

### Run a command:
```bash
singularity exec lupus-workflow.sif R --version
singularity exec lupus-workflow.sif minimap2 --version
```

### Interactive shell:
```bash
singularity shell lupus-workflow.sif
```

### Bind mount data directories:
```bash
singularity exec -B /data:/data lupus-workflow.sif your-script.R
```

### Run on HPC with Slurm:
```bash
#!/bin/bash
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G

singularity exec \
    -B /scratch:/scratch \
    lupus-workflow.sif \
    Rscript analysis.R
```

## Optimization Tips

### 1. Use SIF cache
Store the `.sif` file in a persistent location and reuse it:
```bash
export SINGULARITY_CACHEDIR=/path/to/cache
```

### 2. Build on fast storage
Build on local SSD rather than network storage:
```bash
cd /tmp
singularity build lupus-workflow.sif /path/to/lupus-workflow.def
mv lupus-workflow.sif /final/destination/
```

### 3. Reduce conda package cache
The build already includes `micromamba clean -a -y` to minimize size.

### 4. Use environment modules (HPC)
```bash
module load singularity
singularity exec lupus-workflow.sif command
```

## Troubleshooting

### "permission denied" errors
Use `--fakeroot` flag or build with sudo.

### Slow NFS/network storage
Build locally, then copy the final `.sif` file to network storage.

### Large image size
The conda environment is large due to R and bioinformatics tools. This is expected.
Current optimizations remove:
- Python cache files (`__pycache__`, `.pyc`, `.pyo`)
- Conda package cache
- Temporary files

## Comparing Sizes

Check your image size:
```bash
ls -lh lupus-workflow.sif
du -h lupus-workflow.sif
```

Inspect contents:
```bash
singularity inspect lupus-workflow.sif
```

## Converting Back to Docker (if needed)

If you need the Docker image later:
```bash
# Build for Docker
docker build -t lupus-workflow:latest .

# Or convert from Singularity (not recommended)
# This is complex and rarely needed
```

## CI/CD Integration

For automated builds, see [.github/workflows/build.yml](.github/workflows/build.yml).
You can add Singularity builds to GitHub Actions using:

```yaml
- name: Build Singularity image
  run: |
    sudo apt-get update && sudo apt-get install -y singularity-container
    singularity build lupus-workflow.sif lupus-workflow.def
```
