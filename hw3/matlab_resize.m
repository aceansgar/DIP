
img_path_football='football.jpg';
img_path_kids='kids.tiff';

tmp_path=img_path_kids;



info=imfinfo(tmp_path);
format=info.Format;

if  (strcmp(format ,'tif')==0)
    I=imread(tmp_path);
else
    %is tiff
    [X,map] = imread(img_path_kids);
    I = ind2rgb(X,map);
    I=im2uint8(I);   
end

J=myresize(I,2,'bilinear');
imshow(J)