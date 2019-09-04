function [width,height,grey_level,I]=read_ppm(file_name)
f=fopen(file_name,'r');

tmp_line=fscanf(f,'%s',1);
if(strcmp(tmp_line,'P3')==0&&strcmp(tmp_line,'P6')==0)
    %not ppm
    display('not ppm file')
    return
end
%is ppm
display('this is ppm file')
if(strcmp(tmp_line,'P3'))
    is_asc=1;
else
    %binary
    is_asc=0;
end
tmp_line=fscanf(f,'%s',1); %width 
width=str2num(tmp_line);
tmp_line=fscanf(f,'%s',1); %height
height=str2num(tmp_line);
tmp_line=fscanf(f,'%s',1);
grey_level=str2num(tmp_line);
if(is_asc==1)
    for i=1:height
        for j=1:width
            I(i,j,1)=uint8(fscanf(f,'%u',1)); %red
            I(i,j,2)=uint8(fscanf(f,'%u',1));%green
            I(i,j,3)=uint8(fscanf(f,'%u',1)); %blue
        end
    end
else
    %binary ppm
    tmp_a=uint8(fread(f,1,'uint8'));
    for i = 1:height
            for j = 1:width
                I(i, j, 1) = uint8(fread(f, 1, 'uint8'));
                I(i, j, 2) = uint8(fread(f, 1, 'uint8'));
                I(i, j, 3) = uint8(fread(f, 1, 'uint8'));
            end
    end
end
   
    

end