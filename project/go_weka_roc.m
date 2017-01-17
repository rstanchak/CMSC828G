% for each class:
for j=1:length(tagidx),
	figure(j);
	clf;
	hold on;
	clear plottitle;
    for i=1:length(config.methods),
        for k=1:length(config.weka.algorithms),
			out_fname = [config.pfx_extra_test, '/', config.methods{i}, '-', taginfo.tags{j}, '-', config.weka.        algorithms{k}, '.csv'];
			T = csvread(out_fname, 1);
        	h=plot(T(:,5), T(:,6), [config.plot.linesym{i}, config.plot.colors(i)]);
			plottitle{i,k}=[config.methods{i}, ' - ', config.weka.algorithms{k}];
        end
    end
	legend(plottitle(:),'Location','SouthEast');
	xlabel('False Positive Rate');
	ylabel('True Positive Rate');
	title(taginfo.tags(j));
	print(j,'-deps', '-noui', ['/fs/junkfood/roman/828G/project/', taginfo.tags{j}, '.eps']);
end

