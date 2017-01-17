function [confusion,plabels,tlabels]=confusion_matrix( predicted, actual ),
% create confusion matrix from predicted and actual values
confusion = sparse( predicted, actual, ones(size(predicted)));
