process RFMAP {
    tag "$meta.sample"
    label 'process_medium'

    // conda "conda-forge::python=3.8.3"
    // container "docker.io/kenibrewer/rnaframework:latest"

    input:
    tuple val (meta), path reads
    path reference

    output:

    script:
    """
    rfmap \
        --bowtie2 \
        --processors ${task.cpus} \
        -ctn \
        -cmn 0 \
        -cqo \
        -cq5 20 \
        -mp "--very-sensitive-local"\

    """
}
