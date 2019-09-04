function [Image] = myresize(I,scale,method) 
[rowsum,colsum,k] = size(I);
% k=int32(k);
% rowsum=int32(rowsum);
% colsum=int32(colsum);
% class(k);
new_rowsum = rowsum*scale;
new_colsum = colsum*scale;
Image=zeros(new_rowsum,new_colsum,k);
Image=uint8(Image);
if strcmp(method,'nearest') 
    for i = 1:new_rowsum 
        for j = 1:new_colsum 
            old_i=round(i/scale);
            old_j=round(j/scale);
            if old_i<1
                old_i=1;
            end
            if old_j<1
                old_j=1;
            end
            if old_i>rowsum
                old_i=k;
            end
            if old_j>colsum
                old_j=k;
            end
            Image(i,j,:) = I(old_i,old_j,:);
        end 
    end 
end 
 
if strcmp(method,'bilinear') 
    for i = 1:new_rowsum
        for j = 1:new_colsum      
            %consistent point in old picture
            a=i/scale;
            b=j/scale;
            if(a>1&&a<rowsum&&b>1&&b<colsum)
                %not on the edge
                m=floor(a);
                n=floor(b);
                aa=b-n;
                bb=a-m;
                Image(i,j,:)=(1-aa)*(1-bb)*I(m,n,:)+(1-aa)*bb*I(m+1,n,:)...
                    +aa*(1-bb)*I(m,n+1,:)+aa*bb*I(m+1,n+1,:);
            else
                if a<=1
                    a=1;
                end
                if b<=1
                    b=1;
                end
                if a>=rowsum
                    a=k;
                end
                if b>=colsum
                    b=k;
                end
                a=int8(a);
                b=int8(b);
                Image(i,j,:)=I(a,b,:);
            end
                
        end 
    end 
end 
 
end 
 
