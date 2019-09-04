1. 安装好你的Matlab软件，请特别关注图像处理工具包Image processing toolbox.

2. 用Matlab函数把附件的greens.jpg图像文件格式转为二进制格式.ppm，并存为greens.ppm。

3. 编写你自己的imread(‘*.ppm’) 函数，来读出步骤2生成的.ppm文件.

4. 提交你的代码，结果和作业报告。


选做：尝试设计你的 .pgm和.pbm读写程序。
（代码见附件）
与ppm类似
pgm是灰度图，所以返回的矩阵I 只是灰度值的二维矩阵，不是RGB，每个点只有对应的一个灰度值
pbm是bitmap，所以图像文件的头部没有灰度最大值，返回的I是0-1矩阵，binary格式下一个bit代表一个点的值
