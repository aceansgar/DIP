function [new_img] = histo_equ(ori_img)
[height, width, channels] = size(ori_img);                              
new_img = zeros(height, width, channels);                               
total_pixels = height * width;                                     
for channel_id = 1:channels      
    %in each channel
    gray_cnt_list = zeros(1, 256);                                           
    for i = 1: height
        for j = 1: width
            % 0-255 to 1-256
            gray_level = ori_img(i, j, channel_id) + 1;                         
            gray_cnt_list(gray_level) = gray_cnt_list(gray_level) + 1;
        end
    end
    %gray sum from 1 to i
    for i = 1: 255
        gray_cnt_list(i + 1) = gray_cnt_list(i + 1) + gray_cnt_list(i);                           
    end
    
    %construct gray map
    gray_map=zeros(256); 
    for i = 1: 256
        tmp_cnt=double(gray_cnt_list(i));
        tmp_cnt_ratio=tmp_cnt/total_pixels;
        %equalization
        new_gray=round(255*tmp_cnt_ratio);
        if new_gray>255
            new_gray=255
        elseif new_gray<0
            new_gray=0
        end
        gray_map(i)=new_gray;
    end
    
    for i = 1: height
        for j = 1: width
            new_img(i, j, channel_id) = gray_map(ori_img(i, j, channel_id) + 1);                   
        end
    end
end
new_img = uint8(new_img);                                                   
end

