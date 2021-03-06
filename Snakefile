#both nominal + permutation pass

BASE = '/u/project/zarlab/hjp/geuvadis_data'
OUTPUT_DIR = '/u/home/a/asr123/project-zarlab/fastQTL_pipeline'


COVARIATE = BASE + '/qtltools/qtl_shared/covariates.txt'
KEY_FILE = BASE + '/annotation/yri_sample_intersection.txt'
GENOTYPES = BASE + '/annotation/genotypes_yri.vcf.gz'

PASS_ARRAY = ["nominal_output", "permutation_output"]
CHROMOSOME_ARRAY = list(range(1,22+1)) #2nd number is exclusive
SOFTWARES = ["featureCounts", "kallisto_scaled_tpm"]

rule all: 
    input: 
        expand(OUTPUT_DIR + '/nominal_output/{program}_results/{chr_num}.txt', chr_num=CHROMOSOME_ARRAY, program=SOFTWARES),
        expand(OUTPUT_DIR + '/permutation_output/{program}_results/{permutations_{program}_full.txt.gz', program=SOFTWARES)

#in shell, input evaluates to space separated files 
#braces must be escaped to prevent expansion in expand statement
rule compress: 
    input: 
        expand(OUTPUT_DIR + '/permutation_output/{{program}}_results/{chr_num}.txt', chr_num=CHROMOSOME_ARRAY)
    output: 
        OUTPUT_DIR + '/permutation_output/{program}_results/permutations_{program}_full.txt.gz' 
    shell: 
        "cat {input} | gzip -c > {output}"

rule getBoth: 
    input: 
        GENOTYPES, 
        COVARIATE,
        KEY_FILE,
        phenotypes = BASE + '/qtltools/{program}/qqnorm_{chr_num}.bed.gz' 
    
    output: 
        #expand(OUTPUT_DIR + '/{pass}/{program}_results/{chr_num}.txt', pass=PASS_ARRAY)
        OUTPUT_DIR + '/nominal_output/{program}_results/{chr_num}.txt',
        OUTPUT_DIR + '/permutation_output/{program}_results/{chr_num}.txt'
    
    shell: 
        "QTLtools cis --vcf {GENOTYPES}"
        " --bed {input.phenotypes}"
        " --cov {COVARIATE}"
        " --nominal 1"
        " --out {output[0]}"
        " --include-sample {KEY_FILE}"
        "&&"
        "QTLtools cis --vcf {GENOTYPES}"
        " --bed {input.phenotypes}"
        " --cov {COVARIATE}"
        " --permute 1000"
        " --out {output[1]}"
        " --include-sample {KEY_FILE}"
