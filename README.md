# arduino_imu_telemetry
This repository contains all Arduino and Matlab scripts for telemetry usage. There are several code snippets used to gather and manage the data.

## logger.ino
Basic Arduino script to gather data from IMU sensor MPU-6050 and store them in a SD card.

## view_log.m
Basic matlab script to plot and visualize the logged data.

## read_filter_acc.m
Matlab script to plot and filter the signals.

## Telemetria_IMU_Arduino
A PDF guide to italian users.

## optimization folder
Contains a python script that learns, from the caracteristics of the input files, the best dimension for a read/write buffer. There are also the input datasets.

## datasheets folder
Contains documents useful to handle the shields and the arduino.

