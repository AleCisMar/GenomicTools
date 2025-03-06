#!/usr/bin/env python
import pandas as pd
import argparse

# Set up argument parser
parser = argparse.ArgumentParser(description="Convert a symmetric matrix to an edge list.")
parser.add_argument('-i', '--input', required=True, help="Input CSV file containing the symmetric matrix.")
parser.add_argument('-o', '--output', required=True, help="Output CSV file for the edge list.")
parser.add_argument('-t', '--threshold', type=float, default=0.01, help="Threshold for filtering out Similarity values less than this value.")
args = parser.parse_args()

# Load your symmetric matrix (CSV format)
matrix_file = args.input

# Read the matrix into a DataFrame
df = pd.read_csv(matrix_file, index_col=0)  # Assumes the first column contains row labels

# Ensure the matrix is symmetric
assert df.equals(df.T), "Matrix is not symmetric!"

# Convert to long format (edge list) with 1 - weight transformation
edges = []
for i in range(len(df)):
    for j in range(i + 1, len(df)):  # Only take upper triangle to avoid duplicates
        source, target = df.index[i], df.columns[j]
        weight = df.iloc[i, j]
        similarity = 1 - weight  # Transform dissimilarity into similarity
        if similarity >= args.threshold:  # Apply threshold filter
            edges.append([source, target, similarity])

# Create an edge list DataFrame
edges_df = pd.DataFrame(edges, columns=["Source", "Target", "Similarity"])

# Save as CSV for Cytoscape
output_file = args.output
edges_df.to_csv(output_file, index=False)

print(f"Edge list saved as '{output_file}'! 🎉")
