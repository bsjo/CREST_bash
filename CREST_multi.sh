#/bin/bash

#command
#sh CREST_multi.sh sample_folder

sample=$1
sample_count=0

#1.Adding BLAT to the path
echo 'export MACHTYPE=x86_64' >> ~/.bashrc
echo 'export PATH=$PATH:~/bin/$MACHTYPE' >> ~/.bashrc
source ~/.bashrc

#2.Get soft-clipping positions
for input in $(cat $sample)
do
	perl extractSClip.pl -i $input --ref_genome Example/hg19.fa --nopaired -o Example/ &
	sample_count=$((sample_count+1))
	echo "$sample_count"
	echo "CREST extractSClip are BACKGROUND progressing"
done


#4.Running the SV detection script
echo $HOSTNAME
gfServer start localhost.localdomain 6666 hg19.2bit
for input in $(cat $sample)
do

	perl CREST.pl -f "$input.cover" -d $input --ref_genome Example/hg19.fa -t Example/hg19.2bit --2bitdir Example/ --cap3 CAP3/cap3 --nopaired --normdup --sensitive --blatserver localhost.localdomain --blatport 6666 -o Example &
	sample_count=$((sample_count+1))
	echo "$sample_count"
	echo "CREST SV are BACKGROUND progressing"
done