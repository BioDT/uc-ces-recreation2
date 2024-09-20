# load required packages
library(raster)
library(ggplot2)
library(scales)

# Load your raster data
raster_data <- raster("/data/notebooks/rstudio-rp2r/testp/RP_Scotland/output/recreation_potential_Inshriach_SR.tif")

# Calculate quantiles
quantiles <- quantile(raster_data, probs = seq(0, 1, length.out = 8), na.rm = TRUE)

# Normalize quantiles to range between 0 and 1
quantiles_normalized <- scales::rescale(quantiles, to = c(0, 1))

# Categorize raster values into 7 categories based on quantiles
raster_categorized <- cut(values(raster_data), breaks = quantiles, include.lowest = TRUE, labels = FALSE)

# Create a new raster with categorized values
raster_data_categorized <- setValues(raster_data, raster_categorized)

# Define colors for 7 categories
category_colors <- c("#3b1f47", "#a892b2", "#c2b5a6", "#f7ef99", "#cbcb6d",  "#8a9f49", "#325e20")

# Create labels for the categories based on the quantiles
category_labels <- paste0(round(quantiles_normalized[-8], 2), " - ", round(quantiles_normalized[-1], 2))

# Convert raster to a data frame for ggplot2
raster_df <- as.data.frame(raster_data_categorized, xy = TRUE)
colnames(raster_df)[3] <- "category"

# Filter out NA values for plotting
raster_df <- raster_df[!is.na(raster_df$category), ]

# Plot using ggplot2
ggplot() +
  geom_raster(data = raster_df, aes(x = x, y = y, fill = factor(category)), show.legend = TRUE) +
  scale_fill_manual(values = category_colors, labels = category_labels) +
  coord_fixed() +
  theme_minimal() +
  theme(axis.title = element_blank(), axis.text = element_blank(), axis.ticks = element_blank(), 
        panel.grid = element_blank(), plot.title = element_text(hjust = 0.5), legend.key = element_blank()) +
  labs(title = "Raster Categorized by Quantiles", fill = "Recreational Potential")
