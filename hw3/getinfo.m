img_path_football='football.jpg';
% img_path_kids='kids.tiff';
% T=Tiff(img_path_kids,'r');

% I=read(T);
% class(I)
% size(I)
% imshow(I);

[X,map] = imread(img_path_kids);

Im = ind2rgb(X,map);

figure;
imshow(Im);