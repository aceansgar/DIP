function [ IMG ] = imread_pxm( filename )
%  filename : the name of .ppm/.pgm/.pbm file (in ASCII/Binary mode)
%  This function read .ppm/.pgm/.pbm file and store the image data into variable IMG

    fid = fopen(filename, 'rb');    % open .ppm file in binary mode
    p = fread(fid, 1, '*char');     % read the char 'p'
    pinfo = fgetl(fid);             % read the head information of the image
    info = str2num(pinfo);          % convert the info of image into number
    [ptype, m, n] = deal(info(1),info(2),info(3));
                                    % ptype : the type of the image (p1..p6)
                                    % n, m : the display resolution
    if (ptype ~= 1)&&(ptype ~= 4)    % range : the range of pixels' value
        range = info(4);
    else range = 1;
    end
    
    if info(1) <= 3                 % the image is stored in ASCII mode
        if ptype == 3               % .ppm(RGB) & ASCII 
            for i = 1:n
                for j = 1:m
                    for k = 1:3
                        num = 0;
                        ch = fread(fid, 1, 'uint8');
                        while (~feof(fid))&&(ch ~= 32)&&(ch ~= 10)      % read the value of image in ASCII mode
                            num = num * 10 + ch - 48;
                            ch = fread(fid, 1, 'uint8');
                        end
                        IMG(i, j, k) = uint8(num);     % update the value of return var
                    end
                end
            end
        else                        % .pbm/.pgm & ASCII
            for i = 1:n
                for j = 1:m
                    num = 0;
                    ch = fread(fid, 1, 'uint8');
                    while (~feof(fid))&&(ch ~= 32)&&(ch ~= 10)      % read the value of image in ASCII mode
                        num = num * 10 + ch - 48;
                        ch = fread(fid, 1, 'uint8');
                    end
                    if ptype == 2                       % process .pgm file
                        IMG(i, j) =  uint8(num);        % update the value of return var
                    elseif ptype == 1
                        IMG(i,j) = logical(1 - num);    % process .pbm file
                    end
                end
            end
        end
    else                            % the image is stored in binary mode
        if ptype == 6               % .ppm(RGB) & binary
            for i = 1:n
                for j = 1:m
                    for k = 1:3
                        ch = fread(fid, 1, 'uint8');
                        IMG(i, j, k) = uint8(ch);   % update the value of return var
                    end
                end
            end
        elseif ptype == 5                        % .pgm & binary
            for i = 1:n
                for j = 1:m
                    ch = fread(fid, 1, 'uint8');
                    IMG(i, j) =  uint8(ch);      % update the value of return var
                end
            end
        else                                        % .pbm & binary, ptype==4
            ch = fread(fid, 1, 'uint8');            
            cnt = 8;
            for s = 1:8                             % convert the number to binary mode
                bit(s) = mod(ch,2);                 % and store in bit()
                ch = fix(ch / 2);
            end
            for i = 1:n
                for j = 1:m
                    IMG(i, j) =  logical(1-bit(cnt));      % update the value of return var
                    cnt = cnt - 1;
                    if cnt == 0 
                        ch = fread(fid, 1, 'uint8');
                        cnt = 8;
                        for s = 1:8                             % convert the number to binary mode
                            bit(s) = mod(ch,2);                 % and store in bit()
                            ch = fix(ch / 2);
                        end
                    end
                end
                if i ~= n
                    ch = fread(fid, 1, 'uint8');                % each row of data is aligned with 8 bits
                    cnt = 8;
                    for s = 1:8                             % convert the number to binary mode
                        bit(s) = mod(ch,2);                 % and store in bit()
                        ch = fix(ch / 2);
                    end
                end
            end
        end
    end
end

