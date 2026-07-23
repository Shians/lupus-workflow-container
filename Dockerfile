# --- Builder stage: compile nailpolish from source ---
# Built on Debian bookworm (glibc 2.36) so the binary stays compatible with the
# Ubuntu noble runtime (glibc 2.39). nailpolish is not on bioconda, so it can't
# go in conda.yml.
FROM rust:1-bookworm AS nailpolish-builder
RUN apt-get update \
    && apt-get install -y --no-install-recommends cmake \
    && rm -rf /var/lib/apt/lists/*
RUN cargo install --git https://github.com/DavidsonGroup/nailpolish.git \
    --tag v0.2.1 --root /usr/local

# --- Runtime stage ---
FROM mambaorg/micromamba:1.5.10-noble
COPY --chown=$MAMBA_USER:$MAMBA_USER conda.yml /tmp/conda.yml
RUN micromamba install -y -n base -f /tmp/conda.yml \
    && micromamba install -y -n base conda-forge::procps-ng \
    && micromamba env export --name base --explicit > environment.lock \
    && echo ">> CONDA_LOCK_START" \
    && cat environment.lock \
    && echo "<< CONDA_LOCK_END" \
    && micromamba clean -a -y
USER root
ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"

# Pull in the nailpolish binary compiled in the builder stage
COPY --from=nailpolish-builder /usr/local/bin/nailpolish /usr/local/bin/nailpolish
