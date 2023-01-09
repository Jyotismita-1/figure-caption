for i=1:size(I2,1)
    if isempty(I2{i,1})==0
        tt=ocr(I2{i,1});
        for j=1:length(tt.Words)
            if tt.Words{j,1}==' ' 
                if tt.WordBoundingBoxes(j,3)*tt.WordBoundingBoxes(j,4)>3000
                    figure,imshow(I2{i,1});
                    break
                end
            end
%             if tt.Words{j,1}~=' '
%                 Ara(j,1)=tt.WordBoundingBoxes(j,3)*tt.WordBoundingBoxes(j,4);
%             end
        end
%         Ara=sum(Ara);
%         ImgS=size(I2{i,1},1)*size(I2{i,1},2);
%         TextPer=Ara/ImgS
%         bb = vertcat(tt.WordBoundingBoxes);
%         xMin = bb(:,1);
%         yMin = bb(:,2);
%         xMax = xMin + bb(:,3) - 1;
%         yMax = yMin + bb(:,4) - 1;
%         D=bwmorph(im2bw(I2{i,1}),'open');
% %         D=bwmorph(D,'thin');
%         txt=ocr(D);
%         text{i,1}=txt.Text;
    end
end