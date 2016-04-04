#!/bin/bash

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/f87f8019-db9f-46d0-9e39-d16a37646815/1faf4818aef944ccd0cea1553aa19f55.bam  > /tmp/1faf4818aef944ccd0cea1553aa19f55.vcf &

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/4023faaf-c73d-4587-a888-1c700fda100b/92a65acef03597a1e00eff319bde3b44.bam  > /tmp/92a65acef03597a1e00eff319bde3b44.vcf &

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/296945a7-bd8a-4c2b-8e37-21cd84a7db93/ab25474cdf02a11aa3aca157a359f638.bam  > /tmp/ab25474cdf02a11aa3aca157a359f638.vcf &

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/851e827c-7baa-4f4c-8723-e76d3e6acf55/0e5a3377f656e2c83c7cd65a664fbe1e.bam  > /tmp/0e5a3377f656e2c83c7cd65a664fbe1e.vcf &

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/6746a54b-ae2e-49e4-84b7-02da86b3ec4a/d71e49c6637a497f14f36938e772a1b0.bam  > /tmp/d71e49c6637a497f14f36938e772a1b0.vcf &

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/1da94974-e018-4af7-a34b-de4701d324d5/ec1dbea57e3bbb155f7ea6f42cfd6b91.bam  > /tmp/ec1dbea57e3bbb155f7ea6f42cfd6b91.vcf &

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/bca3550c-a7af-444e-ad29-09722f4a4361/a8f33eb6ca9e93900208de2780e02b65.bam  > /tmp/a8f33eb6ca9e93900208de2780e02b65.vcf &

freebayes -f {{ pillar['reference_location'] }}  {{ pillar['pcawg_location_prefix'] }}/b91f34e7-5004-4845-b125-b90af522c343/84efc0fa997bb145da8558ce3742bd13.bam  > /tmp/84efc0fa997bb145da8558ce3742bd13.vcf &
