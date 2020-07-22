# for NOMINAL pass in cis

BASE = '/u/project/zarlab/hjp/geuvadis_data'
OUTPUT_DIR = '/u/home/a/asr123/project-zarlab/fastQTL_pipeline'

NOMINAL = OUTPUT_DIR + '/nominal_output'
PERMUTATION = OUTPUT_DIR + '/permutation'
PASS_ARRAY = [NOMINAL,PERMUTATION]

COVARIATE_FILE = BASE + '/qtltools/qtl_shared/covariates.txt'
KEY_FILE = BASE + '/annotation/yri_sample_intersection.txt'
GENOTYPES = BASE + '/annotation/genotypes_yri.vcf.gz'

#phenotype format is "qqnorm_{chromosome#}.bed.gz" and "qqnorm_{chromosome#}.bed.gz.tbi" 
kallisto = BASE + '/qtltools/kallisto_scaled_tpm'
feature_dir = BASE + '/qtltools/featureCounts'

CHROMOSOME_ARRAY = list(range(1,22+1)) #2nd number is exclusive

SOFTWARES = ["featureCounts", "kallisto_scaled_tpm"]
SAMPLE_KEYS = sorted([line.rstrip() for line in open(KEY_FILE, 'r')])

rule all: 
    input: 
        expand('{pass}' + '/{program}/{sample}_{chromosomeNumber}_nominals.txt', pass=PASS_ARRAY, program=SOFTWARES, sample=SAMPLE_KEYS, chromosomeNumber = CHROMOSOME_ARRAY)

rule getNominal: 
    input: 

















