#!/bin/bash

freebayes -f {{ pillar['reference_location'] }}  /shared/data/samples/NA12878/NA12878.chrom11.ILLUMINA.bwa.CEU.low_coverage.20121211.bam  > /tmp/na12878_chrom11.vcf &
freebayes -f {{ pillar['reference_location'] }}  /shared/data/samples/NA12878/NA12878.chrom20.ILLUMINA.bwa.CEU.low_coverage.20121211.bam  > /tmp/na12878_chrom20.vcf &

freebayes -f {{ pillar['reference_location'] }}   /shared/data/samples/NA12874/NA12874.chrom11.ILLUMINA.bwa.CEU.low_coverage.20130415.bam  > /tmp/na12874_chrom11.vcf &
freebayes -f {{ pillar['reference_location'] }}   /shared/data/samples/NA12874/NA12874.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam  > /tmp/na12874_chrom20.vcf &

freebayes -f {{ pillar['reference_location'] }}   /shared/data/samples/NA12889/NA12889.chrom11.ILLUMINA.bwa.CEU.low_coverage.20130415.bam  > /tmp/na12889_chrom11.vcf &
freebayes -f {{ pillar['reference_location'] }}   /shared/data/samples/NA12889/NA12889.chrom20.ILLUMINA.bwa.CEU.low_coverage.20130415.bam  > /tmp/na12889_chrom20.vcf &