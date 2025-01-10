%  project title: matlab code for fish disease detection 
% created by Prasanta Das
% date: 25.01.2021

clc;
close all;
clear ;
%read the input image
tic;
 p = imread('013.bmp');
imshow(p), title('Input image');
figure;

%Convert RGB to CIE 1976 L*a*b*
lab_p = rgb2lab(p);
ab = lab_p(:,:,2:3);
%Convert image to single precision
%If the input image is of class single, then the output image is identical. 
%If the input image is of class logical, 
%then im2single changes true-valued elements to 65535.
ab = im2single(ab);
nColors = 3;
% repeat tp clustering 3 times to avoid local minima
pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);

imshow(pixel_labels,[])
title('Image Labeled by Cluster Index');
figure;

%segment by diffrent mask by clustering techniques
mask1 = pixel_labels==1;

% 'uint8'       k <= 255
cluster1 = p .* uint8(mask1);

% shosw the segmented image
imshow(cluster1)

%title of the image
title('Objects in Cluster 1');
figure;

% same as previous
mask2 = pixel_labels==2;
cluster2 = p .* uint8(mask2);
imshow(cluster2)
title('Objects in Cluster 2');
figure;

% same as previous
mask3 = pixel_labels==3;
cluster3 = p .* uint8(mask3);
imshow(cluster3)
title('Objects in Cluster 3');
figure;

L = lab_p(:,:,1);
%Double-precision arrays
L_disease = L .* double(mask3);

%Scale range of array elements
L_disease = rescale(L_disease);

%Binarize 2-D grayscale image or 3-D volume by thresholding
%Nonzero matrix elements
idx_light_disease = imbinarize(nonzeros(L_disease));

%Find indices and values of nonzero elements
disease_idx = find(mask3);
mask_dark_disease = mask3;
mask_dark_disease(disease_idx(idx_light_disease)) = 0;

disease_object = p .* uint8(mask_dark_disease);
imshow(disease_object)
%title('disease object');
%figure;
toc;



% some important values

Entropy = entropy(disease_object);
Mean = mean2(disease_object);
Standard_Deviation = std2(disease_object);
RMS = mean2(rms(disease_object));
Variance = mean2(var(double(disease_object)));
pd = sum(double(disease_object(:)));
Smoothness = 1-(1/(1+pd));
Kurtosis = kurtosis(double(disease_object(:)));
Skewness = skewness(double(disease_object(:)));
