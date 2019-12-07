# arduino_imu_telemetry
This repository contains all Arduino and Matlab scripts for telemetry usage. There are several code snippets used to gather and manage the data.

## logger.ino
Basic Arduino script to gather data from IMU sensor MPU-6050 and store them in a SD card. In "without buffer" branch, the buffer dimension is 1.

## view_log.m
Basic matlab script to plot and visualize the logged data.

## read_filter_acc.m
Matlab script to plot and filter the signals.
