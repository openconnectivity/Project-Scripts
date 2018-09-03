# Scripts for OCF Project Development

This repository contains scripts for creating OCF projects in any directory using either IoTivity or IoTivity-lite.

# Installation

To install all the scripts described above, just type the following command.

- curl https://openconnectivity.github.io/Project-Scripts/install.sh | bash

# Setting the OCF Implementation to use

- The following variables MUST be set to point to the directories related to the OCF implementation you want to use in order to run the convenience scripts described below.
  - OCFPATH - This is the absolute directory where the OCF implementation is installed and where all the convenience scripts are found. (This is typically /home/my_user_name/iot or /home/my_user_name/iot-lite)
  - OCFSUBPATH - This is just the final part of OCFPATH, but it is necessary as a way to get the set_implementaion.sh script to work correctly. (This is typically /iot or /iot-lite)
  - PATH - This is the normal search PATH, but it will have OCFPATH prepended to it so the scripts can be found.

- source set_implementation.sh (/iot or /iot-lite) - This will switch the implementation of OCF to use (IoTivity or IoTivity-lite right now). It sets some environment variables that MUST be set for all of the scripts. IT IS CRITICAL to use the "source" command to run this script. That makes it work in the current bash context rather that a temporary one.

# Building and Running Projects

A number of convenience scripts have been written to make the development cycle easier.
1. Run the following development cycle as needed
    1. create_project project_name - create a new project and name it anything you want.
    2. This isn't a script, but you need to "cd project_name" to run all the other scripts.
    3. (optional) Copy the setup.sh from the directory of the sample you want to install into the current project directory
    4. (optional) ./setup.sh - This will load all the necessary stuff to build and run the sample project.
    5. edit_input2.sh - edit the device description input file (project_name.json) if necessary.
    6. gen2.sh - generate the code, introspection file, PICS file, and onboarding file from the device description file.
    7. build2.sh - compile and link everything
    8. edit_code2.sh - edit the server source code if necessary.
    9. reset2.sh - reset the sever to RFOTM by copying a fresh onboarding file
    10. run2.sh - run the currently compiled server in the appropriate directory
2. To test the project, you will need to run a client. Here are some options.
    1. Discover, onboard and control the server using OTGC
    2. Discover, onboard and control the server using DeviceSpy
    3. Test the server using CTT
