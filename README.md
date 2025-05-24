# Lambda Pillow layer

### An AWS Lambda layer for python's Pillow library.


## Why:

### I created this Pillow layer to be able to concurrently process python Pillow processes in the cloud.
### Why the docker image? The Pillow library requires specific C extensions (.so files like _imaging.cpython-313-x86-64-linux-gnu.so). 
### The dockerfile makes sure those libraries are present in the local os for packaging the Lambda layer, this way we don't get ABI compatibility issues.


## Installation:

### (this installation will be done through the AWS cloudshell. You may use any linux machine of your choice to follow the commands. For Windows/Mac commands may vary.
### To create the lambda layer zipfile, download the Dockerfile and build_layer.sh files.
### In your AWS Cloudshell terminal, create a new directory: `mkdir lambda` (or create a working directory on your local machine)
### Upload the Dockerfile and build_layer.sh files to your cloudshell environment.
### Move these files to the lambda directory: `mv Dockerfile lambda` and `mv build_layer.sh lambda`
### Make the build_layer.sh executable with: `chmod +x build_layer.sh`
### Moment of truth, run: `./build_layer.sh`
### If everything went correctly, you should see a new zipfile created called: `pillow-layer-python312-x86-64.zip`
### Click on the actions dropdown menu in the AWS cloudshell, and download the zipfile.
### Go to the AWS Lambda Layer page (can be found on the left side menu of the Lambda page)
### Click on create layer
### Name your layer whatever you want, choose the zipfile that we downloaded from our cloudshell, and create the layer.
### Next, create your lambda function with the python 3.13 runtime, I created a simple test function that draws a square box and some text onto it in this repo if you want to use it.
### In your lambda function's page, go to Layers, then click on add layers.
### Here our layer should pop up when we pick custom layers, if not, you can specify the ARN of the lambda layer we created and use the ARN option instead.
### Next test your code to make sure everythings working.
### Vuala, now you can use python's pillow module in your AWS Lambda Function!


