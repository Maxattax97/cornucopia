mm = 1.0;

X = [1, 0, 0];
Y = [0, 1, 0];
Z = [0, 0, 1];
Origin = [0, 0, 0];

// Useful for small distances to maintain manifold geometry.
epsilon = 0.01 * mm;
OS = epsilon;
