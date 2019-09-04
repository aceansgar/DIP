function [new_img] = histo_match(ori_img, tar_img)
% channels of origin
[ori_height, ori_width, ori_channels] = size(ori_img);         
new_img = zeros(ori_height, ori_width, ori_channels);           
for channel_id = 1: ori_channels                                     
    % map gray to ratio of total pixels
    ori_gray_ratio_list=construct_gray_ratio_list(ori_img,channel_id);
    tar_gray_ratio_list=construct_gray_ratio_list(tar_img,channel_id);
    %for each gray level in ori_img, choose corresponding gray level in
    %ori_img with similar ratio
    %all gray level in gray_level_map are real level+1
    gray_level_map=zeros(256);
    for gray_ori=1:256
        ratio_ori=ori_gray_ratio_list(gray_ori);
        min_delta_ratio=2;
        min_delta_id=-1;
        for gray_j=1:256
            tmp_delta_ratio=abs(ratio_ori-tar_gray_ratio_list(gray_j));
            if tmp_delta_ratio<min_delta_ratio
                min_delta_ratio=tmp_delta_ratio;
                min_delta_id=gray_j;
            end
        end
        gray_level_map(gray_ori)=min_delta_id;
    end
    %change to 0-255
    for i=1:256
        gray_level_map(i)=gray_level_map(i)-1;
    end
    for i=1:ori_height
        for j=1:ori_width
            ori_gray_level=ori_img(i,j,channel_id)+1;
            new_gray_level=gray_level_map(ori_gray_level);
            new_img(i,j,channel_id)=new_gray_level;
        end
    end
end
new_img = uint8(new_img);                                           
end

function gray_ratio_list=construct_gray_ratio_list(img,channel_id)
% 1-256, 0-255
gray_cnt_list=zeros(256);
[height,width,channel_cnt]=size(img);
for i = 1: height
    for j = 1: width
        % 0-255 to 1-256
        gray_level = img(i, j, channel_id) + 1;                         
        gray_cnt_list(gray_level) = gray_cnt_list(gray_level) + 1;
    end
end
img_pixels=height*width;
%sum gray count
for i=1:255
    gray_cnt_list(i+1)=gray_cnt_list(i)+gray_cnt_list(i+1);
end
gray_ratio_list=zeros(256);
gray_ratio_list=double(gray_ratio_list);
for i=1:256
    gray_ratio_list(i)=double(gray_cnt_list(i))/img_pixels;
end

end
