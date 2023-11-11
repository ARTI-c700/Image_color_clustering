% Providing an input image
im_input = imread('C:\Users\User\Desktop\ImageClusteringProject\val2014_Out\COCO_val2014_000000114025.jpg');


% Extracting dominant colors using the special function extract_dominant_colors(). 
% The output dominant colors are stored in a variable named dominant_colors_input.

dominant_colors_input = extract_dominant_colors(im_input, 150);



% Reading a collection of images from a directory via imageDatastore()

dataSet = [];
dataDir = "C:\Users\User\Desktop\ImageClusteringProject\val2014_Out";
imds = imageDatastore(dataDir, 'IncludeSubfolders', true, 'FileExtensions', {'.jpg', '.png', '.bmp', '.jpeg'});


% Extracting the dominant colors of each image using extract_dominant_colors() and 
% adding the resulting dominant color information to the matrix dataset.

while hasdata(imds)

    % Read image from the datastore
    im = read(imds);
    % Collect the dominant colors of the image
    dominant_colors = extract_dominant_colors(im, 150);
    
    % Add the dominant colors to the dataset
    dataSet = [dataSet; dominant_colors];
end


% Merging the extracted dominant color data for the input image(s) and 
% database into a single "mergedData" matrix.

mergedData = [dominant_colors_input; dataSet];


% Applying the DBSCAN clustering algorithm to combined dominant color data 
% using specified epsilon (neighborhood radius around a data point) and minPts (minimum number of points needed to create a dense region)

epsilon = 0.001; 
minPts = 1; 

% The resulting cluster labels are stored in labels.
labels = dbscan(mergedData, epsilon, minPts);

% The first data point(s) in the "labels" array are the input images. 
% This line sets inputCluster to the label of the first data point, which corresponds to the input image(s).

inputCluster = labels(1); % The first data point(s) are the embedded images
numClusters = max(labels);


% Finding the cluster(s) with the most dominant colors in common with the input image(s).

% First finding the label for the input image(s) stored in the first element of the labels array. 
% Then counting the number of images in each cluster using the histcounts() function and storing the counts in the clusterCounts array.
clusterCounts = histcounts(labels, numClusters);
clusterDominantColors = zeros(numClusters, size(mergedData, 2));


% For each cluster, find the dominant color feature that occurs most frequently in that cluster and store it in the clusterDominantColors array.
for i = 1:numClusters
    clusterData = mergedData(labels == i, :);
    clusterDominantColors(i, :) = mode(clusterData, 1);
end

% Sorting clusters in descending order of number using the sort() function
[~, sortedClusters] = sort(clusterCounts, 'descend');




for i = 1:length(sortedClusters)

% Here, for each cluster in Sorted order, the code checks whether the cluster is the same as the cluster containing the inserted image(s). 
% If so, the code moves to the next cluster.  
      
    clusterIdx = sortedClusters(i);
    if clusterIdx == inputCluster
        continue;
    end
    
 % Otherwise, it uses the ismember() function to count the number of images 
 % in the cluster that have dominant colors matching the included images.
    clusterData = mergedData(labels == clusterIdx, :);
    numMatches = sum(ismember(clusterData, dominant_colors_input, 'rows'));

       
    % If there are any matches, it displays the file names of the matching images using the fprintf() and disp() functions.
    if numMatches > 0
        matching_files = {};
        for j = 1:size(clusterData, 1)
            if ismember(clusterData(j, :), dominant_colors_input, 'rows')
                matching_files{end+1} = imds.Files{j};
            end
        end
        
        if ~isempty(matching_files)
            fprintf('Images in cluster %d that match the input image(s):\n', clusterIdx);
            disp(matching_files');
        end
        break;
    end
end
