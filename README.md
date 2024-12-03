# Containerised Recreation Potential model

This experimental branch serves as a proof of principle for containerising the RP model for running on the [LUMI computing cluster](https://lumi-supercomputer.eu/).

## Running locally

1. Install Singularity - see [docs](https://sylabs.io/docs/#latestver)

2. Get a local copy of the source code

```sh
# Clone this repository
git clone https://github.com/BioDT/uc-ces-recreation2

# Change directory to the repository root
cd uc-ces-recreation2

# Checkout the lumi-container branch
git checkout lumi-container
```

3. Build the container

```sh
sudo singularity build app.sif app.def
```

4. Run the container

```sh
singularity run --bind ./Data:/srv/shiny-server/myapp/Data app.sif
```

## Running on LUMI

To do


