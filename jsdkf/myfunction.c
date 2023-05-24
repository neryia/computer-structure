// 323098616 Neryia DayanZada

#include <stdbool.h> 

typedef struct {
   unsigned char red;
   unsigned char green;
   unsigned char blue;
} pixel;

typedef struct {
    int red;
    int green;
    int blue;
    // int num;
} pixel_sum;


/* Compute min and max of two integers, respectively */
int min(int a, int b) { return (a < b ? a : b); }
int max(int a, int b) { return (a > b ? a : b); }

int calcIndex(int i, int j, int n) {
	return ((i)*(n)+(j));
}

/*
 * initialize_pixel_sum - Initializes all fields of sum to 0
 */
pixel_sum initialize_pixel_sum() {
	pixel_sum sum;
	sum.red = 0;
	sum.green = 0;
	sum.blue = 0;
	// sum->num = 0;
	return sum;
}

/*
 * assign_sum_to_pixel - Truncates pixel's new value to match the range [0,255]
 */
static void assign_sum_to_pixel(pixel *current_pixel, pixel_sum sum, int kernelScale) {
// /= instead of x = x / y
	// divide by kernel's weight
	sum.red /= kernelScale;
	sum.green /= kernelScale;
	sum.blue /= kernelScale;

	// truncate each pixel's color values to match the range [0,255]
	current_pixel->red = (unsigned char) (min(max(sum.red, 0), 255));
	current_pixel->green = (unsigned char) (min(max(sum.green, 0), 255));
	current_pixel->blue = (unsigned char) (min(max(sum.blue, 0), 255));
	return;
}

/*
* sum_pixels_by_weight - Sums pixel values, scaled by given weight
*/
// += instead of x = x + y
static void sum_pixels_by_weight(pixel_sum *sum, pixel p, int weight) {
	sum->red += ((int) p.red) * weight;
	sum->green += ((int) p.green) * weight;
	sum->blue += ((int) p.blue) * weight;
	// sum->num++;
	return;
}

/*
 *  Applies kernel for pixel at (i,j)
 */
static pixel applyKernel(int dim, int i, int j, pixel *src, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {

	pixel_sum sum;
	pixel current_pixel;
	int min_intensity = 766; // arbitrary value that is higher than maximum possible intensity, which is 255*3=765
	int max_intensity = -1; // arbitrary value that is lower than minimum possible intensity, which is 0
	int min_row, min_col, max_row, max_col;
	pixel loop_pixel;

	sum = initialize_pixel_sum();

// calculate only 1 time instead n
	int mi = min(i+1, dim-1);
	int mj = min(j+1, dim-1);
	int kRow, kCol;
	int ini = max(i-1, 0), inj = max(j-1, 0);
	int ii = mi, jj = mj;
// countdown and not up 
	for(; ii >= ini; --ii) {
		// compute row index in kernel
		if (ii < i) {
			kRow = 0;			
		} else if (ii > i) {
			kRow = 2;
		} else {
			kRow = 1;
		}
// countdown and not up
		jj = mj;
		for(; jj >= inj; --jj) {

			// compute column index in kernel
			if (jj < j) {
				kCol = 0;
			} else if (jj > j) {
				kCol = 2;
			} else {
				kCol = 1;
			}

			// apply kernel on pixel at [ii,jj]
			sum_pixels_by_weight(&sum, src[calcIndex(ii, jj, dim)], kernel[kRow][kCol]);
// merge two for loops into one
			if (filter) {
				// find min and max coordinates
				int calc = 0;
				// check if smaller than min or higher than max and update
				loop_pixel = src[calcIndex(ii, jj, dim)];
				calc = (((int) loop_pixel.red) + ((int) loop_pixel.green) + ((int) loop_pixel.blue));
				if (calc <= min_intensity) {
					min_intensity = calc;
					min_row = ii;
					min_col = jj;	
				}
				if (calc > max_intensity) {
					max_intensity = calc;
					max_row = ii;
					max_col = jj;
				}
			}
	}
	}
	if (filter) {
		// filter out min and max
		sum_pixels_by_weight(&sum, src[calcIndex(min_row, min_col, dim)], -1);
		sum_pixels_by_weight(&sum, src[calcIndex(max_row, max_col, dim)], -1);
	}

	// assign kernel's result to pixel at [i,j]
	assign_sum_to_pixel(&current_pixel, sum, kernelScale);
	return current_pixel;
}

/*
* Apply the kernel over each pixel.
* Ignore pixels where the kernel exceeds bounds. These are pixels with row index smaller than kernelSize/2 and/or
* column index smaller than kernelSize/2
*/
void smooth(int dim, pixel *src, pixel *dst, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {

	int term = kernelSize / 2, i = dim - term, j = i;
// countdown and not up
	for (; i >= term; --i) {
		j = dim - term;
		for (; j >= term; --j) {
			dst[calcIndex(i, j, dim)] = applyKernel(dim, i, j, src, kernelSize, kernel, kernelScale, filter);
;
		}
	}
}

void charsToPixels(Image *charsImg, pixel* pixels) {

	int row = m -1 , col = n-1, rown = row * n, placei = 0, placej = 0;
	pixel pixeli, pixeli1;

// countdown and not up
	for (; row >= 0 ; --row) {
// countdown and not up and loop unroling
		for (; col >= 0 ; col-=3) {
			placei = rown + col;
			placej = 3*placei;
			pixels[placei].red = image->data[placej];
			pixels[placei].green = image->data[placej + 1];
			pixels[placei].blue = image->data[placej + 2];
			
			--placei;
			placej = 3*placei;
			
			pixels[placei].green = image->data[placej + 1];
			pixels[placei].blue = image->data[placej + 2];
			
			--placei;
			placej = 3*placei;
			pixels[placei].red = image->data[placej];
			pixels[placei].green = image->data[placej + 1];
			pixels[placei].blue = image->data[placej + 2];
		}
// countdown and not up
		for (; col >= 0 ; col) {
			placei = rown + col;
			placej = 3*placei;
			pixels[placei].red = image->data[placej];
			pixels[placei].green = image->data[placej + 1];
			pixels[placei].blue = image->data[placej + 2];
		}
		rown -= n;
	}
}

void pixelsToChars(pixel* pixels, Image *charsImg) {

	int row = m - 1, col = n - 1, rown = row * n, placei = 0, placej = 0;
	// countdown and not up
	for (; row >= 0 ; --row) {
	// countdown and not up and loop unroling
		for (; col >= 0; col -= 3) {
			placei = rown + col;
			placej = 3*placei;
			image->data[placej] = pixels[placei].red;
			image->data[placej + 1] = pixels[placei].green;
			image->data[placej + 2] = pixels[placei].blue;
			
			--placei;
			placej = 3*placei;
			image->data[placej] = pixels[placei].red;
			image->data[placej + 1] = pixels[placei].green;
			image->data[placej + 2] = pixels[placei].blue;
			
			--placei;
			placej = 3*placei;
			image->data[placej] = pixels[placei].red;
			image->data[placej + 1] = pixels[placei].green;
			image->data[placej + 2] = pixels[placei].blue;
		}
		for (; col >= 0 ; --col) {
			placei = rown + col;
			placej = 3*placei;
			image->data[placej] = pixels[placei].red;
			image->data[placej + 1] = pixels[placei].green;
			image->data[placej + 2] = pixels[placei].blue;
		}
		rown -=n;
	}
}

void copyPixels(pixel* src, pixel* dst) {

	int row = m - 1, col = n - 1, rown = row * n, placei = 0;
	// countdown and not up
	for (; row >=0 ; --row) {
	// countdown and not up and loop unroling
		for (; col >= 0 ; col -=3) {
			placei = rown + col;
			dst[placei].red = src[placei].red;
			++placei;
			dst[placei].green = src[placei].green;
			++placei;
			dst[placei].blue = src[placei].blue;
		}
		for (; col >= 0 ; --col) {
			placei = rown + col;
			dst[placei].red = src[placei].red;
			dst[placei].blue = src[placei].blue;
			dst[placei].green = src[placei].green;
		}
		rown +=n;
	}
}

void doConvolution(Image *image, int kernelSize, int kernel[kernelSize][kernelSize], int kernelScale, bool filter) {
// calculate only one times
	int size = m*n*sizeof(pixel);
	pixel* pixelsImg = malloc(size);
	pixel* backupOrg = malloc(size);

	charsToPixels(image, pixelsImg);
	copyPixels(pixelsImg, backupOrg);

	smooth(m, backupOrg, pixelsImg, kernelSize, kernel, kernelScale, filter);

	pixelsToChars(pixelsImg, image);

	free(pixelsImg);
	free(backupOrg);
}

void myfunction(Image *image, char* srcImgpName, char* blurRsltImgName, char* sharpRsltImgName, char* filteredBlurRsltImgName, char* filteredSharpRsltImgName, char flag) {

	/*
	* [1, 1, 1]
	* [1, 1, 1]
	* [1, 1, 1]
	*/
	int blurKernel[3][3] = {{1, 1, 1}, {1, 1, 1}, {1, 1, 1}};

	/*
	* [-1, -1, -1]
	* [-1, 9, -1]
	* [-1, -1, -1]
	*/
	int sharpKernel[3][3] = {{-1,-1,-1},{-1,9,-1},{-1,-1,-1}};

	if (flag == '1') {	
		// blur image
		doConvolution(image, 3, blurKernel, 9, false);

		// write result image to file
		writeBMP(image, srcImgpName, blurRsltImgName);	

		// sharpen the resulting image
		doConvolution(image, 3, sharpKernel, 1, false);
		
		// write result image to file
		writeBMP(image, srcImgpName, sharpRsltImgName);	
	} else {
		// apply extermum filtered kernel to blur image
		doConvolution(image, 3, blurKernel, 7, true);

		// write result image to file
		writeBMP(image, srcImgpName, filteredBlurRsltImgName);

		// sharpen the resulting image
		doConvolution(image, 3, sharpKernel, 1, false);

		// write result image to file
		writeBMP(image, srcImgpName, filteredSharpRsltImgName);	
	}
}

