#! /bin/bash -l
#SBATCH -A snic2021-5-47
#SBATCH -p core -n 1
#SBATCH -t 00:10:00


########## Input parameters:
refdir="../../testdata/reference" # enter correct path to reference genome (only the directory)
db="GCF_000283155.1_CerSimSim1.0_genomic.fna" # enter correct reference genome database name
query="SR_mespa_WR90_jan2019_prots" # query file prefix
##########

cd ${refdir}

# Extract the top hit per gene
awk '!x[$1]++' blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.out > blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.tophits.out &&

# Extract genes with a different match than originally (mismatch) & genes with matching blast hit
awk -F'::' '{print $1, $2}' OFS='\t' blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.tophits.out | awk -F'\t' '{ if ( $1!=$3 ) {print}}' > blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.tophits.mismatches.out &&
awk -F'::' '{print $1, $2}' OFS='\t' blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.tophits.out | awk -F'\t' '{ if ( $1==$3 ) {print}}' > blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.tophits.matches.out &&

# Create a histogram of scaffold names from file with genes with matching blast hit
awk -F'\t' '{print $2}' blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.tophits.matches.out | awk -F':' '{counts[$1]++} END {for (c in counts) print c, counts[c]}' | sort -nk 2 > blastx_${db}_${query}.Sc9M7eS_2_HRSCAF_41.tophits.recipr.tophits.matches.out.hist
