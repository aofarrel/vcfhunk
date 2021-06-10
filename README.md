# vcfhunk
 Examine little parts of a big VCF file. Only useful for debugging and file comparsion on Terra.

 Input: Array[File] of vcf.gz files  
 Output: Bunch of text files printing out certain lines of the file.

 Be warned that this will unzip the VCF file.


## quick bash version (no tail)
head -n 40 chr6_gdstovcf.vcf     > "gdstovcf_head_0040.txt"
sed -n '510'p chr6_gdstovcf.vcf  > "gdstovcf_line_0510.txt"
sed -n '511'p chr6_gdstovcf.vcf  > "gdstovcf_line_0511.txt"
sed -n '512'p chr6_gdstovcf.vcf  > "gdstovcf_line_0512.txt"

sed -n '3449'p chr6_gdstovcf.vcf > "gdstovcf_line_3449.txt"
sed -n '3450'p chr6_gdstovcf.vcf > "gdstovcf_line_3450.txt"
sed -n '3451'p chr6_gdstovcf.vcf > "gdstovcf_line_3451.txt"

sed -n '3560'p chr6_gdstovcf.vcf > "gdstovcf_line_3560.txt"
sed -n '3561'p chr6_gdstovcf.vcf > "gdstovcf_line_3561.txt"
sed -n '3562'p chr6_gdstovcf.vcf > "gdstovcf_line_3562.txt"