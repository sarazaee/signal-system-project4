load my_mapset.mat;
myImage = imread('testPic.png');
imwrite(myImage, 'testPic.png');
grayImg = rgb2gray(myImage);


output_image = coding('signal', grayImg, mapset);
