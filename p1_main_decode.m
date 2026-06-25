% --- Main Script ---
clc; clear; close all;


load('my_mapset.mat');
myGrayImage = imread('stego_image.png');
block_size = 10; 


decoded_message = decoding(myGrayImage, mapset, block_size);

disp(['Final Decoded message is: ', decoded_message]);
