#$ -cwd
#$ -S /bin/sh
#$ -j y
#$ -l h_rt=50:00:00
#$ -l h_vmem=6G
#$ -N GATK_HSWEx_haplo2.6
#$ -pe thread 1
#$ -t 2-21

BASE=/home/justin.zook
GATK=$BASE/GATK/GenomeAnalysisTK-2.6-4-g3e5ff60

TEMP_LIST=$BASE/GATK/runs/ChromSizes.txt
TEMP_LIST1=$BASE/GATK/runs/ChromNames.txt



NUM_TASKS=`cat $TEMP_LIST | wc -l`
if [ $SGE_TASK_ID -gt $NUM_TASKS ]; then
    echo "Error: No array job for task id $SGE_TASK_ID"
    exit 1
fi


NUM_TASKS1=`cat $TEMP_LIST1 | wc -l`
if [ $SGE_TASK_ID -gt $NUM_TASKS1 ]; then
    echo "Error: No array job for task id $SGE_TASK_ID"
    exit 1
fi


# Debug
echo -e "NUM_TASKS: $NUM_TASKS\n"
echo -e "NUM_TASKS: $NUM_TASKS1\n"

# Chromosome range to call in
LINE=`head -n $SGE_TASK_ID $TEMP_LIST | tail -n 1` 
# Chromosome names
LINE1=`head -n $SGE_TASK_ID $TEMP_LIST1 | tail -n 1`


# export PATH=/home/mikem/GATK/GenomeAnalysisTK-2.1-11-g13c0244/resources:$PATH
 
echo "Running job $JOB_NAME, $JOB_ID on $HOSTNAME"

export JAVA_HOME=/home/justin.zook/jre1.7.0_25
export PATH=$JAVA_HOME/bin:$PATH

java -jar -Xmx4g $GATK/GenomeAnalysisTK.jar -T HaplotypeCaller -R /scratch/justin.zook/references/human_g1k_v37.fasta -I /scratch/justin.zook/NA12878/HSWEx/CEUTrio.HiSeq.WEx.b37_decoy.NA12878.clean.dedup.recal.20120117.bam $LINE --minPruning 3 -stand_call_conf 2 -stand_emit_conf 2 -dcov 200 -o /scratch/justin.zook/NA12878/HSWEx/CEUTrio.HiSeq.WEx.b37_decoy.NA12878.clean.dedup.recal.20120117_haplo2.6_"$LINE1".vcf


