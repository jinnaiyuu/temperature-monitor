temperature-monitor
===================

Temperature monitor for cluster. It pretty much depends on each hardware so that just pulling this code won't work.

What it does

1.
Get the temperature data from lm_sensors and write it into a log file.
The text structure pretty much depends on each OS, so you can work for here to make this code work for ur computer.


2.
Read the log file and calculate the statistics.
The maximum and the average for now.


3.
If the temperature is higher than the threshould, then send an email to call for help.
The script to send an email is not uploaded as it contains our email addresses.
