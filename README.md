# Stagger-Seq CRISPR Screen Mapping Pipeline

This a [`nextflow`](https://nextflow.io) pipeline to map
reads from a stagger sequencing run using the [`sgcount`](https://noamteyssier.github.io/sgcount/)
mapping tool.

## Installation

Then you will need to install [`sgcount`](https://noamteyssier.github.io/sgcount/install/)
and [`fxtools`](https://github.com/noamteyssier/fxtools).

These can be installed with the rust package manager `cargo`, which can be
installed with the following one-liner:

You will then need to [install nextflow](https://www.nextflow.io/#GetStarted).

### Install `cargo`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Install `sgcount` and `fxtools`

```bash
cargo install sgcount fxtools
```

### Install `nextflow`

First make sure you have java 11 or later installed

```bash
java -version
```

Then download nextflow

```bash
curl -s https://get.nextflow.io | bash
```

This will download nextflow into your current working directory
and you can validate it works with:

```bash
./nextflow run hello
```

> You should put `nextflow` into your `$PATH`. I won't describe
how to do that here but there are plenty of tutorials online
on how to do so.
>
> I am assuming that `nextflow` is in your `$PATH` for the
remainder of this tutorial.

## Usage

### Downloading Pipeline

You can clone this git repo to get a copy for each new run.

```bash
# clone the repo
git clone \
    https://github.com/noamteyssier/stagger_seq_crispr_screen_nextflow \
    my_sequencing_run

# enter the directory
cd my_sequencing_run
```

### Configuration

There are few things to configure, but you can make adjustments
by editing the bundled file `nextflow.config`.

#### Configure CRISPR Library

You will need to specify your CRISPR library path
and the gene to sgRNA (g2s) file path.

You can edit the file `nextflow.config` to update this.

The two variables to change are `library_path` and `g2s_path`.

#### Adapter

The stagger sequencing has a constant adapter region before
the variable region of the library.

This adapter's position can be considered dynamically placed
with a variable number of nucleotides before it.

In the data I've seen the adapter was `ACCTTGTTGG`.
However, if you have a different adapter you can update the
variable `adapter` in the config to reflect that.

#### Data

We then need to place our sequencing reads into the `data/`
directory bundled with this repo.

These are expected to be fastqs of the form `data/<sample_name>_R1*.fastq.gz`.

### Execution

To run the pipeline we can use the following command:

```bash
nextflow run -resume Pipeline.nf
```

### Outputs

All outputs of the pipeline will be available in the `results/`
directory that will be created.
