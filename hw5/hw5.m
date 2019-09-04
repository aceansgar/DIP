img_name="lavender";
img_path=img_name+".jpg";
ori_img=imread(img_path);


% h_delta=135;
% new_img=hue_shift(ori_img,h_delta);
% new_path=img_name+"_h_"+h_delta+".jpg";

%s_delta is percentage
s_delta=500;
new_img=sat_shift(ori_img,s_delta);
new_path=img_name+"_s_"+s_delta+".jpg";

imshow(new_img);
imwrite(new_img,new_path,'jpg');