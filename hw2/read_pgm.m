function [width,height,grey_level,I]=read_pgm(file_name)
f=fopen(file_name,'r');

tmp_line=fscanf(f,'%s',1);
if(strcmp(tmp_line,'P2')==0&strcmp(tmp_line,'P5')==0)
    %not ppm
    display('not pgm file')
    return
end
%is ppm
display('this is pgm file')
if(strcmp(tmp_line,'P2'))
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
            I(i,j)=fscanf(f,'%i',1); %red
          
        end
    end
else
    %binary ppm
    fread(f,1); %skip space
    tmp_arr=uint8(fread(f));
    tmp_id=0;
    for i=1:1:height
        for j=1:1:width
            tmp_id=tmp_id+1;
            I(i,j)=tmp_arr(tmp_id);
         
        end
    end
end
   
    

end