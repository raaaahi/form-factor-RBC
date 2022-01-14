
%cropping function
%function from
%https://www.mathworks.com/matlabcentral/answers/270865-crop-circle-region-from-image
%by KSSV on 8 Jan 2018

function I = cropper1(im)



I = im;
[nx,ny,d] = size(I) ;
[X,Y] = meshgrid(1:ny,1:nx) ;
imshow(I) ;
hold on
[px,py] = getpts ;   % click at the center and approximate Radius
r = sqrt(diff(px).^2+diff(py).^2) ;
th = linspace(0,2*pi) ;
xc = px(1)+r*cos(th) ; 
yc = py(1)+r*sin(th) ; 
plot(xc,yc,'r') ;
% Keep only points lying inside circle
idx = inpolygon(X(:),Y(:),xc',yc) ;
for i = 1:d
    I1 = I(:,:,i) ;
    I1(~idx) = 255 ;
    I(:,:,i) = I1 ;
end
figure
imshow(I)
title('Circular cropped image');



end