# The following commands where run on R

# If domain_count.tsv is in the working directory:
gene_content <- read.delim("domain_count.tsv", check.names = FALSE, row.names = 1)
gene_content_mat <- as.matrix(gene_content)
mat_cluster_cols <- hclust(dist(t(gene_content_mat)))

library(dendsort)

sort_hclust <- function(...) as.hclust(dendsort(as.dendrogram(...)))
mat_cluster_cols <- sort_hclust(mat_cluster_cols)
mat_cluster_rows <- sort_hclust(hclust(dist(gene_content_mat)))

library(pheatmap)

# Change filename as needed
pheatmap(gene_content_mat, scale = "row", clustering_distance_rows = "correlation", clustering_distance_cols = "correlation", clustering_method = "average", border_color = NA, cluster_rows = mat_cluster_rows, cluster_cols = mat_cluster_cols, fontsize_col = 1, fontsize_row = 1,color = colorRampPalette(c("blue","white","red"))(100), cellwidth = 1, cellheight = 1, filename = "Heatmap/pheatmap_correlation_upgma.pdf")
pheatmap(gene_content_mat, scale = "row", clustering_distance_rows = "correlation", clustering_distance_cols = "correlation", clustering_method = "average", border_color = NA, cluster_rows = mat_cluster_rows, cluster_cols = mat_cluster_cols, fontsize_col = 1, fontsize_row = 1,color = colorRampPalette(c("blue","white","red"))(100), cellwidth = 1, cellheight = 1, filename = "Heatmap/pheatmap_correlation_upgma_cut20.pdf", cutree_cols = 20)
pheatmap(gene_content_mat, scale = "row", clustering_distance_rows = "correlation", clustering_distance_cols = "correlation", clustering_method = "average", border_color = NA, cluster_rows = mat_cluster_rows, cluster_cols = mat_cluster_cols, fontsize_col = 1, fontsize_row = 1,color = colorRampPalette(c("blue","white","red"))(100), cellwidth = 1, cellheight = 1, filename = "Heatmap/pheatmap_correlation_upgma_cut40.pdf", cutree_cols = 40)
pheatmap(gene_content_mat, scale = "row", clustering_distance_rows = "correlation", clustering_distance_cols = "correlation", clustering_method = "average", border_color = NA, cluster_rows = mat_cluster_rows, cluster_cols = mat_cluster_cols, fontsize_col = 1, fontsize_row = 1,color = colorRampPalette(c("blue","white","red"))(100), cellwidth = 1, cellheight = 1, filename = "Heatmap/pheatmap_correlation_upgma_cut60.pdf", cutree_cols = 60)

# The pheatmap row scale is intended to highlight domains that are more abundant in particular genomes. It is calculated by multiplying each value by the row mean and dividing the product by the row standard deviation. Values above the mean will produce positive values, while values below the mean will produce negative values. The coloring scheme produces two kinds of rows: 1) rows dominated by white cells (mostly indicative of absence) and one or two intense red cells, which is indicative of a narrowly distributed domain that is only present (not necessarily in great abundance. Could be = 1) in one or two genomes and; 2) rows dominated by blue cells (not necessarily representing absence but low abundance) and a smaller number of reddish cells (often more than two), which is indicative of a widely distributed domain that is very abundant in some genomes. Therefore, the heat map is read by rows and should not be used to compare the abundance of two or more genes within the same genome (by columns).
