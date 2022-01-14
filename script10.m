

% form factor for red blood cells %
%using Imaging Toolbox%


close all;
%clear all;


img = 'Capture_3.bmp';

im = imread(img);
figure;
imshow(im)
title("original image")

 %convert to hsv- hue-saturation-value
hsvImage = rgb2hsv(im);
% Extract individual color channels.
hChannel = hsvImage(:, :, 1);
sChannel = hsvImage(:, :, 1);
vChannel = hsvImage(:, :, 3);
% Do stuff to the v channel.
% Then, after that recombine the new v channel
% with the old, original h and s channels.
hsvImage2 = cat(3, hChannel, sChannel, vChannel);
% Convert back to rgb.
rgbImage2 = hsv2rgb(hsvImage2);

figure;
imshow(rgbImage2);

title(sprintf('HSV adjusted image of %s',img));      %makes dots
 


fprintf('click twice, once in the center, once at the edge, then press enter. \n ')
im = cropper1(rgbImage2);


%   grayscale !Convert the color image to grayscale
gsim=rgb2gray(im); %new image
figure;
title('Grayscale')
imshow(gsim) %shows new img

%     figure;
imhist(gsim); %histogram of le bright image

%

% ctrl t to uncomment, ctrl r to comment
%
imNew=imadjust(gsim,[0.01 .99]);   %high contrast (more imporant


ThrsIm=imNew>.4;  %change bsim, grayscale greater than 128 value %128A 180b

ThrsIm=~ThrsIm; %inversts
ThrsIm= imclearborder(ThrsIm); %removes border


figure(6);
imshow(ThrsIm)
title(sprintf('Inverted Threshold Image >.4 of %s',img));



ThrsIm= medfilt2(ThrsIm, [4,4], 'zeros');  %noise canceleing needs adjusting                                            %zeros, 'symmetric',indexed
SE=ones(3,15);
%edge detection and linking and more!
Edges=edge(ThrsIm,'sobel', .1); %.1 is probably fine, or a lil less
BridgedEdges=bwmorph(Edges,'bridge',Inf);   %sees no change?
FilledEdges=bwmorph(BridgedEdges,'fill',Inf);
DiagEdges=bwmorph(FilledEdges,'diag',Inf); %try skel
ThinEdges(:,1)=1;                   %not sure about the :
%


SpurlessEdges=bwmorph(DiagEdges,'spur',Inf); %or thin edges

% clean removes isolated pixels
CleanedEdges=bwmorph(SpurlessEdges,'clean');    % missing )
FilledBackground=bwfill(CleanedEdges,3,3,8);

[Labels,numCircles]=bwlabel(FilledBackground); %add ,8      %TODO choose threshold value from median histogram point
mseasurements = regionprops(Labels, 'Area', 'Perimeter','Circularity');



[Labels,numCircles]=bwlabel(CleanedEdges,4);      %TODO choose threshold value from median histogram point


figure;
imshow(Labels);
title('Label image using Sobel edge detection and cleaning');



measurements = regionprops(Labels, 'Area', 'Perimeter');
allAreas = [measurements.Area];
allPerimeters = [measurements.Perimeter];

Labels = imfill(Labels,'holes');
circularity = regionprops(Labels, 'Circularity');
roundness = [circularity.Circularity];





%classification
sizes= zeros (1,numCircles);  % 'creates a 1xnL vector of zeros
for n=1:numCircles
    sizes(n)=length(find(Labels==n));
    
end



content = cat(2,allAreas',allPerimeters',roundness'); % creates an array that lines up data and sizes
filteredContent = content(content(:,1) > 80,:); % new array that keeps rows where in column 1 is greater than 50.

% has area and perimeter, now do the form factor.

filteredContents = filteredContent(filteredContent(:,1) < 2000,:); % new array that keeps rows where in column 1 is greater than 50.



goodCircles = size(filteredContents,1)
otherAvgFF = mean(filteredContent(:,3))


ffactor=zeros(1,goodCircles);
for n=1:goodCircles
    ffactor(n)= (4*3.14159265358979323*filteredContent(n,1)) / ((filteredContent(n,2)*(filteredContent(n,2))));
end

return; % break








