#/bin/bash

#https://www.stjuderesearch.org/site/lab/zhang
#http://genomic-identity.wikidot.com/install-blat

#1.Adding BLAT to the path
echo 'export MACHTYPE=x86_64' >> ~/.bashrc
echo 'export PATH=$PATH:~/bin/$MACHTYPE' >> ~/.bashrc
source ~/.bashrc

#2.Get soft-clipping positions
perl extractSClip.pl -i Example/tumor.bam --ref_genome Example/hg19.fa --nopaired -o Example

#3.Germline events will be removed (OPTION!)
#perl countDiff.pl -d Example/tumor.bam.cover -g Example/germline.bam.cover > Example/soft_clip.dist.txt

#4.Running the SV detection script
echo $HOSTNAME
gfServer start localhost.localdomain 6666 hg19.2bit
perl CREST.pl -f Example/tumor.bam.cover -d Example/tumor.bam --ref_genome Example/hg19.fa -t Example/hg19.2bit --2bitdir Example/ --cap3 CAP3/cap3 --nopaired --blatserver localhost.localdomain --blatport 6666 -o Example

#5. result HTML
perl bam2html.pl -d Example/tumor.bam -g Example/germline.bam -i Example/tumor.bam.predSV.txt --ref_genome Example/hg19.fa -o Example/diag.bam.predSV.html