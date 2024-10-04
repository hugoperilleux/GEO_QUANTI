# Source: https://stats.stackexchange.com/questions/59213/how-to-compute-varimax-rotated-principal-components-in-r
# Jan 14, 2020 at 16:31 Alain Danet


library(factoextra)
library(FactoMineR)

data(decathlon2)
decathlon2.active <- decathlon2[1:23, 1:10]

res.pca <- PCA(decathlon2.active)

rotate_pca <- function(pca, ncp = 2) {
  # Applies Varimax rotation to variable coordinates
  varimax_result <- varimax(pca$var$coord[, 1:ncp])
  pca$var$coord <- varimax_result$loadings

  # Calculation of eigenvalues and percentages of variance
  eigenvalues <- colSums(pca$var$coord^2)
  percentage_of_variance <- eigenvalues *res.pca$eig[ncp,3]/ sum(eigenvalues)
  cumulative_percentage <- cumsum(percentage_of_variance)

  # Updating eig
  pca$eig <- data.frame(
    eigenvalue = eigenvalues,
    percentage_of_variance = percentage_of_variance,
    cumulative_percentage_of_variance = cumulative_percentage
  )

  # Rotation of individual coordinates
  pca$ind$coord <- pca$ind$coord[,1:ncp] %*% varimax_result$rotmat

  return(pca)
}

res.pca2<-rotate_pca(res.pca)

# Visualisation

fviz_pca_var(res.pca)
fviz_pca_var(res.pca2)

fviz_pca_ind(res.pca)
fviz_pca_ind(res.pca2)







