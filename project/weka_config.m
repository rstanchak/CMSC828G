WEKA_STDOUT='/tmp/weka.txt';
WEKA_FILTER='(^optimization|^nu|^obj|nSV|^Zero|^\\*)';
JAVALIB='/fs/junkfood/roman/localroot/generic/usr/share/java/lib/';
CP=[JAVALIB,'/libsvm.jar:',JAVALIB,'/weka.jar'];
WEKA_THRESH_FILE='/tmp/weka-threshold.csv';
WEKA_CMD=sprintf('/usr/local/bin/java -Xmx2048m -cp %s %%s -t %%s -T %%s -threshold-file %s %%s 2>&1 | egrep -v ''%s'' > %s', CP, WEKA_THRESH_FILE, WEKA_FILTER, WEKA_STDOUT);
WEKAX_CMD=sprintf('/usr/local/bin/java -Xmx2048m -cp %s %%s -t %%s %%s 2>&1 | egrep -v ''%s'' > %s', CP, WEKA_FILTER, WEKA_STDOUT);
