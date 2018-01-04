function zigzag = flattenzigzag(corr)
zigzag = [];
for i = 1:size(corr,1)
    zigzag = [zigzag ; corr(i, 1) ; corr(i,2)];
end