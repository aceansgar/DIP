#include <opencv/cv.h>
#include <opencv/highgui.h>
#include <opencv2/highgui.hpp>
#include <iostream>
#include <fstream>
#include <math.h>
#include <cstdio>
#include <cstdlib>
#include <queue>
#include <vector>
#include <set>
#include <windows.h>

#define MAXK 10
#define MAXR 50
#define MAXN 3000000

using namespace cv;
using namespace std;

int sensor_id[MAXR];
Mat RT[MAXR];

int sensor_num, camera_num;
int Width[MAXK], Height[MAXK];
double param[MAXK][10];

int point_num;
double point[MAXN][3];
int c[MAXN][3];

int tr[4][2] = {{0, 1}, {1, 0}, {0, -1}, {-1, 0}};

static double round(double r)
{
	return (r > 0.0) ? floor(r + 0.5) : ceil(r - 0.5);
}

void initialization()
{
	for (int i = 0; i < MAXR; i++) {
		RT[i] = Mat::zeros(4, 4, CV_64FC1);
		RT[i].at<double>(3, 3) = 1;
	}
	return;
}

void CameraParaReader()
{
	ifstream s;
	string path = "../data/camera.txt";
	s.open(path);    // Read all datas from txt
	string str;
	string end;
	string source_index;
	
	s >> str >> sensor_num;
	for (int i = 0; i < sensor_num; i++) {
		s >> str >> str;
		s >> str >> Width[i];
		s >> str >> Height[i];
		for (int j = 0; j < 8; j++) s >> str >> param[i][j];	
	}
	
	s >> str >> camera_num;
	for (int i = 0; i < camera_num; i++) {
		int camera_id;
		s >> str >> camera_id;
		s >> str >> sensor_id[camera_id];
		for (int x = 0; x < 4; x++)
			for (int y = 0; y < 4; y++)
				s >> RT[camera_id].at<double>(x, y);
		invert(RT[camera_id], RT[camera_id]);
	}

	s.close();

	cout << "Read Camera Success!" << endl;

	return;
}

void projection()
{
	string path;

	cout << "Begin to Read Points." << endl;
	FILE* infile = fopen("../data/points.txt", "r");

	if (infile == NULL) {
		cout << "Open File Fail" << endl;
		return;
	}

	fscanf(infile, "%d",&point_num);
	//point_num = 20;
	for (int i = 0; i < point_num; i++) {
		double tmp;
		fscanf(infile, "%lf %lf %lf", &point[i][0], &point[i][1], &point[i][2]);
		fscanf(infile, "%lf %lf %lf", &tmp, &tmp, &tmp);
		fscanf(infile, "%d %d %d", &c[i][0], &c[i][1], &c[i][2]);
		//cout << point[i][0] << ' ' << point[i][1] << ' ' << point[i][2] << endl;
	}
	fclose(infile);
	cout << "Read Success" << endl;

	double X, Y, Z;    // Point in world coordinate
	double t1, t2, t3;    // Do nothing
	int R, G, B;
	int x, y;	// Point in image coordinate
	double z;    // NEEDS ATTENTION, depth of image point (in camera coordinate)

	for (int i = 7; i < 8; i++) {
		Mat proj_res(Height[sensor_id[i]], Width[sensor_id[i]], CV_8UC3);
		Mat image_point;
		Mat world_point;
		Mat K;
		image_point.create(3, 1, CV_64FC1);
		world_point.create(4, 1, CV_64FC1);
		image_point.at<double>(2, 0) = 1; 
		world_point.at<double>(3, 0) = 1;

		K = Mat::zeros(3, 4, CV_64FC1);
		K.at<double>(0, 0) = param[sensor_id[i]][0];
		K.at<double>(1, 1) = param[sensor_id[i]][0];
		K.at<double>(0, 2) = Width[sensor_id[i]] * 0.5 + param[sensor_id[i]][1];
		K.at<double>(1, 2) = Height[sensor_id[i]] * 0.5 + param[sensor_id[i]][2];
		K.at<double>(2 ,2) = 1.0;
		
		for (int j = 0; j < point_num; j++) {
			world_point.at<double>(0, 0) = point[j][0];
			world_point.at<double>(1, 0) = point[j][1];
			world_point.at<double>(2, 0) = point[j][2];
			
			image_point = K * (RT[i] * world_point);
			z = image_point.at<double>(2, 0);
			x = round(image_point.at<double>(0, 0) / z);
			y = round(image_point.at<double>(1, 0) / z);
			

			if (x >= 0 && x < Width[sensor_id[i]] && y >= 0 && y < Height[sensor_id[i]])
			{
				proj_res.at<Vec3b>(y, x)[0] = c[j][2];
				proj_res.at<Vec3b>(y, x)[1] = c[j][1];
				proj_res.at<Vec3b>(y, x)[2] = c[j][0];
			}
		}
		path = "../data/proj_res.bmp";
		imwrite(path, proj_res);
	}
	
	return;
}

void Create_depth()
{
	string path;

	cout << "Begin to Read Points." << endl;
	FILE* infile = fopen("../data/points.txt", "r");

	if (infile == NULL) {
		cout << "Open File Fail" << endl;
		return;
	}

	fscanf(infile, "%d",&point_num);
	//point_num = 20;
	for (int i = 0; i < point_num; i++) {
		double tmp;
		fscanf(infile, "%lf %lf %lf", &point[i][0], &point[i][1], &point[i][2]);
		fscanf(infile, "%lf %lf %lf", &tmp, &tmp, &tmp);
		fscanf(infile, "%d %d %d", &c[i][0], &c[i][1], &c[i][2]);
		//cout << point[i][0] << ' ' << point[i][1] << ' ' << point[i][2] << endl;
	}
	fclose(infile);
	cout << "Read Success" << endl;

	/*********************************************************************************************/

	double X, Y, Z;    // Point in world coordinate
	double t1, t2, t3;    // Do nothing
	int R, G, B;
	int x, y;	// Point in image coordinate
	double z;    // NEEDS ATTENTION, depth of image point (in camera coordinate)

	int i = 15; //set camera position
	Mat proj_res(Height[sensor_id[i]], Width[sensor_id[i]], CV_8UC3);
	Mat proj_dep;
	Mat image_point;
	Mat world_point;
	Mat camera_point;
	Mat K;
	image_point.create(3, 1, CV_64FC1);
	world_point.create(4, 1, CV_64FC1);
	camera_point.create(4, 1, CV_64FC1);
	image_point.at<double>(2, 0) = 1; 
	world_point.at<double>(3, 0) = 1;
	proj_dep = Mat::zeros(Height[sensor_id[i]], Width[sensor_id[i]], CV_64FC1);

	K = Mat::zeros(3, 4, CV_64FC1);
	K.at<double>(0, 0) = param[sensor_id[i]][0];
	K.at<double>(1, 1) = param[sensor_id[i]][0];
	K.at<double>(0, 2) = Width[sensor_id[i]] * 0.5 + param[sensor_id[i]][1];
	K.at<double>(1, 2) = Height[sensor_id[i]] * 0.5 + param[sensor_id[i]][2];
	K.at<double>(2 ,2) = 1.0;
		
	for (int j = 0; j < point_num; j++) {
		world_point.at<double>(0, 0) = point[j][0];
		world_point.at<double>(1, 0) = point[j][1];
		world_point.at<double>(2, 0) = point[j][2];
		
		image_point = K * (RT[i] * world_point);
		z = image_point.at<double>(2, 0);
		x = round(image_point.at<double>(0, 0) / z);
		y = round(image_point.at<double>(1, 0) / z);
			
		camera_point = RT[i] * world_point;

		if (x >= 0 && x < Width[sensor_id[i]] && y >= 0 && y < Height[sensor_id[i]])
		{
			proj_res.at<Vec3b>(y, x)[0] = c[j][2];
			proj_res.at<Vec3b>(y, x)[1] = c[j][1];
			proj_res.at<Vec3b>(y, x)[2] = c[j][0];
			if (proj_dep.at<double>(y, x) == 0 || (camera_point.at<double>(2, 0) > 0 && camera_point.at<double>(2, 0) < proj_dep.at<double>(y, x)))
			{
				proj_dep.at<double>(y, x) = camera_point.at<double>(2, 0);
			}
		}
	}

	cout << "Create projection image..." << endl;

	path = "../data/proj_res.bmp";
	imwrite(path, proj_res);

	/*
	FILE* outfile = fopen("../data/depth.txt", "w");
	for (int i = 0; i < Height[sensor_id[i]]; i++)
	{
		for (int j = 0; j < Width[sensor_id[i]]; j++)
		{
			fprintf(outfile, "%.2lf ", proj_dep.at<double>(i, j));
		}
		fprintf(outfile, "\n");
	}
	fclose(outfile);
	*/

	/**********************************************************************************************************/
	{
		cout << "Flood fill" << endl;

		int H = Height[sensor_id[i]], W = Width[sensor_id[i]];
		queue<int> que;
		//set<int> s;
		
		for (int i = 0; i < H; i++)
			for (int j = 0; j < W; j++)
				if (proj_dep.at<double>(i, j) != 0)
				{
					que.push(i*W+j);
					//s.insert(i*W+j);
				}

		while (!que.empty())
		{
			int tmp = que.front();
			int x = tmp / W;
			int y = tmp % W;
			que.pop();

			for (int k = 0; k < 4; k++)
			{
				int tx = x + tr[k][0];
				int ty = y + tr[k][1];
				//if (0 <= tx && tx < H && 0 <= ty && ty < W && s.find(tx*W+ty) == s.end())
				if (0 <= tx && tx < H && 0 <= ty && ty < W && proj_dep.at<double>(tx, ty) == 0)
				{
					que.push(tx*W+ty);
					//s.insert(tx*W+ty);
					proj_dep.at<double>(tx, ty) = proj_dep.at<double>(x, y);
				}
			}
		}
		//s.clear();

		cout << "Flood fill finish." << endl;
		
		//path = "../data/proj_dep.bmp";
		//imwrite(path, proj_dep);

		/*
		outfile = fopen("../data/depth_after.txt", "w");
		for (int i = 0; i < H; i++)
		{
			for (int j = 0; j < W; j++)
			{
				fprintf(outfile, "%.2lf ", proj_dep.at<double>(i, j));
			}
			fprintf(outfile, "\n");
		}
		fclose(outfile);
		*/
	}

	/*********************************************************************************/
	Mat gray_dep(Height[sensor_id[i]], Width[sensor_id[i]], CV_8UC1);
	{
		cout << "Equalize..." << endl;

		double Max_dep = 0.0;
		int H = Height[sensor_id[i]], W = Width[sensor_id[i]];
		
		for (int i = 0; i < H; i++)
		{
			for (int j = 0; j < W; j++)
				if (proj_dep.at<double>(i, j) > Max_dep)
					Max_dep = proj_dep.at<double>(i, j);
		}
		//这里取反，方便后面做膨胀
		for (int i = 0; i < H; i++)
		{
			for (int j = 0; j < W; j++)
			{
				gray_dep.at<uchar>(i, j) = 255-round(proj_dep.at<double>(i, j) * 255.0 / Max_dep);
			}
		}

		//equalize
		equalizeHist(gray_dep, gray_dep);
		//dilate
		Mat ele = getStructuringElement(MORPH_RECT, Size(5, 5));
		dilate(gray_dep, gray_dep, ele);

		//重新取反
		for (int i = 0; i < H; i++)
			for (int j = 0; j < W; j++)
				gray_dep.at<uchar>(i, j) = 255 - gray_dep.at<uchar>(i, j);

		cout << "Equalization finish." << endl;

		FILE* outfile = fopen("../data/depth.txt", "w");
		for (int i = 0; i < H; i++)
		{
			for (int j = 0; j < W; j++)
			{
				fprintf(outfile, "%d ", gray_dep.at<uchar>(i, j));
			}
			fprintf(outfile, "\n");
		}
		fclose(outfile);

		path = "../data/proj_dep2.bmp";
		imwrite(path, gray_dep);
	}
}

int main()
{
	initialization();
	CameraParaReader();
	//projection();
	Create_depth();
	cout << "Finished" << endl;
	return 0;
}

