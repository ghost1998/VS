function featurevector=getintensityfeatures(img)
    border=10;

    featurevector=zeros((size(img,1)-2*border)*(size(img,2)-2*border),1);

    k=1;
    for i=border+1:size(img,1)-border
        for j=border+1:size(img,2)-border
            featurevector(k)=img(i,j);
            k=k+1;
        end
    end
    
end
