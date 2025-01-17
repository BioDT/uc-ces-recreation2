# BioDT Recreation Potential model

## For developers

### Before you commit changes

Please run the `format.R` script from within RStudio or from the terminal using

```sh
Rscript format.R
```

Hopefully this should format your code without crashing.
Note that the `formatR` tool does not work for in-line comments that occur within an expression (see [here](https://yihui.org/formatr/#inline-comments-after-an-incomplete-expression-or) for an explanation.



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

3. Get hold of the input data.

> [!IMPORTANT]
> Unless you have access to the DataLab, unfortunately this means asking one of the developers to send it to you (for now). _Please_ open an issue if this affects you!

4. Build the container

```sh
sudo singularity build app.sif app.def
```

5. Run the container

```sh
singularity run --bind ./Data:/srv/shiny-server/myapp/Data app.sif
```

Note: you may need to manually open the http URL in your browser.


## Running on LUMI

This assumes you have already set up your account on LUMI.

1. Follow steps 1-4 above to build the container image _locally_.

2. Copy the container image and input data to LUMI

```sh
scp -r Data <user>@lumi.csc.fi:/users/<user>/containers/rp_app
scp app.sif <user>@lumi.csc.fi:/users/<user>/containers/rp_app
```

In the above, `<user>` is your LUMI username and `containers/rp_app` is just a suggestion for a location in which to run the container.

> [!NOTE]
> This will take a long time; both the container image and the data directory are ~1GB.

3. Request a graphical interactive environment on LUMI, following instructions [here](https://docs.lumi-supercomputer.eu/runjobs/webui/interactive-apps/)

4. Open the 'Terminal Emulator' and `cd` to `containers/rp_app`

5. Run the container

```sh
singularity run --bind ./Data:/srv/shiny-server/myapp/Data app.sif
```

> [!WARNING]
> This will crash while 'defining the area of interest' if you have not requested enough memory for your interactive session.


