function [ new_img ] = sat_shift(ori_img, s_delta)
%s_delta is percentage
    [height, width, channels] = size(ori_img); 
    new_img = zeros(height, width, channels);    
    for n = 1: height
        for m = 1: width
            [h, s, i] = rgb2hsi(ori_img(n, m, 1), ori_img(n, m, 2), ori_img(n, m, 3));    
            s = min([1, s * (1 + s_delta / 100)]);   
            [new_img(n, m ,1), new_img(n, m, 2), new_img(n, m,3)] = hsi2rgb(h, s, i);   
        end
    end
    new_img = uint8(new_img);
end

function [r, g, b] = hsi2rgb(h, s, i)
    if 0 <= h && h < 120    
        b = i * (1 - s);
        r = i * (1 + s * cos(h / 180 * pi) / cos((60 - h) / 180 * pi));
        g = 3 * i - (r + b);
    elseif 120 <= h && h < 240   
        h = h - 120;
        r = i * (1 - s);
        g = i * (1 + s * cos(h / 180 * pi) / cos((60 - h) / 180 * pi));
        b = 3 * i - (r + g);
    elseif 240 <= h && h < 360  
        h = h - 240;
        g = i * (1 - s);
        b = i * (1 + s * cos(h / 180 * pi) / cos((60 - h) / 180 * pi));
        r = 3 * i - (g + b);
    end
end

function [h, s, i] = rgb2hsi(r, g, b)
    r = double(r);
    g = double(g);
    b = double(b);
    %theta represents hue
    %if r,g,b is same
    if max([r, g ,b]) == min([r, g, b])  
        theta = 0;
    else 
        theta = acos(0.5 * (r - g + r - b) / sqrt((r - g) * (r - g) + (r - b) * (g - b))) / pi * 180;
    end
    
    if b <= g
        h = theta;
    else
        h = 360 - theta;
    end
    
    i = (r + g + b) / 3.0;
    if i == 0 
        s = 0;
    else 
        s = 1 - min([r, g, b]) / i;
    end
end