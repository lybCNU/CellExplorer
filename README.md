# CellExplorer
**CellExplorer** is a package of computer programs to process and analyze 3D confocal image stacks of the model animal C. elegans, and can be applied to several other model systems such as fruit fly embryo/larvae as well. Some other applications include 3D cell/nuclei segmentation, quantification, gene expression analysis, automatic cell naming/annotation, cell targeting, etc. 

# Developer
Fuhui Long and Hanchuan Peng

# Requirements
Windows / Linux / Mac OsX

matlab

## Installation

While the software can be directly extracted and run after downloading, it comes with numerous dependencies which may cause issues in certain systems. To address this and ensure seamless usability across platforms, we provide a Dockerfile. 

### Docker Installation (Recommended)

For those familiar with Docker, a `Dockerfile` has been provided to streamline the installation process and manage dependencies, ensuring consistent behavior across any system.

1. Build the Docker image:
`docker build -t cellexplorer:latest .`
2. Once the image is built, run the container:
`docker run -it --name cell_explorer_container cellexplorer:latest`

### Direct Download (Advanced users)
Download the software package `CellExplorer.tar.gz` and extract the archive.

## Test with Sample Data
1. Download the test data: `imagedata.tar.gz`.
2. Extract the archive:
`tar -xzvf imagedata.tar.gz`
3. Set up the test environment:
- Open MATLAB.
- Navigate and open the `main_CellEplorer.m` file.
- Modify lines 19-24 to match the following:

```matlab
indatadirdir = '/home/matlab/data/in/';

outdatadirdir = '/home/matlab/data/TempData/';
outdatadirdir2 = '/home/matlab/data/TempData/';
outdatadirwano = '/home/matlab/data/TempData/';
wanodirroot = '/home/matlab/data/out/';
```
Ensure that indatadirdir points to the directory where imagedata.tar.gz was extracted.
Then in MATLAB, run the main_CellEplorer script.

## Citation

If you find this software useful in your research, please consider citing:

"A 3D digital atlas of C. elegans and its application to single-cell analyses" Nature Methods, doi:[10.1038/nmeth.1366](https://www.nature.com/articles/nmeth.1366), 2009.

## Acknowledgements

Special thanks to Fuhui Long and Hanchuan Peng for their dedication and efforts in developing this software.


