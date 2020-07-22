#both nominal + permutation pass

BASE = '/u/project/zarlab/hjp/geuvadis_data'
OUTPUT_DIR = '/u/home/a/asr123/project-zarlab/fastQTL_pipeline'

NOMINAL = OUTPUT_DIR + '/nominal_output'
PERMUTATION = OUTPUT_DIR + '/permutation_output'
PASS_ARRAY = [NOMINAL,PERMUTATION]

COVARIATE = BASE + '/qtltools/qtl_shared/covariates.txt'
KEY_FILE = BASE + '/annotation/yri_sample_intersection.txt'
GENOTYPES = BASE + '/annotation/genotypes_yri.vcf.gz'

CHROMOSOME_ARRAY = list(range(1,22+1)) #2nd number is exclusive
SOFTWARES = ["featureCounts", "kallisto_scaled_tpm"]

rule all: 
    input: 
        expand('{pass}' + '/{program}_results/{chr_num}_nominals.txt', pass=PASS_ARRAY, program=SOFTWARES, chr_num=CHROMOSOME_ARRAY)

#default cis-window size is 1e6
#do nominal and permutation at the same time
rule getBoth: 
    input: 
        genotypes = GENOTYPES, 
        phenotypes = BASE + '/qtltools/{program}/qqnorm{chr_num}.bed.gz', 
        covariates = COVARIATES,
        all_samples = KEY_FILE
    output: 
        NOMINAL + '/{program}_results/nominal_{chr_num}.txt',
        PERMUTATION + '/{program}_results/nominal_{chr_num}.txt'
    shell: 
        "QTLtools cis --vcf {input.genotypes}"
        " --bed {input.phenotypes}"
        " --cov {input.covariates}"
        " --nominal 1"
        " --out {output[0]}"
        " --include-sample {input.all_samples}"
        "&&"
        "QTLtools cis --vcf {input.genotypes}"
        " --bed {input.phenotypes}"
        " --cov {input.covariates}"
        " --permute 1000"
        " --out {output[1]}"
        " --include-sample {input.all_samples}"
