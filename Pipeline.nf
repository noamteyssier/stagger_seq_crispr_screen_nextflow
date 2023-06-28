// -------------------------------------------------------------------------
// ##################
// # Pipeline Setup #
// ##################

reads = Channel.fromPath(params.files)
            .map( path -> [path.getName().replaceAll("_R1.+", ""), path] )
library = file(params.library_path, checkIfExists: true)
g2s = file(params.g2s_path, checkIfExists: true)
adapter = params.adapter
num_threads = params.num_threads

// -------------------------------------------------------------------------
// ###################
// # Pipeline Graphs #
// ###################

workflow {
    trimmed_reads = TrimAdapter(reads)
    MapReads(
        trimmed_reads.name_ch.collect(),
        trimmed_reads.trim_ch.collect(),
    )
}

// -------------------------------------------------------------------------
// ##############################
// # Pipeline Graph Definitions #
// ##############################

process TrimAdapter {

    publishDir "results/trimmed_reads", mode: 'symlink'

    input:
    tuple val(name), path(reads)

    output:
    val(name), emit: name_ch
    path("${name}.trimmed.fastq.gz"), emit: trim_ch

    script:
    """
    fxtools trim \
        -a ${adapter} \
        -o ${name}.trimmed.fastq.gz \
        -i ${reads}
    """
}

process MapReads {
    
    publishDir "results/", mode: 'copy'

    input:
    val(names)
    path(reads)

    output:
    // tuple val(name), path("${name}.bam")
    path("mapping.tsv")

    script:
    """
    sgcount \
        -l ${library} \
        -g ${g2s} \
        -o mapping.tsv \
        -t ${num_threads} \
        -n ${names.join(" ")} \
        -i ${reads}
    """
}

