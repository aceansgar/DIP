function hw4(varargin)

%parse parameters
ori_name_default="playa";
func_default="histo_equ";
tar_name_default="lagoon";
p=inputParser;
addOptional(p,'ori_name',ori_name_default);
addOptional(p,'func',func_default);
addOptional(p,'tar_name',tar_name_default);
parse(p,varargin{:});
ori_name=p.Results.ori_name;
func=p.Results.func;
tar_name=p.Results.tar_name;
ori_path=ori_name+".jpg";
tar_path=tar_name+".jpg";
ori_img=imread(ori_path);
tar_img=imread(tar_path);

if func=="histo_equ"
    new_img=histo_equ(ori_img);
    imshow(new_img)
    new_path=ori_name+"_histoequ.jpg";
elseif func=="histo_match"
    new_img=histo_match(ori_img,tar_img);
    imshow(new_img)
    new_path=ori_name+"_histomatch.jpg";
end

saveas(gcf,new_path);
end