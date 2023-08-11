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
`docker run -it --rm -p 5901:5901 -p 6080:6080 cellexplorer:latest`
3. After starting the Docker container, access the software via a VNC viewer on your browser. Typically, you can do this by navigating to:
`http://localhost:5901/`
4. When prompted for a password, enter: `matlab`
5. Open a terminal within the Docker environment and start MATLAB by entering:`matlab`
6. Upon starting MATLAB, you will be prompted for a license username and password for MATLAB. Please input your own MATLAB license credentials as these are not provided.
7. Once authenticated, navigate to the `CellExplorer` directory in MATLAB to access and run the application.


### Direct Download (Advanced users)

1. **Software Setup**:
    - Download the software package [CellExplorer.tar.gz] and extract the archive:
      ```
      tar -xzvf CellExplorer.tar.gz
      ```

2. **Environment Setup Using Dockerfile**:
    If you'd like to set up the environment on your machine based on the Dockerfile, follow the steps below:
    - Clone the repository or download the source code containing the `Dockerfile`.
    - Examine the `Dockerfile` to understand the dependencies and installation steps.
    - Manually install the required packages and dependencies listed in the `Dockerfile` on your machine. This might require using package managers like `apt`, `brew`, or `pip`, depending on your system and the specific dependencies.
    - Adjust system settings or configurations as described in the `Dockerfile`, if necessary.
   
3. **Running the Software**:
    - Navigate to the directory where you've extracted `CellExplorer`.
    - Follow the software-specific instructions to launch and operate the tool.

Note: Manual setup requires a deeper understanding of the system's requirements and might be challenging. Ensure you're familiar with the dependencies and configurations before proceeding.

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
Ensure that `indatadirdir` points to the directory where imagedata.tar.gz was extracted.
Then in MATLAB, run the main_CellEplorer script.

## Support

If you encounter any issues or have questions regarding the software, please email us at [li.yongbin@cnu.edu.com](mailto:li.yongbin@cnu.edu.cn).


## Citation

If you find this software useful in your research, please consider citing:

"A 3D digital atlas of C. elegans and its application to single-cell analyses" Nature Methods, doi:[10.1038/nmeth.1366](https://www.nature.com/articles/nmeth.1366), 2009.

## Acknowledgements

Special thanks to Fuhui Long and Hanchuan Peng for their dedication and efforts in developing this software.


