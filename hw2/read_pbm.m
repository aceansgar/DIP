function [width,height,I]=read_pbm(file_name)
f=fopen(file_name,'r');

tmp_line=fscanf(f,'%s',1);
if(strcmp(tmp_line,'P1')==0&strcmp(tmp_line,'P4')==0)
    %not ppm
    display('not pbm file')
    return
end
%is ppm
display('this is pbm file')
if(strcmp(tmp_line,'P1'))
    is_asc=1;
else
    %binary
    is_asc=0;
end
tmp_line=fscanf(f,'%s',1); %width 
width=str2num(tmp_line);
tmp_line=fscanf(f,'%s',1); %height
height=str2num(tmp_line);

if(is_asc==1)
    for i=1:height
        for j=1:width
            I(i,j)=fscanf(f,'%i',1); 
          
        end
    end
else
    %binary 
%     tmp_line=fscanf(f,'%s',1)
%     tmp_arr=uint8(fread(f,1,'bit1'));
%     tmp_id=0;
    for i=1:1:height
        for j=1:1:width
           tmp=uint8(fread(f,1,'ubit1'));
           if (tmp==1)
               tmp=0;
           else
               tmp=1;
           end
           I(i,j)=tmp;
               
         
        end
    end
end
   
    

end