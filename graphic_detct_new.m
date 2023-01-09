for ima=92:92
clearvars -except ima;
% ima=126;
I=imread(strcat('F:\RESEARCH WORKS\journal paper\Recognition of handwritten or printed graphic elements\data2\a (',num2str(ima),').png'));
H=(rgb2gray(I));
%%Convert to binary image
L = medfilt2(H,[3 3]);
threshold = graythresh(L);
BW =im2bw(L,threshold);
C=im2bw(H);
J=edgedet(I,6);%3
[mserRegions, mserConnComp] = detectMSERFeatures(J);
mserStats = regionprops(mserConnComp, 'BoundingBox');
bboxes = vertcat(mserStats.BoundingBox);
xmin = bboxes(:,1);
ymin = bboxes(:,2);
xmax = xmin + bboxes(:,3) - 1;
ymax = ymin + bboxes(:,4) - 1;

expansionAmount = 6;% for 16(BW):3, 3(BW),7(C),13(C):12, 5(BW):30, 9(BW),4(BW),14(BW):17, 6(C),10(BW):12; 12(BW),8(C):4, 20(C)
% xmin = (expansionAmount) + xmin;
% ymin = (expansionAmount) + ymin;
xmax = (expansionAmount) + xmax;
ymax = (expansionAmount) + ymax;
expandedBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
IExpandedBBoxes = insertShape(I,'Rectangle',expandedBBoxes,'LineWidth',3);
% imshow(IExpandedBBoxes)

overlapRatio = bboxOverlapRatio(expandedBBoxes, expandedBBoxes);
n = size(overlapRatio,1); 
overlapRatio(1:n+1:n^2) = 0;

% Create the graph
g = graph(overlapRatio);

% Find the connected text regions within the graph
componentIndices = conncomp(g);
% Merge the boxes based on the minimum and maximum dimensions.
xmin = accumarray(componentIndices', xmin, [], @min);
ymin = accumarray(componentIndices', ymin, [], @min);
xmax = accumarray(componentIndices', xmax, [], @max);
ymax = accumarray(componentIndices', ymax, [], @max);

for i=1:length(xmin)
    for j=1:length(xmax)
        F(i,j)=abs(xmin(i)-xmax(j));
    end
end
% Compose the merged bounding boxes using the [x y width height] format.
textBBoxes = [xmin ymin xmax-xmin+1 ymax-ymin+1];
ITextRegion = insertShape(I, 'Rectangle', textBBoxes,'LineWidth',3);
% imshow(ITextRegion)

for i=1:length(textBBoxes)
%     area(i,1)=textBBoxes(i,3)*textBBoxes(i,4);
    area=textBBoxes(i,3)*textBBoxes(i,4);
    if area>50               %area criteria:7000
        newtextBBoxes = textBBoxes(i,:);
        I2{i,1} = imcrop(I,newtextBBoxes);BoxCoor(i,:)=textBBoxes(i,:);
    end
end
newITextRegion = insertShape(I, 'Rectangle', BoxCoor,'LineWidth',3);
imshow(newITextRegion);

for i=1:size(I2,1)
    if isempty(I2{i,1})==0
        D=bwmorph(im2bw(I2{i,1}),'open');
%         D=bwmorph(D,'thin');
        txt=ocr(D);
        words{i,1}=txt.Words;
    end
end

for i=1:size(words,1)
    len=length(words{i,1});
    if len==1
        if words{i,1}{1,1}==' '
            words{i,1}=[];
        end
    end
end

p=0;
for i=1:size(I2,1)
    if isempty(I2{i,1})==0 
        if isempty(words{i,1})==1 || sum(isletter(horzcat(words{i,1}{:,1})))<=30%previous val:6
            p=p+1;
%             figure, imshow(I2{i,1});
            baseFileName = sprintf('%d_%d.png',ima,p);
            fullFileName = fullfile('F:\RESEARCH WORKS\journal paper\Recognition of handwritten or printed graphic elements\output_new', baseFileName); 
            imwrite(I2{i,1},fullFileName); 
            fin(i,:)=BoxCoor(i,:);
%             figure, imshow(I2{i,1});
        end
    end
end
end
GraphicRegion = insertShape(I, 'Rectangle', fin,'LineWidth',3);
% for i=1:size(textBBoxes,1)
%     len=length(words{1,i});
%     if len>1
%         for j=1:len
%             let{1,i}{j,1}=isletter(words{1,i}{j,1});
%         end
%     else
%         let{1,i}=isletter(words{1,i});
%     end
% end
% 
% for i=1:size(textBBoxes,1)
%     EXP=0;
%     len=length(words{1,i});
%     if len<=1
%         try
%             length(words{1,i}{1,1});
%             catch ex
%                 if strcmp(ex.identifier,'MATLAB:badsubscript')
%                     EXCP(1,i)=EXP+1;
%                 end
%         end
%     else 
%         EXCP(1,i)=3;
%     end
% end
% 
% for i=1:size(textBBoxes,1)
%     if EXCP(1,i)==0
%         if words{1,i}{1,1}==' '
%             words{1,i}=[];
%         else
%             let{1,i}=isletter(words{1,i}{1,1}); 
%         end
%     end
% end
% 
% for i=1:size(textBBoxes,1)
%     len=length(words{1,i});
%     if len>1
%         for j=1:len
%             if sum(let{1,i}{j,1})>0
%                 textcell{1,i}='text present';
%             end
%         end
%     else
%         if sum(let{1,i})>0
%             textcell{1,i}='text present';
%         end
%     end
% end
% if exist('textcell','var') == 1
%     indx= find(strcmp(textcell,'text present'));
%     for i=1:length(indx)
%         DTBox(i,:)=textBBoxes(indx(1,i),:);
%     end
%     DetectedText = insertShape(I, 'Rectangle', DTBox,'LineWidth',3);
%     figure,imshow(DetectedText)
% end