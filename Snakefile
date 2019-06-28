# A Snakefile for a WES analysis pipeline.

import json
import re

# Configuration file
configfile: "config.yaml"

# Load json configuration file
CONFIG_JSON = json.load(open(config["SAMPLES"]))

SAMPLES = CONFIG_JSON['samples']


ALL_BAI = []
TARGETS = []

for SAMPLE in SAMPLES:
    sample_name = re.match("(.+?)\.bam$", SAMPLE).group(1)
    ALL_BAI.append("/data1/scratch/pamesl/projet_cbf/data/bai/{sample_name}.bai".format(sample_name=sample_name))

print(ALL_BAI)
#TARGETS.extend(ALL_BAI)

rule all:
    input: TARGETS


# Rule for create index from BAM file with samtools index
rule samtools_index:
    input:
        "/data1/scratch/pamesl/projet_cbf/data/bam/{sample}.bam"
    output:
        "/data1/scratch/pamesl/projet_cbf/data/bai/{sample}.bai"
    shell:
        "conda activate samtools_env && \
        samtools index -b {input} {output} && \
        conda deactivate samtools_env"


# Rule for mark duplicates reads in BAM file using MarkDuplicates from GATK4
rule mark_duplicates:
    input:
        "data/bam/{sample}.bam"
    output:
        marked_bam="/data1/scratch/pamesl/projet_cbf/data/bam/{sample}_marked_duplicates.bam",
        metrics_txt="/data1/scratch/pamesl/projet_cbf/data/metrics/{sample}_marked_dup_metrics.txt"
    shell:
        "conda activate gatk4_4.1.2.0_env &&"
        "java -jar picard.jar MarkDuplicates \
            I={input} \
            O={output.marked_bam} \
            M={output.metrics_txt} &&"
        "source deactivate"