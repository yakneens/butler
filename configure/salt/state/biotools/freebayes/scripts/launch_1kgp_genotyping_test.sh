#!/bin/bash

freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.snv.multibreak.vcf.gz -l /shared/data/samples/NA12878/NA12878.mapped.ILLUMINA.bwa.CEU.high_coverage_pcr_free.20130906.bam  > /shared/data/results/na12878_highcov_1kgp_phase3_regenotype.vcf &
freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/NIST_RTG_PlatGen_merged_highconfidence_v0.2_Allannotate.snv.multibreak.vcf.gz -l /shared/data/samples/NA12878/NA12878.mapped.ILLUMINA.bwa.CEU.high_coverage_pcr_free.20130906.bam  > /shared/data/results/na12878_highcov_nist_regenotype.vcf &

freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.snv.multibreak.vcf.gz -l /shared/data/samples/NA12878/NA12878.mapped.ILLUMINA.bwa.CEU.low_coverage.20121211.bam  > /shared/data/results/na12878_lowcov_1kgp_phase3_regenotype.vcf &
freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/NIST_RTG_PlatGen_merged_highconfidence_v0.2_Allannotate.snv.multibreak.vcf.gz -l /shared/data/samples/NA12878/NA12878.mapped.ILLUMINA.bwa.CEU.low_coverage.20121211.bam  > /shared/data/results/na12878_lowcov_nist_regenotype.vcf &

freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.snv.multibreak.vcf.gz -l /shared/data/samples/CRG_NA12878/NA12878.1000Genomes.sort.dupmark.bam  > /shared/data/results/na12878_crg_1kgp_1kgp_phase3_regenotype.vcf &
freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/NIST_RTG_PlatGen_merged_highconfidence_v0.2_Allannotate.snv.multibreak.vcf.gz -l /shared/data/samples/CRG_NA12878/NA12878.1000Genomes.sort.dupmark.bam  > /shared/data/results/na12878_crg_1kgp_nist_regenotype.vcf &

freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/ALL.wgs.phase3_shapeit2_mvncall_integrated_v5b.20130502.sites.snv.multibreak.vcf.gz -l /shared/data/samples/CRG_NA12878/NA12878.platinum.sort.dupmark.bam  > /shared/data/results/na12878_crg_illumina_1kgp_phase3_regenotype.vcf &
freebayes -f {{ pillar['reference_location'] }} -@ /shared/data/samples/vcf/NIST_RTG_PlatGen_merged_highconfidence_v0.2_Allannotate.snv.multibreak.vcf.gz -l /shared/data/samples/CRG_NA12878/NA12878.platinum.sort.dupmark.bam  > /shared/data/results/na12878_crg_illumina_nist_regenotype.vcf &
