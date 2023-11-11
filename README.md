# Image_color_clustering
Grouping the colors of a given arbitrary image into clusters and searching for similar images in terms of colors

This project mainly consists of two parts:
The first part is the application of DBSCAN (Density-Based Spatial Clustering of Applications with Noise) clustering algorithm on the input image. The problem it solves is to group pixels in an image that have similar colors using a clustering algorithm. This can be useful for tasks such as image segmentation or identifying regions of an image that have similar color characteristics.
After the clustering is performed, the code plots the resulting clusters in 3D space with colors corresponding to the input image. This can help visualize how the clustering algorithm groups pixels based on their color properties. The code also calculates a silhouette score, which is a measure of how well the clusters are defined and how well they are separated from each other.

-------------------------------------------------------------
DBSCAN algorithm is the main approach applied in this system
A quick explanation of how it works:
1. Select an arbitrary point p from the data set that has not yet been visited.
2. Take all points that are ε from p and add them to the new cluster.
3. If the number of points in the cluster is less than minPts, mark p as a noise point and move to the next unwatched point.
4. If the number of points in the cluster is greater than or equal to minPts, then mark p as the base point and expand the cluster by adding all points within ε distance from p to the cluster.
5. Repeat steps 2-4 until all points are visited.
6. Any unvisited points that are not part of a cluster are marked as noise().
The output of the DBSCAN algorithm is a set of clusters, where each cluster contains a group of points that are close to each other in the high-dimensional space and a set of noise points that do not belong to any cluster.
--------------------------------------------------------------

Suppose this image is entered into the system:
![image](https://github.com/ARTI-c700/Image_color_clustering/assets/87066160/e9f9ee25-c9c8-48de-b6cf-ee8cba02bfc3)

