%put csv's all together


clear 
close all


% Obama

x1 = csvread('MFCC_Data\obama_vid1_test_X.csv');
x2 = csvread('MFCC_Data\obama_vid2_test_X.csv');
x3 = csvread('MFCC_Data\obama_vid3_test_X.csv');
x4 = csvread('MFCC_Data\obama_vid4_test_X.csv');
x5 = csvread('MFCC_Data\obama_vid5_test_X.csv');

y1 = csvread('MFCC_Data\obama_vid1_test_Y.csv');
y2 = csvread('MFCC_Data\obama_vid2_test_Y.csv');
y3 = csvread('MFCC_Data\obama_vid3_test_Y.csv');
y4 = csvread('MFCC_Data\obama_vid4_test_Y.csv');
y5 = csvread('MFCC_Data\obama_vid5_test_Y.csv');


csvwrite('MFCC_Data\obama_merged_X.csv', [x1;x2;x3;x4;x5])
csvwrite('MFCC_Data\obama_merged_Y.csv', [y1;y2;y3;y4;y5])


%trump

x1 = csvread('MFCC_Data\trump_vid1_test_X.csv');
x2 = csvread('MFCC_Data\trump_vid2_test_X.csv');
x3 = csvread('MFCC_Data\trump_vid3_test_X.csv');
x4 = csvread('MFCC_Data\trump_vid4_test_X.csv');
x5 = csvread('MFCC_Data\trump_vid5_test_X.csv');

y1 = csvread('MFCC_Data\trump_vid1_test_Y.csv');
y2 = csvread('MFCC_Data\trump_vid1_test_Y.csv');
y3 = csvread('MFCC_Data\trump_vid1_test_Y.csv');
y4 = csvread('MFCC_Data\trump_vid1_test_Y.csv');
y5 = csvread('MFCC_Data\trump_vid1_test_Y.csv');


csvwrite('MFCC_Data\trump_merged_X.csv', [x1;x2;x3;x4;x5])
csvwrite('MFCC_Data\trump_merged_Y.csv', [y1;y2;y3;y4;y5])




