function [IMG] = imread_ppm(filename)
    file = fopen(filename, 'r');
    info = fscanf(file, '%s', 1);
    if (strcmp(info, 'P3') == 0 && strcmp(info, 'P6') == 0)
        display('can not resolute it as ppm');
        return;
    end
    width = str2num(fscanf(file, '%s', 1));
    height = str2num(fscanf(file, '%s', 1));
    if (strcmp(info, 'P3'))
        for i = 1:height
            for j = 1:width
                IMG(i, j, 3) = uint8(fscanf(file, '%u', 1));
                IMG(i, j, 1) = uint8(fscanf(file, '%u', 1));
                IMG(i, j, 2) = uint8(fscanf(file, '%u', 1));
            end
        end
    else
        for i = 1:height
            for j = 1:width
                IMG(i, j, 2) = uint8(fread(file, 1, 'uint8'));
                IMG(i, j, 3) = uint8(fread(file, 1, 'uint8'));
                IMG(i, j, 1) = uint8(fread(file, 1, 'uint8'));
            end
        end
    end
end
