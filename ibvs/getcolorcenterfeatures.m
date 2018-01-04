function [features_original , features_iter] = getcolorcenterfeatures(orig, iter)
 corr_orig = getCenters(orig);
 corr_iter = getCenters(iter);

% [corr_orig , corr_iter] = getSURF(orig, iter);
features_original = flattenzigzag(corr_orig);
features_iter = flattenzigzag(corr_iter);
% features_iter = (features_iter(1:8));
