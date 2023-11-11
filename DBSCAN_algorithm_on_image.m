% The initial image is loaded into the system:
% in the Image_DataSet directory
img_base = imread('Image_DataSet/COCO_val2014_000000114025.jpg');

% The given image is resized to the specified number of pixels
% (defaults to 360,000 pixels)
% This is useful for faster results on weak computers

outputSize = [600, 600];
img_base = imresize(img_base, outputSize);


% Converting the input image to a double array
% This is the standard format commonly used for image processing and analysis.

img_base = im2double(img_base);


% Extracting the red, green and blue channels of the input image and 
% storing them in separate variables.

redChannel = img_base(:,:,1);
greenChannel = img_base(:,:,2);
blueChannel = img_base(:,:,3);


% The N variable represents the total number of pixels in the image and 
% is calculated by taking the size of the flattened redChannel vector.

N = size(redChannel(:), 1);


% Combining red, green and blue channels into a single Nx3 feature matrix called dataSet.

dataSet = [reshape(redChannel, N, 1), reshape(greenChannel, N, 1), reshape(blueChannel, N, 1)];


% The variables epsilon and minPts are hyperparameters that control the sensitivity and 
% minimum cluster size of the clustering algorithm, respectively.

epsilon = 0.01;
minPts = 5;


% Implementing DBSCAN clustering on the dataSet feature matrix.
% The "labels" variable contains the cluster designations for each data point in the feature matrix.

labels = dbscan(dataSet, epsilon, minPts);


% Creating a 3D scatter plot of clustered data points.
% Each data point is colored based on the RGB values represented by the double(dataSet) argument.
% A *255 product is included to scale the RGB values to the range [0, 255].

figure
scatter3(dataSet(:,1)*255, dataSet(:,2)*255, dataSet(:,3)*255, 25, double(dataSet), 'filled')
title('DBSCAN Clustering')


% The x-axis represents red channel values, the y-axis represents green channel values, and the z-axis represents blue channel values
xlabel('Red')
ylabel('Green')
zlabel('Blue')
axis equal

% Printing the cluster data and calculating the silhouette score
% Note: Silhouette Coefficient or silhouette score is a metric used to calculate the goodness of a clustering technique.
[unique_labels, num_clusters] = print_cluster_info(labels);
silhouetteScore = silhouette(dataSet, labels, 'euclidean');
fprintf('Silhouette score: %.4f\n', mean(silhouetteScore));
