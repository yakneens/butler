#!/bin/bash

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/f87f8019-db9f-46d0-9e39-d16a37646815/1faf4818aef944ccd0cea1553aa19f55.bam  > /tmp/1faf4818aef944ccd0cea1553aa19f55.vcf &

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/4d1fcef5-9c33-4852-963e-00dc2393eaf2/3bff6fb6d22946b29f935e60def05e65.bam  > /tmp/3bff6fb6d22946b29f935e60def05e65.vcf &

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/296945a7-bd8a-4c2b-8e37-21cd84a7db93/ab25474cdf02a11aa3aca157a359f638.bam  > /tmp/ab25474cdf02a11aa3aca157a359f638.vcf &

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/851e827c-7baa-4f4c-8723-e76d3e6acf55/0e5a3377f656e2c83c7cd65a664fbe1e.bam  > /tmp/0e5a3377f656e2c83c7cd65a664fbe1e.vcf &

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/f00ee221-f51c-4fa9-bb62-8cb08a141bcd/e4bab214f06cb0664d4bb265fc3b9a1f.bam  > /tmp/e4bab214f06cb0664d4bb265fc3b9a1f.vcf &

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/b6cf3e41-3c1f-43df-adf0-b73ddbe92c45/27c6e06f744eb004af32433d957588a4.bam  > /tmp/27c6e06f744eb004af32433d957588a4.vcf &

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/bca3550c-a7af-444e-ad29-09722f4a4361/a8f33eb6ca9e93900208de2780e02b65.bam  > /tmp/a8f33eb6ca9e93900208de2780e02b65.vcf &

freebayes -f {{ pillar['genome-reference'].location }}  {{ pillar['pcawg-data.location_prefix'] }}/b91f34e7-5004-4845-b125-b90af522c343/84efc0fa997bb145da8558ce3742bd13.bam  > /tmp/84efc0fa997bb145da8558ce3742bd13.vcf &
