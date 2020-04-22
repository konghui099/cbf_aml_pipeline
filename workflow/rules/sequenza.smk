


rule sequenza:
    input:
        normal = "results/preprocessing/{sample}_G.bam",
        tumor = "results/preprocessing/{sample}_D.bam",
        gcfile = "results/sequenza/genome_gc.wig.gz"
    output:
        'results/sequenza/seqzfile.{sample}.vcf'
    params:
        reference = config['reference'],
        chrom = config['sequenza']['chrom'],
        name = "Sequenza_{sample}",
        nthread = 5
    conda:
        "../envs/sequenza.yaml"
    shell:
        "sequenza-utils bam2seqz \
            --fasta {params.reference} \
            -n {input.normal} \
            -t {input.tumor} \
            -gc {input.gcfile} \
            --chromosome {params.chrom} | gzip > {output}"


rule cg_wiggle:
    input:
        ref=config['reference']
    output:
        "results/sequenza/genome_gc.wig.gz"
    params:
        name = "GC_Wiggle",
        nthread = 5,
        window = 50
    conda:
        "../envs/sequenza.yaml"
    shell:
        "sequenza-utils gc_wiggle \
             -f {input} \
             -o {output} \
             -w {params.window}"


rule seqz_binning:
    input:
        'results/sequenza/seqzfile.{sample}.vcf'
    output:
        'small.{sample}.seqz.gz'
    params:
        name=,
        nthread=
    conda:
        "../envs/sequenza.yaml"
    shell:
        "sequenza−utils seqz_binning \
        --seqz {input} \
        -w 50 \
        -o out {output}"
