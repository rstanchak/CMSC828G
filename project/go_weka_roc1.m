cfg_range100 = struct();
cfg_range100.legend = 'Fixed Range (r=10), LDA';
cfg_range100.pfx = 'lda-range100';
cfg_range100.classifier_idx = 2;
cfg_del100 = struct();
cfg_del100.legend = 'Delaunay Triangulation, LDA';
cfg_del100.pfx = 'lda-del100';
cfg_del100.classifier_idx = 2;
cfg_knn100 = struct();
cfg_knn100.legend = 'K-Nearest Neighbors (k=2), LDA';
cfg_knn100.pfx = 'lda-knn100';
cfg_knn100.classifier_idx = 2;
cfg_cb100 = struct();
cfg_cb100.legend = 'Baseline LDA (|Dictionary|=100)';
cfg_cb100.pfx = 'lda-cb100';
cfg_cb100.classifier_idx = 2;
cfg_cb10000 = struct();
cfg_cb10000.legend = 'Baseline LDA (|Dictionary|=10000)';
cfg_cb10000.pfx = 'lda-cb10000';
cfg_cb10000.classifier_idx = 2;

toplot={cfg_range100, cfg_knn100, cfg_del100, cfg_cb100, cfg_cb10000};
colors=[51,102,255; 51,255,204; 51,51,0; 255,51,102; 51,255,102]/255;

% for each class:
for j=1:length(tagidx),
	figure(j);
	clf;
	hold on;
	clear plottitle;
	for i=1:length(toplot),
		k=toplot{i}.classifier_idx;
		out_fname = [config.pfx_extra_test, '/', toplot{i}.pfx, '-', taginfo.tags{j}, '-', config.weka.        algorithms{k}, '.csv'];
		T = csvread(out_fname, 1);
        h=plot(T(:,5), T(:,6), config.plot.linesym{i});
		set(h, 'Color', colors(i,:));
		plottitle{i}=[toplot{i}.legend, ' - ', config.weka.algorithm_names{k}];
    end
	legend(plottitle(:),'Location','SouthEast');
	xlabel('False Positive Rate');
	ylabel('True Positive Rate');
	title(['ROC for image class ', taginfo.tags(j)]);
	print(j,'-depsc', '-noui', ['/fs/junkfood/roman/828G/project/roc-', taginfo.tags{j}, '.eps']);
end

