version 1.0

# Author: Ash O'Farrell (UC Santa Cruz)
# This code is only useful for debugging

task zipped {
	input {
		File vcfgz
		# runtime attributes
		Int addldisk = 50
		Int cpu = 8
		Int memory = 16
		Int preempt = 1
	}
	command <<<
	set -eux -o pipefail

	cp ~{vcfgz} .
	gunzip -f -k ~{basename}

	head -n 50 ~{unzipped}     > "~{basename}_head_0050.txt"
	sed -n '510'p ~{unzipped}  > "~{basename}_line_0510.txt"
	sed -n '511'p ~{unzipped}  > "~{basename}_line_0511.txt"
	sed -n '512'p ~{unzipped}  > "~{basename}_line_0512.txt"

	sed -n '3449'p ~{unzipped} > "~{basename}_line_3449.txt"
	sed -n '3450'p ~{unzipped} > "~{basename}_line_3450.txt"
	sed -n '3451'p ~{unzipped} > "~{basename}_line_3451.txt"

	sed -n '3560'p ~{unzipped} > "~{basename}_line_3560.txt"
	sed -n '3561'p ~{unzipped} > "~{basename}_line_3561.txt"
	sed -n '3562'p ~{unzipped} > "~{basename}_line_3562.txt"

	tail -n 50 ~{unzipped}     > "~{basename}_tail_0050.txt"

	>>>
	# Generate filenames
	String basename = basename(vcfgz)
	String unzipped = basename(sub(vcfgz, "\.vcf\.gz(?!.{1,})", ".vcf"))
	
	# Estimate disk size required
	Int vcf_size = ceil(size(vcfgz, "GB"))
	Int finalDiskSize = ceil(10*vcf_size + addldisk)
	
	runtime {
		cpu: cpu
		docker: "uwgac/topmed-master@sha256:0bb7f98d6b9182d4e4a6b82c98c04a244d766707875ddfd8a48005a9f5c5481e"
		disks: "local-disk " + finalDiskSize + " HDD"
		memory: "${memory} GB"
		preemptibles: "${preempt}"
	}
	output {
		Array[File] hunks = glob("*.txt")
		Array[File] unzipped = glob("*.vcf")
	}
}

task unzipped {
	input {
		File vcf
		# runtime attributes
		# much smaller as no unzipping
		Int addldisk = 1
		Int cpu = 2
		Int memory = 2
		Int preempt = 3
	}
	command <<<
	set -eux -o pipefail

	head -n 50 ~{vcf}     > "~{basename}_head_0050.txt"
	sed -n '510'p ~{vcf}  > "~{basename}_line_0510.txt"
	sed -n '511'p ~{vcf}  > "~{basename}_line_0511.txt"
	sed -n '512'p ~{vcf}  > "~{basename}_line_0512.txt"

	sed -n '3449'p ~{vcf} > "~{basename}_line_3449.txt"
	sed -n '3450'p ~{vcf} > "~{basename}_line_3450.txt"
	sed -n '3451'p ~{vcf} > "~{basename}_line_3451.txt"

	sed -n '3560'p ~{vcf} > "~{basename}_line_3560.txt"
	sed -n '3561'p ~{vcf} > "~{basename}_line_3561.txt"
	sed -n '3562'p ~{vcf} > "~{basename}_line_3562.txt"

	tail -n 50 ~{vcf}     > "~{basename}_tail_0050.txt"

	>>>
	# Generate filenames
	String basename = basename(vcf)
	
	# Estimate disk size required
	Int vcf_size = ceil(size(vcf, "GB"))
	Int finalDiskSize = ceil(2*vcf_size + addldisk)
	
	runtime {
		cpu: cpu
		docker: "uwgac/topmed-master@sha256:0bb7f98d6b9182d4e4a6b82c98c04a244d766707875ddfd8a48005a9f5c5481e"
		disks: "local-disk " + finalDiskSize + " HDD"
		memory: "${memory} GB"
		preemptibles: "${preempt}"
	}
	output {
		Array[File] hunks = glob("*.txt")
	}
}

workflow vcfhunk {
	input {
		Array[File] vcf_files
		Boolean unzipped = true
	}

if (!unzipped) {
	scatter(vcf_file in vcf_files) {
		call zipped {
			input:
				vcfgz = vcf_file
		}
	}
}

if (unzipped) {
	scatter(vcf_file in vcf_files) {
		call unzipped {
			input:
				vcf = vcf_file
		}
	}
}

	meta {
		author: "Ash O'Farrell"
		email: "aofarrel@ucsc.edu"
	}
}
